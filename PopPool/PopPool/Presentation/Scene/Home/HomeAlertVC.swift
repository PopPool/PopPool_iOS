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
    
    // MARK: - Properties
    
    private let viewModel: HomeAlertVM
    
    // MARK: - Initalizer
    
    init(viewModel: HomeAlertVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
    
    // MARK: - Methods
    
    private func setUp() {
        headerView.titleLabel.text = "알림"
        view.backgroundColor = .g50
        contentHeader.isHidden = true
        emptyStateStack.isHidden = true
        headerView.rightBarButton.isHidden = false
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .g50
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.register(HomeAlertCell.self,
                           forCellReuseIdentifier: HomeAlertCell.reuseIdentifier)
    }
    
    private func bind() {
        let input = HomeAlertVM.Input()
        let output = viewModel.transform(input: input)
        
        headerView.leftBarButton.rx.tap
            .subscribe { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        headerView.rightBarButton.rx.tap
            .subscribe(onNext: {
                let viewModel = AlarmSettingVM()
                let vc = AlarmSettingVC(viewModel: viewModel)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Tableview Datasource

extension HomeAlertVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Section.allCases[section]
        switch section {
        case .all: return viewModel.allData.count
        case .today: return viewModel.todayData.count
        }
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
        
        headerView.rightButton.isHidden = true
        headerView.backgroundColor = .g50
        headerView.titleLabel.textColor = .blu500
        headerView.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 16, right: 20)
        headerView.isLayoutMarginsRelativeArrangement = true
        
        switch section {
        case .today:
            headerView.subTitleLabel.removeFromSuperview()
            headerView.titleLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
            }
        case .all:
            headerView.subTitleLabel.text = section.descriptionTitle
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeAlertCell.reuseIdentifier, for: indexPath) as? HomeAlertCell else { return UITableViewCell() }
        let section = Section.allCases[indexPath.section]
        var item = viewModel.mockData[indexPath.row]
        
        switch section {
        case .all:
            item = viewModel.allData[indexPath.row]
        case .today:
            item = viewModel.todayData[indexPath.row]
        }
        
        cell.content.setUp(title: item.title, subTitle: item.description, info: item.dateString)
        cell.content.titleActionButton.isHidden = true
        cell.content.actionButton.isHidden = true
        return cell
    }
}
