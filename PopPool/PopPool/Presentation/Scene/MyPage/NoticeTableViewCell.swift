//
//  NoticeTableViewCell.swift
//  PopPool
//
//  Created by Porori on 7/29/24.
//

import UIKit
import SnapKit
import RxSwift

class NoticeTableViewCell: UITableViewCell {

    static let reuseIdentifier = "NoticeTableViewCell"
    
    private let component = ListInfoButtonCPNT(infoTitle: "테스트 라벨", subTitle: "작성자", style: .icon)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setUp() {
        component.profileImageView.isHidden = true
    }
    
    private func setUpConstraint() {
        contentView.addSubview(component)
        component.snp.makeConstraints { make in
            make.height.equalTo(82)
            make.edges.equalToSuperview()
        }
    }
}
