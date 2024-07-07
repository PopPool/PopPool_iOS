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
    private let headerView = HeaderViewCPNT(style: .icon(UIImage(named: "icosolid")))
    lazy var profileView = MyPageMainProfileView(frame: .init(x: 0, y: 0, width: self.view.bounds.width, height: 256))
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        return view
    }()
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
}

// MARK: - LifeCycle
extension MyPageMainVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
    }
}

// MARK: - SetUp
private extension MyPageMainVC {
    
    func setUp() {
        self.navigationController?.navigationBar.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuListCell.self, forCellReuseIdentifier: MenuListCell.identifier)
        tableView.separatorStyle = .none

        tableView.tableHeaderView = profileView
    }
    
    func setUpConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

private extension MyPageMainVC {
    

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MyPageMainVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuListCell.identifier) as? MenuListCell else {
            return UITableViewCell()
        }
        cell.configure(title: "TEST\(indexPath.row)", subTitle: "test", subTitleColor: .red)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        profileView.scrollViewDidScroll(scrollView: scrollView)
    }
}
