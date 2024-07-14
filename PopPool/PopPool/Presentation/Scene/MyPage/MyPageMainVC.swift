//
//  MyPageMainVC.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/4/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class MyPageMainVC : BaseViewController {
    // MARK: - Components
    private let headerBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    private let headerView: HeaderViewCPNT = HeaderViewCPNT(style: .icon(UIImage(named: "icosolid")))
    private lazy var profileView = MyPageMainProfileView(
        frame: .init(x: 0, y: 0, width: self.view.bounds.width, height: self.profileViewHeight),
        profileImage: UIImage(systemName: "folder")
    )
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.tableFooterView = UIView(frame: .zero)
        view.sectionFooterHeight = 0
        return view
    }()
    
    // MARK: - Properties
    private let viewModel = MyPageMainVM()
    private let profileViewHeight: CGFloat = 256
    private let disposeBag = DisposeBag()
}

// MARK: - LifeCycle
extension MyPageMainVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
        bind()
    }
}

// MARK: - SetUp
private extension MyPageMainVC {
    
    func setUp() {
        self.navigationController?.navigationBar.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableHeaderView = profileView

    }
    
    func setUpConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        view.addSubview(headerBackGroundView)
        headerBackGroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view)
            make.bottom.equalTo(headerView.snp.bottom)
        }
        view.bringSubviewToFront(headerView)
    }
    
    func bind() {
        let input = MyPageMainVM.Input()
        let output = viewModel.transform(input: input)
    }
}

private extension MyPageMainVC {
    

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MyPageMainVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.menuList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.menuList[section].sectionCellInputList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewModel.menuList[indexPath.section].getCell(tableView: tableView, indexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewModel.menuList[section].makeHeaderView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // scroll시 header alpha값 변경
        // 총 스크롤 값 프로필 뷰 높이 - headerBackGroundView의 높이
        let limitScroll = profileViewHeight - headerBackGroundView.bounds.maxY
        let scrollValue = scrollView.contentOffset.y + view.safeAreaLayoutGuide.layoutFrame.minY
        let alpha: Double = scrollValue / limitScroll
        
        // alpha값 변경
        if alpha <= 0.05 {
            headerBackGroundView.alpha = 0
        } else if (0.05...0.95).contains(alpha) {
            headerBackGroundView.alpha = alpha
        } else {
            headerBackGroundView.alpha = 1
        }
        profileView.scrollViewDidScroll(scrollView: scrollView, alpha: alpha)
    }
}
