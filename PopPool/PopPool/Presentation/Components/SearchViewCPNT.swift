import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewCPNT: UIView {
    // MARK: - UI 컴포넌트
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "팝업스토어명을 입력해보세요"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()

    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()


    private let recentSearchesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()


    private let popularPopupsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()

    let searchResultsTableView: UITableView = {
        let tv = UITableView()
        tv.isHidden = true
        return tv
    }()

    // MARK: - 속성
    private let disposeBag = DisposeBag()
    private let viewModel: SearchViewModel

    // MARK: - 초기화
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:)가 구현되지 않았습니다")
    }

    // MARK: - 설정
    private func setupViews() {
        addSubview(searchBar)
        addSubview(cancelButton)
        addSubview(recentSearchesCollectionView)
        addSubview(popularPopupsCollectionView)
        addSubview(searchResultsTableView)
        recentSearchesCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "RecentSearchCell")
           popularPopupsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PopularPopupCell")

    }

    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.right.equalTo(cancelButton.snp.left).offset(-8)
        }

        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar)
            make.right.equalToSuperview().offset(-16)
        }


        searchResultsTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func setupBindings() {
        // 검색어 입력 바인딩
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.input.searchQuery)
            .disposed(by: disposeBag)

        // 최근 검색어 바인딩
        viewModel.output.recentSearches
                  .bind(to: recentSearchesCollectionView.rx.items(cellIdentifier: "RecentSearchCell", cellType: UICollectionViewCell.self)) { (index, item, cell) in
                      // UICollectionViewCell에 대한 커스텀 구성
                      if let label = cell.contentView.subviews.first as? UILabel {
                          label.text = item
                      } else {
                          let label = UILabel()
                          label.text = item
                          cell.contentView.addSubview(label)
                          label.snp.makeConstraints { make in
                              make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
                          }
                      }
                  }
                  .disposed(by: disposeBag)

        // 검색 결과 바인딩
        viewModel.output.searchResults
            .bind(to: searchResultsTableView.rx.items(cellIdentifier: "SearchResultCell", cellType: UITableViewCell.self)) { (index, item, cell) in
                var content = cell.defaultContentConfiguration()
                content.text = item.name
                cell.contentConfiguration = content
            }
            .disposed(by: disposeBag)

        // 검색 결과 표시 여부 바인딩
        viewModel.output.isSearching
            .bind(to: searchResultsTableView.rx.isHidden)
            .disposed(by: disposeBag)

        // 취소 버튼 탭 바인딩
        cancelButton.rx.tap
            .bind(to: viewModel.input.cancelSearch)
            .disposed(by: disposeBag)
    }
}


