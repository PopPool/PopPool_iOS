//
//  MyPageMainVM.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/14/24.
//

import Foundation
import RxSwift
import UIKit

final class MyPageMainVM: ViewModelable {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    // MARK: - Propoerties
    var disposeBag = DisposeBag()
    var menuList: [any TableViewSectionable] {
        get {
            // 로그인 유무에 따라 List 변경
            if true {
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
    
    // MARK: - transform
    func transform(input: Input) -> Output {
        myCommentSection.sectionOutput().didTapRightButton
            .subscribe { _ in
                print("MyComment section Button Tapped")
            }
            .disposed(by: disposeBag)
        
        myCommentSection.sectionCellOutput.subscribe { (output, indexPath) in
            output.didSelectCell.subscribe { cellIndexPath in
                print(indexPath,cellIndexPath)
            }
            .disposed(by: self.disposeBag)
        }
        .disposed(by: disposeBag)
        
        return Output()
    }
}
