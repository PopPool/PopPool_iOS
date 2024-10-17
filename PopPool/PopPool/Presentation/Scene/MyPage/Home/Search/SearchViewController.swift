import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources

class SearchViewController: UIViewController {
    private let searchViewModel: SearchViewModel
    private let recentSearchesViewModel = RecentSearchesViewModel()
    private let entirePopupViewModel: EntirePopupVM
    private let searchResultsView = SearchResultsView()
    private let homeViewModel: HomeVM

    private let searchResultsSubject = BehaviorSubject<[SectionModel<String, HomePopUp>]>(value: [])
    private let popUpStoresSubject = BehaviorSubject<[SectionModel<String, HomePopUp>]>(value: [])

    private var allPopUpStores: [HomePopUp] = []
    private var filteredPopUpStores: [HomePopUp] = []

    let homeResponse = GetHomeInfoResponse()

    private let disposeBag = DisposeBag()

    private var isSearching: Bool = false {
        didSet {
            updateUIForSearchState(isSearching ? .searching : .initial)
        }
    }
    private let provider: Provider
    private let tokenInterceptor: TokenInterceptor

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

    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, HomePopUp>>(
        configureCell: { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailPopUpCell.identifier, for: indexPath) as! HomeDetailPopUpCell
            cell.injectionWith(input: HomeDetailPopUpCell.Input(
                image: item.mainImageUrl,
                category: item.category,
                title: item.name,
                location: item.address,
                date: item.startDate
            ))
            return cell
        }
    )

    // MARK: - Initialization
    init(viewModel: SearchViewModel, entirePopupViewModel: EntirePopupVM, homeViewModel: HomeVM,
    provider: Provider, tokenInterceptor: TokenInterceptor) {
        self.searchViewModel = viewModel
        self.entirePopupViewModel = entirePopupViewModel
        self.homeViewModel = homeViewModel
        self.provider = provider
        self.tokenInterceptor = tokenInterceptor

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
        bindSearchResults()
        searchResultsView.registerCell()
        

        curationPopupCollectionView.delegate = self
        searchResultsView.getCollectionView().delegate = self

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
        view.addSubview(searchResultsView)

        curationPopupCollectionView.register(HomeDetailPopUpCell.self, forCellWithReuseIdentifier: HomeDetailPopUpCell.identifier)
        view.addSubview(totalCountLabel)
        view.addSubview(noResultsLabel)
        view.addSubview(curationPopupCollectionView)
        view.addSubview(titleLabel)
        view.addSubview(recentSearchScrollView)

        recentSearchScrollView.addSubview(recentSearchStackView)
        view.addSubview(clearAllButton)
        view.addSubview(findPopupLabel)
        view.addSubview(categoryFilterButton)
        view.addSubview(sortFilterButton)

        searchResultsView.isHidden = true

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
        searchResultsView.snp.makeConstraints { make in
               make.top.equalTo(searchBar.snp.bottom).offset(10)
               make.leading.trailing.bottom.equalToSuperview()
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
                guard let self = self else { return }

                if query.isEmpty {
                    self.isSearching = false
                    self.updateUIForSearchState(.initial)
                    self.noResultsLabel.isHidden = true
                } else {
                    self.isSearching = true
                    self.updateUIForSearchState(.searching)
                    self.searchViewModel.input.searchQuery.onNext(query)
                    self.noResultsLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] query in
                self?.performSearch(with: query)
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

        suggestionTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.searchViewModel.output.realTimeSuggestions
                    .observe(on: MainScheduler.instance)
                    .take(1)
                    .subscribe(onNext: { suggestions in
                        let suggestion = suggestions[indexPath.row]
                        // self?.performSearch(with: suggestion) 
                    })
                    .disposed(by: self!.disposeBag)
            })
            .disposed(by: disposeBag)

        curationPopupCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                if indexPath.item < self.filteredPopUpStores.count {
                    let selectedPopUp = self.filteredPopUpStores[indexPath.item]

                    let provider = AppDIContainer.shared.resolve(type: Provider.self)
                    let tokenInterceptor = AppDIContainer.shared.resolve(type: TokenInterceptor.self)
                    let repository = DefaultPopUpRepository(provider: provider, tokenInterceptor: tokenInterceptor)

                    // PopUpDetailUseCase 인스턴스 생성
                    let useCase = DefaultPopUpDetailUseCase(repository: repository)

                    let userCommentsViewModel = UserCommentsViewModel(useCase: useCase)

                    // PopupDetailViewModel 인스턴스 생성
                    let detailViewModel = PopupDetailViewModel(useCase: useCase, popupId: selectedPopUp.id, userId: String(Constants.userId), userCommentsViewModel: userCommentsViewModel)
                    

                    // UserCommentsViewModel 인스턴스 생성

                    // PopupDetailViewController 인스턴스 생성 및 userCommentsViewModel 전달
                    let detailVC = PopupDetailViewController(viewModel: detailViewModel, userCommentsViewModel: userCommentsViewModel, userId: String(Constants.userId))

                    self.navigationController?.pushViewController(detailVC, animated: true)

                } else {
                    print("인덱스 범위 초과: \(indexPath.item), filteredPopUpStores 개수: \(self.filteredPopUpStores.count)")
                }
            })
            .disposed(by: disposeBag)


        popUpStoresSubject
            .bind(to: curationPopupCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        loadCurationPopupData()
        
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

    private func loadCurationPopupData() {
        let output = entirePopupViewModel.transform(input: EntirePopupVM.Input())
        output.fetchedDataResponse
            .map { response -> [SectionModel<String, HomePopUp>] in
                let popularSection = SectionModel(model: "Popular", items: response.popularPopUpStoreList ?? [])
                return [popularSection]
            }
            .do(onNext: { [weak self] sections in
                let totalCount = sections.flatMap { $0.items }.count
                self?.allPopUpStores = sections.flatMap { $0.items }
            })
            .bind(to: popUpStoresSubject)
            .disposed(by: disposeBag)
    }

    private func performSearch(with query: String) {
        print("검색 실행: \(query)")
        recentSearchesViewModel.input.addSearchQuery.onNext(query)

        filteredPopUpStores = allPopUpStores.filter { popUpStore in
            return popUpStore.name.lowercased().contains(query.lowercased()) ||
                   popUpStore.category.lowercased().contains(query.lowercased())
        }

        searchResultsView.updateLabels(query: query, resultCount: filteredPopUpStores.count)
        let searchSection = SectionModel(model: "Search Results", items: filteredPopUpStores)
        searchResultsSubject.onNext([searchSection])

        updateUIForSearchState(.results)

        noResultsLabel.isHidden = !filteredPopUpStores.isEmpty
    }


    private func setupCollectionView() {
           let resultsCollectionView = searchResultsView.getCollectionView()
           resultsCollectionView.delegate = self
           resultsCollectionView.dataSource = self
       }

    private func bindSearchResults() {
        let resultsCollectionView = searchResultsView.getCollectionView()
        searchResultsSubject
             .observe(on: MainScheduler.instance)
             .do(onNext: { [weak self] sections in
                 print("검색 결과 업데이트: \(sections.flatMap { $0.items }.count)개의 아이템")
             })
             .bind(to: resultsCollectionView.rx.items(dataSource: dataSource))
             .disposed(by: disposeBag)
     }




    private func updateCollectionView(with popUpStores: [HomePopUp]) {
        let section = SectionModel(model: "Search Results", items: popUpStores)
        popUpStoresSubject.onNext([section])
//        print("DEBUG: 컬렉션 뷰 업데이트, 팝업 스토어 수: \(popUpStores.count)")
    }

    private func updateRecentSearches(with searches: [String]) {
        recentSearchStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        searches.forEach { search in
            let chip = createSearchChip(text: search)

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapRecentSearch(_:)))
            chip.addGestureRecognizer(tapGesture)
            chip.isUserInteractionEnabled = true

            recentSearchStackView.addArrangedSubview(chip)
        }
    }

    @objc private func didTapRecentSearch(_ sender: UITapGestureRecognizer) {
        if let chip = sender.view as? UIView, let label = chip.subviews.first(where: { $0 is UILabel }) as? UILabel {
            let searchQuery = label.text ?? ""
            searchBar.text = searchQuery
            searchBar.delegate?.searchBarSearchButtonClicked?(searchBar)
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
                self.searchResultsView.isHidden = true
                self.totalCountLabel.isHidden = false
                self.loadCurationPopupData()
            case .searching:
                self.titleLabel.isHidden = true
                self.recentSearchScrollView.isHidden = true
                self.clearAllButton.isHidden = true
                self.findPopupLabel.isHidden = true
                self.categoryFilterButton.isHidden = true
                self.sortFilterButton.isHidden = true
                self.curationPopupCollectionView.isHidden = true
                self.searchResultsView.isHidden = true
                self.totalCountLabel.isHidden = true
                self.suggestionTableView.isHidden = false
            case .results:
                self.suggestionTableView.isHidden = true
                self.curationPopupCollectionView.isHidden = true
                self.searchResultsView.isHidden = false
                self.totalCountLabel.isHidden = false
                self.categoryFilterButton.isHidden = true
                self.sortFilterButton.isHidden = true

            }
        }
    }
}
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPopUpStores.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailPopUpCell.identifier, for: indexPath) as? HomeDetailPopUpCell else {
            fatalError("Unable to dequeue HomeDetailPopUpCell")
        }

        let popUp = filteredPopUpStores[indexPath.item]
        cell.injectionWith(input: HomeDetailPopUpCell.Input(
            image: popUp.mainImageUrl,
            category: popUp.category,
            title: popUp.name,
            location: popUp.address,
            date: popUp.startDate
        ))

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("디버그: 셀이 선택되었습니다. 인덱스: \(indexPath.item)")

        let selectedPopUp: HomePopUp
        if collectionView == curationPopupCollectionView {
            guard indexPath.item < allPopUpStores.count else {
                print("오류: 큐레이션 팝업 스토어 인덱스 범위 초과. 인덱스: \(indexPath.item), 전체 개수: \(allPopUpStores.count)")
                return
            }
            selectedPopUp = allPopUpStores[indexPath.item]
            print("디버그: 큐레이션 팝업 스토어가 선택되었습니다.")
        } else {
            guard indexPath.item < filteredPopUpStores.count else {
                print("오류: 필터링된 팝업 스토어 인덱스 범위 초과. 인덱스: \(indexPath.item), 필터링된 개수: \(filteredPopUpStores.count)")
                return
            }
            selectedPopUp = filteredPopUpStores[indexPath.item]
            print("디버그: 검색 결과 팝업 스토어가 선택되었습니다.")
        }

        print("디버그: 선택된 팝업 스토어 ID: \(selectedPopUp.id), 이름: \(selectedPopUp.name)")

        let provider = AppDIContainer.shared.resolve(type: Provider.self)
        let tokenInterceptor = AppDIContainer.shared.resolve(type: TokenInterceptor.self)
        let repository = DefaultPopUpRepository(provider: provider, tokenInterceptor: tokenInterceptor)

        // PopUpDetailUseCase 인스턴스 생성
        let useCase = DefaultPopUpDetailUseCase(repository: repository)

        let userCommentsViewModel = UserCommentsViewModel(useCase: useCase)

        // PopupDetailViewModel 인스턴스 생성
        let detailViewModel = PopupDetailViewModel(useCase: useCase, popupId: selectedPopUp.id, userId: String(Constants.userId), userCommentsViewModel: userCommentsViewModel)

        // UserCommentsViewModel 인스턴스 생성

        // PopupDetailViewController 인스턴스 생성 및 userCommentsViewModel 전달
        let detailVC = PopupDetailViewController(viewModel: detailViewModel, userCommentsViewModel: userCommentsViewModel, userId: String(Constants.userId))

        self.navigationController?.pushViewController(detailVC, animated: true)


        print("디버그: 팝업 상세 페이지로 이동을 시도합니다.")
//        navigationController?.pushViewController(detailVC, animated: true)

        if navigationController == nil {
            print("오류: navigationController가 nil입니다. 페이지 이동이 불가능합니다.")
        }
    }
}
