//
//  HomeAlertVC.swift
//  PopPool
//
//  Created by Porori on 8/7/24.
//

import UIKit
import SnapKit
import RxSwift

final class HomeAlertVC: BaseTableViewVC {
    
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
        super.init()
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
        
        // 테이블 연결
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.register(HomeAlertCell.self,
                           forCellReuseIdentifier: HomeAlertCell.reuseIdentifier)
    }
    
    private func bind() {
        let input = HomeAlertVM.Input(
            returnToRoot: headerView.leftBarButton.rx.tap,
            moveToNextPage: headerView.rightBarButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        // 되돌아가기 버튼
        input.returnToRoot
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        // 설정 버튼
        input.moveToNextPage
            .subscribe(onNext: { [weak self] _ in
                let viewModel = AlarmSettingVM()
                let vc = AlarmSettingVC(viewModel: viewModel)
                self?.navigationController?.pushViewController(vc, animated: true)
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
    
    /// 테이블뷰의 헤더 뷰를 설정합니다
    /// - Parameters:
    ///   - tableView: 알림 테이블 뷰
    ///   - section: 오늘, 전체로 구분하는 Section enum을 활용
    /// - Returns: 커스텀 UIView인 ListTitleViewCPNT을 반환
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
    
    /// 테이블 뷰의 푸터 뷰를 설정합니다
    /// - Parameters:
    ///   - tableView: 알림 테이블 뷰
    /// - Returns: 별도의 값이 없기에 UIView를 반환합니다
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .g100
        return footer
    }
    
    /// 테이블 뷰에서 '오늘 Section'의 푸터 뷰 높이를 설정합니다
    /// - Parameters:
    ///   - tableView: 알림 테이블 뷰
    ///   - section: 오늘, 전체로 구분하는 Section enum을 활용
    /// - Returns: Section별로 높이를 반환
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = Section.allCases[section]
        switch section {
        case .today: return CGFloat(Constants.spaceGuide.small100)
        case .all: return 0
        }
    }
    
    /// viewModel에 담긴 데이터를 cell에 채워줍니다
    /// - Parameters:
    ///   - tableView: 알림 테이블 뷰
    /// - Returns: 커스텀 셀인 HomeAlertCell를 반환
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
        
        cell.content.titleActionButton.isHidden = true
        cell.content.actionButton.isHidden = true
        cell.content.setUp(title: item.title, subTitle: item.description, info: item.dateString)
        return cell
    }
}
