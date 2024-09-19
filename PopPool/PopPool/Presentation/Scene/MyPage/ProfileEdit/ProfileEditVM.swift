//
//  ProfileEditVM.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/13/24.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa

final class ProfileEditVM: ViewModelable {

    struct Input {
        var viewWillAppear: PublishSubject<Void>
        var nickNameState: Observable<ValidationTextFieldCPNT.ValidationState>
        var nickNameButtonTapped: ControlEvent<Void>
        var instaLinkText: ControlProperty<String>
        var introText: PublishSubject<DynamicTextViewCPNT.TextViewState>
        var saveButtonTapped: ControlEvent<Void>
        var imageChanges: PublishSubject<UIImage>
    }
    
    struct Output {
        var originUserData: PublishSubject<GetProfileResponse>
        var nickNameState: PublishSubject<ValidationTextFieldCPNT.ValidationState>
        var saveButtonIsActive: BehaviorRelay<Bool>
    }
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    private var originUserData: PublishSubject<GetProfileResponse> = .init()
    
    var originUserDataStatic: GetProfileResponse = .init(nickname: "", gender: "", age: 0, interestCategoryList: [])
    
    private var newUserData: BehaviorRelay<GetProfileResponse> = .init(
        value: .init(
            nickname: "",
            gender: "",
            age: 0,
            interestCategoryList: []
        )
    )
    var userUseCase: UserUseCase
    
    private var signUpUseCase: SignUpUseCase = AppDIContainer.shared.resolve(type: SignUpUseCase.self)
    
    private var saveButtonIsActive: BehaviorRelay<Bool> = .init(value: false)
    
    private var isValidNickName: Bool = true
    
    private var isValidIntro: Bool = true
    
    private var saveImage: UIImage?
    
    // MARK: - init
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {

        let nickNameState: PublishSubject<ValidationTextFieldCPNT.ValidationState> = .init()
        input.imageChanges
            .withUnretained(self)
            .subscribe { (owner, image) in
                owner.saveImage = image
                var newUserData = owner.newUserData.value
                let profileImagePath = "ProfileImage/\(Constants.userId)/\(Date.now)"
                newUserData.profileImageUrl = profileImagePath
                owner.newUserData.accept(newUserData)
            }
            .disposed(by: disposeBag)
        input.viewWillAppear
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.userUseCase.fetchProfile(userId: Constants.userId)
                    .subscribe { profileResponse in
                        owner.originUserDataStatic = profileResponse
                        owner.originUserData.onNext(profileResponse)
                        owner.newUserData.accept(profileResponse)
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        input.nickNameState
            .withUnretained(self)
            .subscribe { (owner, state) in
                var changeData = owner.newUserData.value
                switch state {
                case .valid(let nickName):
                    changeData.nickname = nickName
                    owner.isValidNickName = true
                    owner.newUserData.accept(changeData)
                case .requestButtonTap(let nickName):
                    changeData.nickname = nickName
                    owner.isValidNickName = false
                    owner.newUserData.accept(changeData)
                case .myNickName, .myNickNameActive:
                    changeData.nickname = owner.originUserDataStatic.nickname
                    owner.isValidNickName = true
                    owner.newUserData.accept(changeData)
                default:
                    owner.isValidNickName = false
                }
            }
            .disposed(by: disposeBag)
        
        input.nickNameButtonTapped
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.signUpUseCase.checkNickName(nickName: owner.newUserData.value.nickname)
                    .subscribe { isDuplicate in
                        nickNameState.onNext(isDuplicate ? .buttonTapError: .valid(owner.newUserData.value.nickname))
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        input.instaLinkText
            .withUnretained(self)
            .subscribe { (owner, instaText) in
                var newData = owner.newUserData.value
                newData.instagramId = instaText.isEmpty ? nil : instaText
                owner.newUserData.accept(newData)
            }
            .disposed(by: disposeBag)
        
        input.introText
            .withUnretained(self)
            .subscribe { (owner, state) in
                var newData = owner.newUserData.value
                switch state {
                case .normal_active(let text):
                    owner.isValidIntro = true
                    newData.intro = text
                    owner.newUserData.accept(newData)
                case .normal(let text):
                    owner.isValidIntro = true
                    newData.intro = text
                    owner.newUserData.accept(newData)
                case .overText, .overText_active:
                    owner.isValidIntro = false
                    newData.intro = nil
                    owner.newUserData.accept(newData)
                default:
                    owner.isValidIntro = true
                    newData.intro = nil
                    owner.newUserData.accept(newData)
                }
            }
            .disposed(by: disposeBag)
        
        newUserData
            .withUnretained(self)
            .subscribe { (owner, userData) in
                if owner.isChangeUserProfile() {
                    if owner.isValidNickName && owner.isValidIntro {
                        owner.saveButtonIsActive.accept(true)
                    } else {
                        owner.saveButtonIsActive.accept(false)
                    }
                } else {
                    owner.saveButtonIsActive.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.saveButtonTapped
            .withUnretained(self)
            .subscribe { (owner, _) in
                let newProfile = owner.newUserData.value
                let imageUploader = PreSignedService()
                guard let uploadImage = owner.saveImage,
                      let uploadPath = newProfile.profileImageUrl else { return }
                
                imageUploader.tryUpload(datas: [.init(
                    filePath: uploadPath,
                    image: uploadImage
                )])
                .subscribe(onSuccess: { _ in
                    print("imageUpload Success")
                    owner.userUseCase.updateMyProfile(
                        userId: Constants.userId,
                        profileImage: newProfile.profileImageUrl,
                        nickname: newProfile.nickname,
                        email: newProfile.email,
                        instagramId: newProfile.instagramId,
                        intro: newProfile.intro
                    )
                    .subscribe {
                        if let lastProfilePath = owner.originUserDataStatic.profileImageUrl {
                            imageUploader.tryDelete(targetPaths: .init(objectKeyList: [lastProfilePath]))
                        }
                        owner.originUserData.onNext(newProfile)
                        owner.originUserDataStatic = newProfile
                        owner.saveButtonIsActive.accept(false)
                        ToastMSGManager.createToast(message: "내용을 저장했어요")
                    } onError: { error in
                        ToastMSGManager.createToast(message: "NetWork Error")
                        imageUploader.tryDelete(targetPaths: .init(objectKeyList: [uploadPath]))
                            .subscribe {
                                print("delete Success")
                            } onError: { error in
                                print(error.localizedDescription)
                            }
                            .disposed(by: owner.disposeBag)
                    }
                    .disposed(by: owner.disposeBag)
                },onFailure: { uploadError in
                    print(uploadError.localizedDescription)
                })
                .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        return Output(
            originUserData: originUserData,
            nickNameState: nickNameState,
            saveButtonIsActive: saveButtonIsActive
        )
    }
    
    func isChangeUserProfile() -> Bool {
        let newUserProfile = newUserData.value
        let originUserProfile = originUserDataStatic
        
        if newUserProfile.nickname == originUserProfile.nickname {
            if newUserProfile.instagramId == originUserProfile.instagramId {
                if newUserProfile.intro == originUserProfile.intro {
                    if newUserProfile.profileImageUrl == originUserProfile.profileImageUrl {
                        return false
                    }
                    return true
                } else {
                    return true
                }
            } else {
                return true
            }
        } else {
            return true
        }
    }
}
