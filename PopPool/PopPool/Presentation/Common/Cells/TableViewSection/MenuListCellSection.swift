//
//  MenuListCellSection.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/15/24.
//

import UIKit
import RxSwift
import SnapKit

struct MenuListCellSection: TableViewSectionable {
    
    struct Input {
        var sectionTitle: String?
    }
    
    struct Output {
    }
    
    typealias CellType = MenuListCell
    
    
    var sectionInput: Input
    
    var sectionCellOutput: PublishSubject<(MenuListCell.Output, IndexPath)> = .init()
    
    var sectionCellInputList: [MenuListCell.Input]

    func makeHeaderView() -> UIView? {
        let containerView = UIView()
        let titleView = ListTitleViewCPNT(title: sectionInput.sectionTitle, size: .medium)
        titleView.titleLabel.font = .KorFont(style: .bold, size: 16)
        titleView.rightButton.isHidden = true
        let topView = UIView()
        containerView.backgroundColor = .systemBackground
        topView.backgroundColor = .g50

        containerView.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.spaceGuide.small100)
        }
        if sectionInput.sectionTitle != nil {
            containerView.addSubview(titleView)
            titleView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(20)
                make.top.equalTo(topView.snp.bottom).offset(Constants.spaceGuide.small400)
                make.bottom.equalToSuperview().inset(Constants.spaceGuide.small400)
            }
        } else {
            topView.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(Constants.spaceGuide.small400)
            }
        }
        return containerView
    }
    
    func sectionOutput() -> Output {
        return Output()
    }
    
    func makeFooterView() -> UIView? {
        return nil
    }
}
