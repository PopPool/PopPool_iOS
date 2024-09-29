//
//  EntirePopupVC.swift
//  PopPool
//
//  Created by Porori on 8/11/24.
//

import UIKit
import RxSwift
import SnapKit

final class EntirePopupVC: BaseViewController {
    
    var header: HeaderViewCPNT = HeaderViewCPNT(title: "큐레이션 팝업 전체보기",
                                                        style: .icon(nil))
    
    private let entirePopUpCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 56) / 2
        let height: CGFloat = 251
        layout.itemSize = .init(width: width, height: height)
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentInset = .init(top: 24, left: 20, bottom: 0, right: 20)
        view.backgroundColor = .g50
        view.isUserInteractionEnabled = true
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private var allPopUpStores: [HomePopUp] = []
    
    private let viewModel: EntirePopupVM
    let disposeBag = DisposeBag()
    
    init(viewModel: EntirePopupVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraint()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func bind() {
        let input = EntirePopupVM.Input()
        let output = viewModel.transform(input: input)
        
        header.leftBarButton.rx.tap
            .subscribe(onNext: {
                print("버튼이 눌렸습니다.")
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.allPopUps
            .withUnretained(self)
            .subscribe(onNext: { (owner, data) in
                print("DEBUG: 받아온 데이터 수:", data.count)
                print("DEBUG: 첫 번째 항목:", data.first ?? "데이터 없음")
                owner.allPopUpStores.append(contentsOf: data)
                owner.entirePopUpCollectionView.reloadData()
                print("DEBUG: 컬렉션 뷰 리로드 완료")
            })
            .disposed(by: disposeBag)
    }

    
    private func setUp() {
        header.rightBarButton.isHidden = true
        entirePopUpCollectionView.backgroundColor = .systemBackground
        entirePopUpCollectionView.delegate = self
        entirePopUpCollectionView.dataSource = self
        entirePopUpCollectionView.register(HomeDetailPopUpCell.self,
                                           forCellWithReuseIdentifier: HomeDetailPopUpCell.identifier)
    }
    
    private func setUpConstraint() {
        view.addSubview(header)
        view.addSubview(entirePopUpCollectionView)
        
        header.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        entirePopUpCollectionView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension EntirePopupVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("DEBUG: 전체 데이터 수:", allPopUpStores.count)
        return allPopUpStores.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailPopUpCell.identifier, for: indexPath) as? HomeDetailPopUpCell else {
            print("DEBUG: 셀 생성 실패")
            return UICollectionViewCell()
        }

        let popUpStore = allPopUpStores[indexPath.item]
        print("DEBUG: 셀 구성 - 인덱스:", indexPath.item, "이름:", popUpStore.name)

        cell.injectionWith(input: HomeDetailPopUpCell.Input(
            image: popUpStore.mainImageUrl,
            category: popUpStore.category,
            title: popUpStore.name,
            location: popUpStore.address,
            date: popUpStore.startDate
        ))
        return cell
    }
}
