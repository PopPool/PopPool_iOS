//
//  MyCommentCircleListCellSection.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/15/24.
//

import UIKit
import RxSwift
import RxCocoa

// TODO: - 수정필요
struct MyCommentCircleListCellSection: TableViewSectionable {
    
    struct Input {
        var sectionTitle: String?
    }
    
    struct Output {
        var didTapRightButton: ControlEvent<Void>
    }
    
    typealias CellType = MyCommentCircleListCell
    
    var sectionInput: Input
    
    var sectionCellInputList: [MyCommentCircleListCell.Input]
    
    var sectionCellOutput: PublishSubject<(MyCommentCircleListCell.Output, IndexPath)> = .init()
    
    lazy var titleView: ListTitleViewCPNT = {
        let view = ListTitleViewCPNT(title: sectionInput.sectionTitle, size: .medium)
        view.titleLabel.font = .KorFont(style: .bold, size: 16)
        return view
    }()
    
    mutating func makeHeaderView() -> UIView? {
        let containerView = UIView()
        containerView.backgroundColor = .systemBackground
        containerView.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constants.spaceGuide.small100)
        }
        return containerView
    }
    
    mutating func sectionOutput() -> Output {
        return Output(didTapRightButton: titleView.rightButton.rx.tap)
    }
    
    func makeFooterView() -> UIView? {
        return nil
    }
}
