import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {
    private let viewModel: MapVM
    private let disposeBag = DisposeBag()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 16
//        layout.minimumInteritemSpacing = 16
//        let width = (UIScreen.main.bounds.width - 48) / 2 // 2열로 설정, 좌우 여백 16씩, 중간 여백 16
//        layout.itemSize = CGSize(width: width, height: 300)
//
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PopupListCell.self, forCellWithReuseIdentifier: PopupListCell.reuseIdentifier)
//        collectionView.backgroundColor = .white
//        collectionView.contentInset = UIEdgeInsets(top: 16, left: 10, bottom: 16, right: 10)
        return collectionView
    }()



    init(viewModel: MapVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
//        view.addSubview(emptyStateView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

//        emptyStateView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
    }

    private func bindViewModel() {
        viewModel.output.filteredStores
            .do(onNext: { stores in
                print("받아온 데이터 수: \(stores.count)")
            })
            .bind(to: collectionView.rx.items(cellIdentifier: PopupListCell.reuseIdentifier, cellType: PopupListCell.self)) { [weak self] (_, store, cell) in
                guard let self = self else { return }

                cell.configure(with: store)
                cell.configureImage(with: nil)  // 기본적으로 nil을 전달하여 기본 이미지 표시

                // 이미지가 있다면 나중에 설정
                self.viewModel.getCustomPopUpStoreImages(for: [store])
                    .subscribe(onNext: { images in
                        if let image = images.first {
                            cell.configureImage(with: image)
                        }
                    })
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)

        collectionView.rx.modelSelected(PopUpStore.self)
            .subscribe(onNext: { [weak self] store in
                self?.showStoreDetail(store)
            })
            .disposed(by: disposeBag)
    }


    private func showStoreDetail(_ store: PopUpStore) {
        // 상세 페이지로 이동하는 로직 구현
        print("Selected store: \(store.name)")
    }
}
