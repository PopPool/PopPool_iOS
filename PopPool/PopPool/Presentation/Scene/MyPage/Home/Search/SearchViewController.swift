import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchViewController: UIViewController {
    private let searchViewModel: SearchViewModel
    private let recentSearchesViewModel = RecentSearchesViewModel()

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

    private let searchResultsTableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
        return tv
    }()

    // 이미 생성된 바텀시트들 연결
    private let categoryFilterBottomSheet = CategoryFilterBottomSheetViewController()
    private let sortFilterBottomSheet = SortOrderBottomSheetViewController()

    // MARK: - Initialization
    init(viewModel: SearchViewModel) {
        self.searchViewModel = viewModel

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
        print("버튼 크기: \(categoryFilterButton.frame.size)")

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(cancelButton)
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
//            make.leading.equalTo(categoryFilterButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }


    // MARK: - Binding
    private func bindViewModel() {
        recentSearchesViewModel.output.recentSearches
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] searches in
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
                // 취소 버튼 클릭 시 이전 화면으로 돌아가는 로직
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                guard let query = self?.searchBar.text, !query.isEmpty else { return }
                // 최근 검색어에 추가
                self?.recentSearchesViewModel.input.addSearchQuery.onNext(query)
                // ViewModel에 검색어 전달
                self?.searchViewModel.input.searchQuery.onNext(query)
            })
            .disposed(by: disposeBag)
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

    // 필터 버튼과 바텀시트를 연결
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

        // 크기 자동 조정
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

        // 레이아웃 업데이트
        categoryFilterButton.layoutIfNeeded()
        print("버튼 크기: \(categoryFilterButton.frame.size)")
    }
}
