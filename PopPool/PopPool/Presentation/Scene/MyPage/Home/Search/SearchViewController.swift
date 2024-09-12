import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchViewController: UIViewController {
    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()

    // MARK: - UI Components
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "팝업스토어명을 입력해보세요"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private lazy var recentSearchesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(RecentSearchChipView.self, forCellWithReuseIdentifier: "RecentSearchChip")
        return cv
    }()

    private let searchResultsTableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
        return tv
    }()

    private let emptyResultLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과가 없습니다."
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    // MARK: - Initialization
    init(viewModel: SearchViewModel = SearchViewModel()) {
        self.viewModel = viewModel
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
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(searchBar)
        view.addSubview(cancelButton)
        view.addSubview(recentSearchesCollectionView)
        view.addSubview(searchResultsTableView)
        view.addSubview(emptyResultLabel)

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(cancelButton.snp.left).offset(-8)
        }

        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar)
            make.right.equalToSuperview().offset(-16)
        }

        recentSearchesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }

        searchResultsTableView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchesCollectionView.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }

        emptyResultLabel.snp.makeConstraints { make in
            make.center.equalTo(searchResultsTableView)
        }
    }

    // MARK: - Binding
    private func bindViewModel() {
        // Bind search bar text to view model
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.input.searchQuery)
            .disposed(by: disposeBag)

        // Bind cancel button
        cancelButton.rx.tap
            .bind(to: viewModel.input.cancelSearch)
            .disposed(by: disposeBag)

        // Bind recent searches
        viewModel.output.recentSearches
            .bind(to: recentSearchesCollectionView.rx.items(cellIdentifier: "RecentSearchChip", cellType: RecentSearchChipView.self)) { _, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)

        // Bind search results
        viewModel.output.searchResults
            .bind(to: searchResultsTableView.rx.items(cellIdentifier: "SearchResultCell", cellType: UITableViewCell.self)) { _, item, cell in
                cell.textLabel?.text = "\(item.name) - \(item.address)"
            }
            .disposed(by: disposeBag)

        // Bind empty state
        viewModel.output.isEmptyResult
            .bind(to: emptyResultLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

class RecentSearchChipView: UICollectionViewCell {
    func configure(with text: String) {
        // 실제 구현은 여기에
    }
}
