//
//  RecentPopUpVC.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/27/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RecentPopUpVC: BaseViewController {
    // MARK: - Components

    private let headerView: HeaderViewCPNT = {
        let view = HeaderViewCPNT(title: "최근 본 팝업", style: .icon(nil))
        return view
    }()
    
    private let countView: ListMenuViewCPNT = {
        let view = ListMenuViewCPNT(title: "총 5건", style: .filter(nil))
        view.iconImageView.removeFromSuperview()
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: GridLayout(height: 255))
        return view
    }()
    
    // MARK: - Properties
    
    private let viewModel: RecentPopUpVM

    private let disposeBag = DisposeBag()
    
    init(viewModel: RecentPopUpVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCycle
extension RecentPopUpVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
        bind()
    }
}

// MARK: - SetUp
private extension RecentPopUpVC {
    
    func setUp() {
        self.navigationController?.navigationBar.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ViewedPopUpCell.self, forCellWithReuseIdentifier: ViewedPopUpCell.identifier)
    }
    
    func setUpConstraints() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        view.addSubview(countView)
        countView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(countView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    func bind() {
        let input = RecentPopUpVM.Input(
            backButtonTapped: headerView.leftBarButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.popUpList
            .withUnretained(self)
            .subscribe { (owner, response) in
                owner.collectionView.reloadData()
                owner.countView.titleLabel.text = "총 \(response.totalElements)건"
            }
            .disposed(by: disposeBag)
        
        output.moveToRecentVC
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension RecentPopUpVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.popUpList.value.popUpInfoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewedPopUpCell.identifier, for: indexPath) as? ViewedPopUpCell else {
            return UICollectionViewCell()
        }
        let data = viewModel.popUpList.value.popUpInfoList[indexPath.row]
        cell.injectionWith(
            input: .init(
                date: "~\(data.endDate.asString())",
                title: data.popUpStoreName,
                imageURL: data.mainImageUrl
            )
        )
        cell.bookmarkButton.isHidden = true
        return cell
    }
}
