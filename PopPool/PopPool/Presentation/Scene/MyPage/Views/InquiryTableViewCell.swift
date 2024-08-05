//
//  InquiryTableViewCell.swift
//  PopPool
//
//  Created by Porori on 8/5/24.
//

import UIKit
import SnapKit
import RxSwift

class InquiryTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "InquiryTableViewCell"
    
    let dropDownList = ListDropDownCPNT()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let disposeBag = DisposeBag()
    
    private func bind() {
        dropDownList.actionButton.rx.tap
            .subscribe(onNext: {
                print("did press within cell")
            })
            .disposed(by: disposeBag)
    }
    
    private func setUpConstraint() {
        addSubview(dropDownList)
        dropDownList.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
