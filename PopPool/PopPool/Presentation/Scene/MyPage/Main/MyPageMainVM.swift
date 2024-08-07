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
        var cellTapped: ControlEvent<IndexPath>
        var profileLoginButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        var myPageAPIResponse: BehaviorRelay<GetMyPageResponse>
        var moveToVC: PublishSubject<BaseViewController>
    }
    
    // MARK: - Propoerties
    var disposeBag = DisposeBag()
    
    var myPageAPIResponse: BehaviorRelay<GetMyPageResponse>
    
    var menuList: [any TableViewSectionable] {
        get {
            // 로그인 유무에 따라 List 변경
            if self.myPageAPIResponse.value.login {
                return [
                    myCommentSection,
                    normalSection,
                    informationSection,
                    etcSection
                ]
            } else {
                return [
                    informationSection
                ]
            }
        }
        set {
            
        }
    }
    
    // MARK: - MenuSection
    // 내 코멘트 Section
    private var myCommentSection = MyCommentCircleListCellSection(
        sectionInput: .init(sectionTitle: "내 코멘트"),
        sectionCellInputList: [
            .init(cellInputList: [
                .init(title: "팝업스토어1", isActive: true, image: UIImage(systemName: "person")),
                .init(title: "팝업스토어2", isActive: false, image: UIImage(systemName: "person")),
                .init(title: "팝업스토어3", isActive: false, image: UIImage(systemName: "person")),
                .init(title: "팝업스토어4", isActive: false, image: UIImage(systemName: "person")),
                .init(title: "팝업스토어5", isActive: false, image: UIImage(systemName: "person")),
                .init(title: "팝업스토어6", isActive: false, image: UIImage(systemName: "person")),
            ])
        ])
    // 일반 Section
    private var normalSection = MenuListCellSection(
        sectionInput: .init(sectionTitle: "일반"),
        sectionCellInputList: [
            .init(title: "찜한 팝업"),
            .init(title: "최근 본 팝업"),
            .init(title: "내가 모은 배지"),
            .init(title: "차단한 사용자 관리"),
            .init(title: "알림 설정"),
        ])
    // 정보 Section
    private var informationSection = MenuListCellSection(
        sectionInput: .init(sectionTitle: "정보"),
        sectionCellInputList: [
            .init(title: "공지사항"),
            .init(title: "고객문의"),
            .init(title: "약관"),
            .init(title: "버전정보"),
        ])
    // etc Section
    private var etcSection = MenuListCellSection(
        sectionInput: .init(),
        sectionCellInputList: [
            .init(title: "회원탈퇴")
        ])
    
    init(response: GetMyPageResponse) {
        self.myPageAPIResponse = .init(value: response)
    }
    // MARK: - transform
    func transform(input: Input) -> Output {
        let moveToVC: PublishSubject<BaseViewController> = .init()
        myCommentSection.sectionOutput().didTapRightButton
            .subscribe { _ in
                print("MyComment section Button Tapped")
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
                .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        
        input.cellTapped
            .withUnretained(self)
            .subscribe(onNext: { (owner, indexPath) in
                if let input = owner.menuList[indexPath.section].sectionCellInputList[indexPath.row] as? MenuListCell.Input {
                    if let title = input.title {
                        let vc = owner.connectVC(title: title)
                        moveToVC.onNext(vc)
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
        return Output(
            myPageAPIResponse: myPageAPIResponse,
            moveToVC: moveToVC
        )
    }
    
    func connectVC(title: String) -> BaseViewController {
        print("SelectedTitle: \(title)")
        if title == "찜한 팝업" {
            return FavoritePopUpVC()
        } else if title == "최근 본 팝업" {
            return RecentPopUpVC()
        } else if title == "내가 모은 배지" {
            return BaseViewController()
        } else if title == "차단한 사용자 관리" {
            return BlockedUserVC(viewModel: BlockedUserVM())
        } else if title == "알림 설정" {
            return BaseViewController()
        } else if title == "공지사항" {
            return NoticeBoardVC(viewModel: NoticeBoardVM())
        } else if title == "고객문의" {
            return BaseViewController()
        } else if title == "약관" {
            return BaseViewController()
        } else if title == "회원탈퇴" {
            return SignOutVC()
        } else {
            return BaseViewController()
        }
    }
}
