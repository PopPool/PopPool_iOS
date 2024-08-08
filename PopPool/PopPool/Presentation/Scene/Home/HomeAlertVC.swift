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

    let viewModel = HomeAlertVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
    
    private func setUp() {
        view.backgroundColor = .g50
        tableView.backgroundColor = .g50
        headerView.titleLabel.text = "알림"
        contentHeader.isHidden = true
        emptyStateStack.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderTopPadding = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    private func bind() {
        headerView.leftBarButton.rx.tap
            .subscribe { [weak self] _ in
                print("탭탭")
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
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
        footer.backgroundColor = .g100
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = Section.allCases[section]
        switch section {
        case .today: return CGFloat(Constants.spaceGuide.small100)
        case .all: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = Section.allCases[section]
        let headerView = ListTitleViewCPNT(title: section.sectionTitle,
                                           size: .large(subtitle: "", image: nil))
        
        headerView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        headerView.isLayoutMarginsRelativeArrangement = true
        headerView.rightButton.isHidden = true
        headerView.backgroundColor = .g50
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
        cell.backgroundColor = .g50
        return cell
    }
}
