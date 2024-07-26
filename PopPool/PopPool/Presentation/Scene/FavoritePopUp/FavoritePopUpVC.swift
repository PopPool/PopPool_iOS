//
//  FavoritePopUpVC.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FavoritePopUpVC: BaseViewController {
    // MARK: - Components
    private let headerView: HeaderViewCPNT = {
        let view = HeaderViewCPNT(title: "찜한 팝업", style: .text(""))
        return view
    }()
    private let filterView: FilterMenuListViewCPNT = {
        let view = FilterMenuListViewCPNT(.init(title: "총 5건", filterTitle: "크게보기"))
        return view
    }()
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
}

// MARK: - LifeCycle
extension FavoritePopUpVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
    }
}

// MARK: - SetUp
private extension FavoritePopUpVC {
    
    func setUp() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setUpConstraints() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        view.addSubview(filterView)
        filterView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        }
    }
}
