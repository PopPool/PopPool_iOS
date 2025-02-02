//
//  HomeAlertCell.swift
//  PopPool
//
//  Created by Porori on 8/8/24.
//

import UIKit
import SnapKit
import RxSwift

final class HomeAlertCell: UITableViewCell {
    
    static let reuseIdentifier: String = "HomeAlertCell"
    
    let content = ListContentCPNT(title: "제목제목", subTitle: "부제부제", info: "2024/03/02")

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        self.backgroundColor = .g50
    }
    
    private func setUpConstraint() {
        addSubview(content)
        
        content.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
