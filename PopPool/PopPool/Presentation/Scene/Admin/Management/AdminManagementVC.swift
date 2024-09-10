//
//  AdminManagementVC.swift
//  PopPool
//
//  Created by SeoJunYoung on 9/7/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class AdminManagementVC: BaseViewController {
    
    private let topStackView: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "팝업스토어 관리"
        label.font = .KorFont(style: .bold, size: 20)
        return label
    }()
    
    private let postAddButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록", for: .normal)
        button.setTitleColor(.blu500, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 19
        button.layer.borderColor = UIColor.blu500.cgColor
        button.titleLabel?.font = .KorFont(style: .bold, size: 13)
        return button
    }()
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        return view
    }()
    
    private let disposeBag = DisposeBag()
    
    private let adminRepository = AdminRepositoryImpl()
    
    private let popUpList: BehaviorRelay<[AdminManagementListTableViewCell.Input]> = .init(value: [])
    
    private var originData: [AdminPopUpStoreDTO] = []
    
    private let imageService = PreSignedService()
}

// MARK: - LifeCycle
extension AdminManagementVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adminRepository.getPopUpList(request: .init(page: 0, size: 1))
            .withUnretained(self)
            .subscribe(onNext: { (owner, response) in
                owner.originData = response.popUpStoreList
                let pathList = response.popUpStoreList.compactMap { $0.mainImageUrl }
                owner.imageService.tryDownload(filePaths: pathList)
                    .subscribe { imageList in
                        if response.popUpStoreList.count == imageList.count {
                            let popUpList = zip(response.popUpStoreList, imageList).map {
                                AdminManagementListTableViewCell.Input(image: $0.1, title: $0.0.name, category: $0.0.category)
                            }
                            owner.popUpList.accept(popUpList)
                        } else {
                            let popUpList = response.popUpStoreList.map {
                                AdminManagementListTableViewCell.Input(image: nil, title: $0.name, category: $0.category)
                            }
                            owner.popUpList.accept(popUpList)
                        }
                    } onFailure: { error in
                        ToastMSGManager.createToast(message: "Presigned URL Error")
                    }
                    .disposed(by: owner.disposeBag)
            }, onError: { error in
                ToastMSGManager.createToast(message: "Network Error")
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - SetUp
private extension AdminManagementVC {
    
    func setUp() {
        tableView.dataSource = self
        tableView.register(AdminManagementListTableViewCell.self, forCellReuseIdentifier: AdminManagementListTableViewCell.identifier)
    }
    
    func setUpConstraints() {
        view.addSubview(topStackView)
        topStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        postAddButton.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(38)
        }
        topStackView.addArrangedSubview(titleLabel)
        topStackView.addArrangedSubview(postAddButton)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func bind() {
        popUpList
            .withUnretained(self)
            .subscribe { (owner, inputList) in
                owner.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        postAddButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.navigationController?.pushViewController(AdminPostVC(), animated: true)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe { (owner, indexPath) in
                let popUpId = owner.originData[indexPath.row].id
                let editVC = AdminEditVC()
                editVC.popUpStoreId.accept(popUpId)
                owner.navigationController?.pushViewController(editVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}


extension AdminManagementVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popUpList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AdminManagementListTableViewCell.identifier) as? AdminManagementListTableViewCell else {
            return UITableViewCell()
        }
        let input = popUpList.value[indexPath.row]
        cell.injectionWith(input: input)
        return cell
    }
}
