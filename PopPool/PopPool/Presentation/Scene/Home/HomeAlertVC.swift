//
//  HomeAlertVC.swift
//  PopPool
//
//  Created by Porori on 8/7/24.
//

import UIKit
import SnapKit
import RxSwift

class HomeAlertVC: BaseTableViewVC {
    
    enum Section: CaseIterable {
        case today
        case all
        
        var sectionTitle: String {
            switch self {
            case .today: return "오늘"
            case .all: return "전체"
            }
        }
        
        var descriptionTitle: String? {
            switch self {
            case .today: return nil
            case .all: return "최근 30일 동안 수신한 알림을 보여드릴께요"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        headerView.titleLabel.text = "알림"
        contentHeader.isHidden = true
        emptyStateStack.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderTopPadding = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
}

extension HomeAlertVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .gray
        return footer
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = Section.allCases[section]
        let headerView = ListTitleViewCPNT(title: section.sectionTitle,
                                           size: .large(subtitle: "", image: nil))
        
        headerView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        headerView.isLayoutMarginsRelativeArrangement = true
        headerView.rightButton.isHidden = true
        headerView.titleLabel.textColor = .blu500
        
        switch section {
        case .today:
            headerView.subTitleLabel.removeFromSuperview()
            headerView.titleLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
            }
            
            headerView.bottomSpace.snp.makeConstraints { make in
                make.top.equalTo(headerView.titleLabel.snp.bottom)
            }
        case .all:
            headerView.subTitleLabel.text = section.descriptionTitle
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "namename"
        return cell
    }
}
