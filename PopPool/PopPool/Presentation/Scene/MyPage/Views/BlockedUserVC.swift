//
//  BlockedUserVC.swift
//  PopPool
//
//  Created by Porori on 7/23/24.
//

import UIKit
import SnapKit
import RxSwift

final class BlockedUserVC: UIViewController {

    let headerView: HeaderViewCPNT
    var contentHeader: ListMenuCPNT
    let profileList: ListInfoButton
    let topSpaceView = UIView()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(headerView)
        stack.addArrangedSubview(topSpaceView)
        stack.addArrangedSubview(contentHeader)
        stack.addArrangedSubview(profileList)
        return stack
    }()
    
    var blockedCount: Int = 0
    
    init(blockCount: Int) {
        self.blockedCount = blockCount
        self.headerView = HeaderViewCPNT(title: "차단한 사용자 관리", style: .icon(UIImage(systemName: "lasso")))
        self.contentHeader = ListMenuCPNT(menuTitle: "총 \(blockedCount)건", style: .none)
        self.profileList = ListInfoButton(infoTitle: "분노하는 너구리", subTitle: "@instagram_id", style: .button("차단완료"))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
    }
    
    private func setUp() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        headerView.rightBarButton.isHidden = true
    }
    
    private func setUpConstraints() {
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        topSpaceView.snp.makeConstraints { make in
            make.height.equalTo(12)
        }
    }
}
