import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchViewController: UIViewController {
    private let searchViewModel: SearchViewModel
    private let recentSearchesViewModel = RecentSearchesViewModel()
    private let entirePopupViewModel: EntirePopupVM
    private let homeViewModel: HomeVM

    private var allPopUpStores: [HomePopUp] = []
       private var filteredPopUpStores: [HomePopUp] = []


    let homeResponse = GetHomeInfoResponse()

    private let disposeBag = DisposeBag()

    private var isSearching: Bool = false {
        didSet {
            updateUIForSearchState(isSearching ? .searching : .initial)
        }
    }

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

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    private let findPopupLabel: UILabel = {
        let label = UILabel()
        label.text = "팝업스토어 찾기"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()

    private let recentSearchScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private let recentSearchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private let clearAllButton: UIButton = {
        let button = UIButton(type: .system)
        let title = "모두삭제"

        let attributedString = NSAttributedString(string: title, attributes: [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 14),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ])

        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()

    // 카테고리 필터 버튼
    private let categoryFilterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("카테고리", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return button
    }()


    // 정렬 필터 버튼
    private let sortFilterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("오픈 · 인기순", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        button.tintColor = .black
        button.semanticContentAttribute = .forceRightToLeft
        return button

    }()
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과가 없어요 :(\n다른 키워드로 검색해주세요"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        label.isHidden = true
        return label
    }()

    private let totalCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let searchResultsTableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
        return tv
    }()
    private lazy var curationPopupCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        let width = (UIScreen.main.bounds.width - 48) / 2
        layout.itemSize = CGSize(width: width, height: width * 1.5)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        cv.backgroundColor = .white
        return cv
    }()


    private let suggestionTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchSuggestionCell.self, forCellReuseIdentifier: "SearchSuggestionCell")
        return tableView
    }()

    private let categoryFilterBottomSheet = CategoryFilterBottomSheetViewController()
    private let sortFilterBottomSheet = SortOrderBottomSheetViewController()


    // MARK: - Initialization
    init(viewModel: SearchViewModel, entirePopupViewModel: EntirePopupVM, homeViewModel: HomeVM) {
        self.searchViewModel = viewModel
        self.entirePopupViewModel = entirePopupViewModel
        self.homeViewModel = homeViewModel

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
        bindActions()
//        loadCurationPopupData()


        print("버튼 크기: \(categoryFilterButton.frame.size)")

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(suggestionTableView)
        view.addSubview(searchBar)
        view.addSubview(cancelButton)
        curationPopupCollectionView.register(HomeDetailPopUpCell.self, forCellWithReuseIdentifier: HomeDetailPopUpCell.identifier)
        view.addSubview(totalCountLabel)
//        view.addSubview(curationPopupCollectionView)
        view.addSubview(noResultsLabel)

        view.addSubview(curationPopupCollectionView)
        view.addSubview(titleLabel)
        view.addSubview(recentSearchScrollView)
        recentSearchScrollView.addSubview(recentSearchStackView)

        view.addSubview(clearAllButton)
        view.addSubview(findPopupLabel)
        view.addSubview(categoryFilterButton)
        view.addSubview(sortFilterButton)



        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(cancelButton.snp.leading).offset(-10)

        }

        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar)
            make.trailing.equalToSuperview().offset(-20)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        clearAllButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-20)
        }

        recentSearchScrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        recentSearchStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }

        findPopupLabel.snp.makeConstraints { make in
            make.top.equalTo(recentSearchScrollView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        categoryFilterButton.snp.makeConstraints { make in
            make.top.equalTo(findPopupLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(40)
        }

        sortFilterButton.snp.makeConstraints { make in
            make.centerY.equalTo(categoryFilterButton).offset(60)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)

        }
        curationPopupCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sortFilterButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        totalCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sortFilterButton) 
            make.leading.equalToSuperview().offset(20)
        }



        suggestionTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        noResultsLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }




    }


    // MARK: - Binding
    private func bindViewModel() {
        recentSearchesViewModel.output.recentSearches
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] searches in
                print("업데이트된 최근 검색어: \(searches)")
                self?.updateRecentSearches(with: searches)
            })
            .disposed(by: disposeBag)


        clearAllButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.recentSearchesViewModel.input.removeAllSearches.onNext(())
            })
            .disposed(by: disposeBag)

        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.isSearching = false
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)


        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] query in
                if query.isEmpty {
                    self?.isSearching = false
                    self?.suggestionTableView.isHidden = true
                } else {
                    self?.isSearching = true
                    self?.searchViewModel.input.searchQuery.onNext(query) // 추천 검색어 업데이트
                }
            })
            .disposed(by: disposeBag)


        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                guard let query = self?.searchBar.text, !query.isEmpty else {
                    print("검색어가 비어있음")
                    return
                }
                print("검색 실행: \(query)")
                self?.recentSearchesViewModel.input.addSearchQuery.onNext(query) // 최근 검색어 추가
                self?.filterPopUpStores(with: query) // 검색 결과 필터링
            })
            .disposed(by: disposeBag)


        searchViewModel.output.realTimeSuggestions
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] suggestions in
                let hasResults = !suggestions.isEmpty
                self?.suggestionTableView.isHidden = !hasResults
                self?.noResultsLabel.isHidden = hasResults
            })
            .bind(to: suggestionTableView.rx.items(cellIdentifier: "SearchSuggestionCell", cellType: SearchSuggestionCell.self)) { [weak self] index, suggestion, cell in
                guard let query = self?.searchBar.text else { return }
                cell.configure(with: suggestion, query: query)
            }
            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                guard let query = self?.searchBar.text, !query.isEmpty else {
                    print("검색어가 비어있음")
                    return
                }
                print("검색 실행: \(query)")
                self?.recentSearchesViewModel.input.addSearchQuery.onNext(query)
                self?.searchViewModel.input.searchQuery.onNext(query)
            })
            .disposed(by: disposeBag)
        


        suggestionTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.searchViewModel.output.realTimeSuggestions
                    .observe(on: MainScheduler.instance)
                    .take(1)
                    .subscribe(onNext: { suggestions in
                        let suggestion = suggestions[indexPath.row]
                        //                        self?.performSearch(with: suggestion)  // 상세 페이지 이동 로직
                    })
                    .disposed(by: self!.disposeBag)
            })
            .disposed(by: disposeBag)
        let output = entirePopupViewModel.transform(input: EntirePopupVM.Input())
        output.fetchedDataResponse
            .map { response in

                return response.popularPopUpStoreList ?? [] // 인기있는 팝업으로 변경
            }
            .observe(on: MainScheduler.instance)
            .do(onNext: { newPopUps in
                print("DEBUG: 받은 New PopUp 데이터 수: \(newPopUps.count)")
                self.updateTotalCountLabel(count: newPopUps.count) // 셀 개수 업데이트

            })
            .bind(to: curationPopupCollectionView.rx.items(cellIdentifier: HomeDetailPopUpCell.identifier, cellType: HomeDetailPopUpCell.self)) { (index, popUp, cell) in
                cell.injectionWith(input: HomeDetailPopUpCell.Input(
                    image: popUp.mainImageUrl,
                    category: popUp.category,
                    title: popUp.name,
                    location: popUp.address,
                    date: popUp.startDate
                ))
            }
            .disposed(by: disposeBag)

    }
    private func bindHomePopUpData() {
        homeViewModel.newPopUpStore
            .observe(on: MainScheduler.instance)
            .bind(to: curationPopupCollectionView.rx.items(cellIdentifier: HomeDetailPopUpCell.identifier, cellType: HomeDetailPopUpCell.self)) { index, popUpStore, cell in
                cell.injectionWith(input: HomeDetailPopUpCell.Input(
                    image: popUpStore.mainImageUrl,
                    category: popUpStore.category,
                    title: popUpStore.name,
                    location: popUpStore.address,
                    date: popUpStore.startDate
                ))
            }
            .disposed(by: disposeBag)
    }


    private func loadCurationPopupData() {
        let input = EntirePopupVM.Input()
        let output = entirePopupViewModel.transform(input: input)

    }

    private func updateCollectionView(with popUpStores: [HomePopUp]) {
        Observable.just(popUpStores)
            .bind(to: curationPopupCollectionView.rx.items(cellIdentifier: HomeDetailPopUpCell.identifier, cellType: HomeDetailPopUpCell.self)) { index, popUpStore, cell in
                cell.injectionWith(input: HomeDetailPopUpCell.Input(
                    image: popUpStore.mainImageUrl,
                    category: popUpStore.category,
                    title: popUpStore.name,
                    location: popUpStore.address,
                    date: popUpStore.startDate
                ))
            }
            .disposed(by: disposeBag)
        print("DEBUG: 컬렉션 뷰 업데이트, 팝업 스토어 수: \(popUpStores.count)")
    }

    private func updateRecentSearches(with searches: [String]) {
        recentSearchStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        searches.forEach { search in
            let chip = createSearchChip(text: search)
            recentSearchStackView.addArrangedSubview(chip)
        }
    }

    private func createSearchChip(text: String) -> UIView {
        let chipView = UIView()
        chipView.layer.cornerRadius = 16
        chipView.layer.borderWidth = 1
        chipView.layer.borderColor = UIColor.lightGray.cgColor
        chipView.backgroundColor = .clear

        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)

        let removeButton = UIButton(type: .system)
        removeButton.setTitle("X", for: .normal)
        removeButton.setTitleColor(.black, for: .normal)
        removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        removeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.recentSearchesViewModel.input.removeSearchQuery.onNext(text)
            })
            .disposed(by: disposeBag)

        chipView.addSubview(label)
        chipView.addSubview(removeButton)

        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }

        removeButton.snp.makeConstraints { make in
            make.left.equalTo(label.snp.right).offset(8)
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }

        chipView.snp.makeConstraints { make in
            make.height.equalTo(32)
        }

        return chipView
    }
    private func updateTotalCountLabel(count: Int) {
        totalCountLabel.text = "총 \(count)개"
    }

    private func bindActions() {
        categoryFilterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showCategoryFilterBottomSheet()
            })
            .disposed(by: disposeBag)

        sortFilterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showSortFilterBottomSheet()
            })
            .disposed(by: disposeBag)
    }

    private func showCategoryFilterBottomSheet() {
        categoryFilterBottomSheet.modalPresentationStyle = .pageSheet
        if let sheet = categoryFilterBottomSheet.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }

        categoryFilterBottomSheet.onFiltersApplied = { [weak self] selectedCategories in
            guard let self = self else { return }
            let categoryText = selectedCategories.isEmpty ? "카테고리" : "\(selectedCategories.first ?? "") 외 \(selectedCategories.count - 1)개"
            self.categoryFilterButton.setTitle(categoryText, for: .normal)
            self.updateCategoryFilterButtonUI(selectedCategories: selectedCategories)
        }

        present(categoryFilterBottomSheet, animated: true, completion: nil)
    }

    private func showSortFilterBottomSheet() {
        sortFilterBottomSheet.modalPresentationStyle = .pageSheet
        if let sheet = sortFilterBottomSheet.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(sortFilterBottomSheet, animated: true, completion: nil)
    }

    private func updateCategoryFilterButtonUI(selectedCategories: [String]) {
        let buttonTitle = selectedCategories.isEmpty ? "카테고리" : "\(selectedCategories.first ?? "") 외 \(selectedCategories.count - 1)개"
        categoryFilterButton.setTitle(buttonTitle, for: .normal)

        categoryFilterButton.invalidateIntrinsicContentSize()
        categoryFilterButton.sizeToFit()

        if !selectedCategories.isEmpty {
            categoryFilterButton.backgroundColor = .systemBlue
            categoryFilterButton.setTitleColor(.white, for: .normal)
            categoryFilterButton.layer.borderWidth = 0

            let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
            let xmarkImage = UIImage(systemName: "xmark", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
            categoryFilterButton.setImage(xmarkImage, for: .normal)

            categoryFilterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
            categoryFilterButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            categoryFilterButton.semanticContentAttribute = .forceRightToLeft
        } else {
            categoryFilterButton.backgroundColor = .white
            categoryFilterButton.setTitleColor(.systemBlue, for: .normal)
            categoryFilterButton.layer.borderWidth = 1
            categoryFilterButton.setImage(nil, for: .normal)
            categoryFilterButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        }

        categoryFilterButton.layoutIfNeeded()
    }
    private func filterPopUpStores(with query: String) {
        filteredPopUpStores = allPopUpStores.filter { popUpStore in
            return popUpStore.name.lowercased().contains(query.lowercased()) ||
                   popUpStore.category.lowercased().contains(query.lowercased())
        }

        updateCollectionView(with: filteredPopUpStores)

        noResultsLabel.isHidden = !filteredPopUpStores.isEmpty
    }

    private func updateUIForSearchState(_ state: SearchState) {
        UIView.animate(withDuration: 0.3) {
            switch state {
            case .initial:
                self.titleLabel.isHidden = false
                self.recentSearchScrollView.isHidden = false
                self.clearAllButton.isHidden = false
                self.findPopupLabel.isHidden = false
                self.categoryFilterButton.isHidden = false
                self.sortFilterButton.isHidden = false
                self.suggestionTableView.isHidden = true
                self.curationPopupCollectionView.isHidden = false
                self.totalCountLabel.isHidden = false
            case .searching:
                self.titleLabel.isHidden = true
                self.recentSearchScrollView.isHidden = true
                self.clearAllButton.isHidden = true
                self.findPopupLabel.isHidden = true
                self.categoryFilterButton.isHidden = true
                self.sortFilterButton.isHidden = true
                self.curationPopupCollectionView.isHidden = true
                self.totalCountLabel.isHidden = true
                self.suggestionTableView.isHidden = false
            case .results:
                self.suggestionTableView.isHidden = true
            }
        }
    }

}
