import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class UserCommentsViewController: UIViewController {
    private let viewModel: UserCommentsViewModel
     private let disposeBag = DisposeBag()
     private let userId: String
    private let progressIndicator = ProgressIndicatorCPNT(totalStep: 1, startPoint: 1)


    // MARK: - UI Components
    private let navigationBar = UIView()
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "코멘트 작성 팝업"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let totalCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(UserCommentCell.self, forCellWithReuseIdentifier: "UserCommentCell")
        return cv
    }()

    // MARK: - Initialization
    init(viewModel: UserCommentsViewModel, userId: String) {
        self.viewModel = viewModel
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchComments(for: userId)
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(navigationBar)
        navigationBar.addSubview(backButton)
        navigationBar.addSubview(titleLabel)
        view.addSubview(totalCountLabel)
        view.addSubview(collectionView)

        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }

        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 24, height: 24))
        }

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        totalCountLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(totalCountLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    // MARK: - Binding
    private func bindViewModel() {
        viewModel.comments
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] comments in
                self?.totalCountLabel.text = "총 \(comments.count)건"
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension UserCommentsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.comments.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCommentCell", for: indexPath) as! UserCommentCell
        let comment = viewModel.comments.value[indexPath.item]
        cell.configure(with: comment)
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 16) / 2
        return CGSize(width: width, height: width * 1.3)
    }
}
