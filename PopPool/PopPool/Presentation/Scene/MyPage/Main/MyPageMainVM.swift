//
//  MyPageMainVM.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/14/24.
//

import RxSwift
import UIKit
import RxCocoa

final class MyPageMainVM: ViewModelable {
    
    struct Input {
        var logoutButtonTapped: ControlEvent<Void>
        var settingButtonTapped: ControlEvent<Void>
        var cellTapped: ControlEvent<IndexPath>
        var profileLoginButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        var myPageAPIResponse: BehaviorRelay<GetMyPageResponse>
        var moveToVC: PublishSubject<BaseViewController>
        var moveToLoginVC: Observable<Void>
        var moveToSettingVC: PublishSubject<UserUseCase>
        var logout: PublishSubject<Void>
    }
    
    // MARK: - Propoerties
    var disposeBag = DisposeBag()
    
    var userUseCase: UserUseCase = AppDIContainer.shared.resolve(type: UserUseCase.self)
    
    var myPageAPIResponse: BehaviorRelay<GetMyPageResponse> = .init(
        value: .init(popUpInfoList: [], isLogin: true, isAdmin: false)
    )
    
    var menuList: [any TableViewSectionable] {
        get {
            // 내 코멘트 없을 경우 분기
            if self.myPageAPIResponse.value.popUpInfoList.isEmpty {
                return [
                    normalSection,
                    informationSection,
                    etcSection
                ]
            } else {
                return [
                    myCommentSection,
                    normalSection,
                    informationSection,
                    etcSection
                ]
            }
        }
        set {
            
        }
    }
    
    // MARK: - MenuSection
    // 내 코멘트 Section
    var myCommentSection = MyCommentCircleListCellSection(
        sectionInput: .init(sectionTitle: "내 코멘트"),
        sectionCellInputList: []
    )
    // 일반 Section
    private var normalSection = MenuListCellSection(
        sectionInput: .init(sectionTitle: "일반"),
        sectionCellInputList: [
            .init(title: "찜한 팝업"),
            .init(title: "최근 본 팝업"),
            .init(title: "차단한 사용자 관리"),
        ])
    // 정보 Section
    private var informationSection = MenuListCellSection(
        sectionInput: .init(sectionTitle: "정보"),
        sectionCellInputList: [
            .init(title: "공지사항"),
            .init(title: "고객문의"),
            .init(title: "약관"),
            .init(title: "버전정보", isVersionCell: true),
        ])
    // etc Section
    private var etcSection = MenuListCellSection(
        sectionInput: .init(),
        sectionCellInputList: [
            .init(title: "회원탈퇴")
        ])
    
    // MARK: - transform
    func transform(input: Input) -> Output {
        
        myPageAPIResponse
            .withUnretained(self)
            .subscribe { (owner, myPageResponse) in
                print(myPageResponse)
                owner.myCommentSection.sectionCellInputList = [
                    .init(cellInputList: myPageResponse.popUpInfoList.map{ .init(
                        title: $0.popUpStoreName,
                        // TODO: - isActive 부분 논의 후 수정 필요
                        isActive: false,
                        imageURL: $0.mainImageUrl)
                    })
                ]
                if myPageResponse.isAdmin {
                    owner.etcSection.sectionCellInputList = [
                        .init(title: "회원탈퇴"),
                        .init(title: "관리자 메뉴 바로가기")
                    ]
                }
            }
            .disposed(by: disposeBag)
        
        let moveToSettingVC: PublishSubject<UserUseCase> = .init()
        // SettingButtonTapped
        input.settingButtonTapped
            .withUnretained(self)
            .subscribe { (owner, _) in
                moveToSettingVC.onNext(owner.userUseCase)
            }
            .disposed(by: disposeBag)
        
        let moveToVC: PublishSubject<BaseViewController> = .init()
        myCommentSection.sectionOutput().didTapRightButton
            .withUnretained(self)
            .subscribe { (owner, _) in
                let vm = MyCommentedPopUpVM(userUseCase: owner.userUseCase)
                let vc = MyCommentedPopUpVC(viewModel: vm)
                moveToVC.onNext(vc)
            }
            .disposed(by: disposeBag)
        
        myCommentSection.sectionCellOutput
            .withUnretained(self)
            .subscribe { (owner, cellOutput) in
                let output = cellOutput.0
                let indexPath = cellOutput.1
                output.didSelectCell.subscribe { cellIndexPath in
                    print(indexPath,cellIndexPath)
                }
                .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        input.cellTapped
            .withUnretained(self)
            .subscribe(onNext: { (owner, indexPath) in
                if let input = owner.menuList[indexPath.section].sectionCellInputList[indexPath.row] as? MenuListCell.Input {
                    if let title = input.title {
                        if title != "버전정보" {
                            let vc = owner.connectVC(title: title)
                            moveToVC.onNext(vc)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        
        input.profileLoginButtonTapped
            .withUnretained(self)
            .subscribe { (owner, _) in
                print("LoginButtonTapped")
            }
            .disposed(by: disposeBag)
        
        let logoutResponse: PublishSubject<Void> = .init()
        input.logoutButtonTapped
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.userUseCase.logOut()
                    .subscribe {
                        print("logout Success")
                        let keyChainService = KeyChainServiceImpl()
                        keyChainService.saveToken(type: .accessToken, value: "logout")
                            .subscribe {
                                print("accessTokenRemove")
                            } onError: { _ in
                                print("accessTokenRemove Fail")
                            }
                            .disposed(by: owner.disposeBag)
                        
                        keyChainService.saveToken(type: .refreshToken, value: "logout")
                            .subscribe {
                                print("refreshTokenRemove")
                            } onError: { _ in
                                print("refreshTokenRemove Fail")
                            }
                            .disposed(by: owner.disposeBag)
                        logoutResponse.onNext(())
                    } onError: { _ in
                        print("logout Fail")
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        return Output(
            myPageAPIResponse: myPageAPIResponse,
            moveToVC: moveToVC,
            moveToLoginVC: input.profileLoginButtonTapped.asObservable(),
            moveToSettingVC: moveToSettingVC,
            logout: logoutResponse
        )
    }
    
    func connectVC(title: String) -> BaseViewController {
        if title == "찜한 팝업" {
            let vm = FavoritePopUpVM(userUseCase: userUseCase)
            let vc = FavoritePopUpVC(viewModel: vm)
            return vc
        } else if title == "최근 본 팝업" {
            let vm = RecentPopUpVM(userUseCase: userUseCase)
            let vc = RecentPopUpVC(viewModel: vm)
            return vc
        } else if title == "내가 모은 배지" {
            // TODO: - 추후 연결필요
            return BaseViewController()
        } else if title == "차단한 사용자 관리" {
            let vm = BlockedUserVM(useUseCase: userUseCase)
            let vc = BlockedUserVC(viewModel: vm)
            return vc
        } else if title == "알림 설정" {
            let vm = AlarmSettingVM()
            let vc = AlarmSettingVC(viewModel: vm)
            return vc
        } else if title == "공지사항" {
            return NoticeBoardVC(viewModel: NoticeBoardVM())
        } else if title == "고객문의" {
            let vm = InquiryVM()
            let vc = InquiryVC(viewModel: vm)
            return vc
        } else if title == "약관" {
            return TermsBoardVC(viewModel: TermsBoardVM())
        } else if title == "회원탈퇴" {
            return SignOutVC(viewModel: SignOutVM())
        } else if title == "관리자 메뉴 바로가기" {
            return AdminManagementVC()
        } else {
            return BaseViewController()
        }
    }
}
