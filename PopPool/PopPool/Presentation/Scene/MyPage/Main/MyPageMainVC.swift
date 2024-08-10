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
        frame: .init(x: 0, y: 0, width: self.view.bounds.width, height: self.profileViewHeight)
    )
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.tableFooterView = UIView(frame: .zero)
        view.sectionFooterHeight = 0
        return view
    }()
    private let logoutButton: ButtonCPNT = ButtonCPNT(type: .secondary, title: "로그아웃")
    // MARK: - Properties
    private let viewModel: MyPageMainVM
    private let profileViewHeight: CGFloat = 256
    private let disposeBag = DisposeBag()
    
    init(viewModel: MyPageMainVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
        let input = MyPageMainVM.Input(
            cellTapped: tableView.rx.itemSelected,
            profileLoginButtonTapped: profileView.loginButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.myPageAPIResponse
            .withUnretained(self)
            .subscribe(onNext: { (owner, myPageResponse) in
                print(myPageResponse)
                owner.profileView.injectionWith(
                    input: .init(
                        // TODO: - 더미 데이터 제거 후 연결 필요
                        isLogin: myPageResponse.login,
                        nickName: myPageResponse.nickname,
                        instagramId: myPageResponse.instagramId,
                        intro: myPageResponse.intro
                    )
                )
                if myPageResponse.login {
                    let bottomView = UIView(frame: .init(origin: .zero, size: .init(width: owner.view.frame.width, height: 100)))
                    bottomView.backgroundColor = .systemBackground
                    bottomView.addSubview(owner.logoutButton)
                    owner.logoutButton.snp.makeConstraints { make in
                        make.top.leading.trailing.equalToSuperview().inset(20)
                        make.height.equalTo(50)
                    }
                    owner.tableView.tableFooterView = bottomView
                } else {
                    owner.tableView.tableFooterView = nil
                }
                owner.headerView.rightBarButton.isHidden = !myPageResponse.login
                owner.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.moveToVC
            .withUnretained(self)
            .subscribe { (owner, vc) in
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
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
