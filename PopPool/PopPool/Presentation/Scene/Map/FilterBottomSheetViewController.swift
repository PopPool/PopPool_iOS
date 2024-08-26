import UIKit
import RxSwift
import RxCocoa
import SnapKit

class FilterBottomSheetViewController: UIViewController {
    private let viewModel: MapVM
    private let disposeBag = DisposeBag()

    private let containerView = UIView()
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)

    private let segmentedControl = SegmentedControlCPNT(type: .tab, segments: ["지역", "카테고리"], selectedSegmentIndex: 0)
    private let underlineView = UIView()

    private let locationScrollView = UIScrollView()
    private let locationContentView = UIView()
    private let balloonBackgroundView = BalloonBackgroundView()

    private let categoryScrollView = UIScrollView()
    private let categoryContentView = UIView()
    private var categoryButtons: [UIButton] = []

    private let selectedFiltersView = UIView()
    private let selectedFiltersLabel = UILabel()
    private let selectedFiltersCollectionView: UICollectionView
    private let selectedOptionsLabel: UILabel = {
        let label = UILabel()
        label.text = "선택한 옵션"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()

    private let resetButton = ButtonCPNT(type: .secondary, title: "초기화")
    private let applyButton = ButtonCPNT(type: .primary, title: "옵션저장")

    private let categories = ["게임", "라이프스타일", "반려동물", "뷰티", "스포츠", "애니메이션", "엔터테인먼트", "여행", "예술", "음식/요리", "키즈", "패션"]

    private let locationData: [(main: String, sub: [String])] = [
        ("서울", ["서울전체", "강남/역삼/선릉", "건대/군자/구의", "금호/옥수/신당", "명동/을지로/충무로", "방이", "북촌/삼청", "삼성/대치", "상수/합정/망원"]),
        ("경기", ["수원시", "성남시", "용인시", "고양시"]),
        ("인천", ["중구", "동구", "미추홀구", "연수구"]),
        ("부산", ["중구", "서구", "동구", "영도구"]),
        ("제주", ["제주시", "서귀포시"])
    ]

    private var selectedLocationIndex: Int? = nil
    private var subcategoryButtons: [UIButton] = []

    var onCategoryFilterApplied: ((String?) -> Void)?

    init(viewModel: MapVM) {
        self.viewModel = viewModel

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        selectedFiltersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupCategoryTab()
    }

    private func setupUI() {
        view.backgroundColor = .clear

        view.addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        containerView.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(closeButton)
        headerView.addSubview(segmentedControl)
        headerView.addSubview(underlineView)

        containerView.addSubview(locationScrollView)
        locationScrollView.addSubview(locationContentView)
        containerView.addSubview(balloonBackgroundView)

        containerView.addSubview(categoryScrollView)
        categoryScrollView.addSubview(categoryContentView)

        containerView.addSubview(selectedOptionsLabel)

        containerView.addSubview(selectedFiltersView)
        selectedFiltersView.addSubview(selectedFiltersLabel)
        selectedFiltersView.addSubview(selectedFiltersCollectionView)

        containerView.addSubview(resetButton)
        containerView.addSubview(applyButton)

        setupConstraints()
        setupLocationScrollView()
        setupCollectionView()
        setupButtons()

        titleLabel.text = "보기 옵션을 선택해주세요"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)

        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)

        setupSegmentedControl()
    }

    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .clear
        segmentedControl.selectedSegmentTintColor = .clear

        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ], for: .normal)
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ], for: .selected)

        underlineView.backgroundColor = .blue
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.75)
        }

        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        underlineView.snp.makeConstraints { make in
            make.bottom.equalTo(segmentedControl.snp.bottom)
            make.height.equalTo(2)
            make.width.equalTo(segmentedControl.snp.width).dividedBy(2)
            make.leading.equalTo(segmentedControl.snp.leading)
        }

        locationScrollView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }

        locationContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }

        balloonBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(locationScrollView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(0)
        }

        categoryScrollView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }

        categoryContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        selectedOptionsLabel.snp.makeConstraints { make in
            make.top.equalTo(balloonBackgroundView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        selectedFiltersView.snp.makeConstraints { make in
            make.top.equalTo(selectedOptionsLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }

        selectedFiltersLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        selectedFiltersCollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectedFiltersLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }

        resetButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(20)
            make.width.equalTo(160)
            make.height.equalTo(60)
        }

        applyButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.width.equalTo(160)
            make.height.equalTo(60)
        }
    }

    private func setupLocationScrollView() {
        var lastButton: UIButton?

        for (index, location) in locationData.enumerated() {
            let button = createFilterButton(title: location.main)
            button.tag = index
            button.addTarget(self, action: #selector(locationButtonTapped(_:)), for: .touchUpInside)
            locationContentView.addSubview(button)

            button.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                if let lastButton = lastButton {
                    make.leading.equalTo(lastButton.snp.trailing).offset(10)
                } else {
                    make.leading.equalToSuperview().offset(20)
                }
                if index == locationData.count - 1 {
                    make.trailing.equalToSuperview().inset(20)
                }
            }

            lastButton = button
        }
    }

    private func setupCategoryTab() {
        var lastButton: UIButton?
        var currentY: CGFloat = 0

        for (index, category) in categories.enumerated() {
            let button = createCategoryButton(title: category)
            categoryButtons.append(button)
            categoryContentView.addSubview(button)

            button.snp.makeConstraints { make in
                if index % 3 == 0 {
                    make.top.equalToSuperview().offset(currentY)
                    make.leading.equalToSuperview().offset(20)
                } else {
                    make.top.equalTo(lastButton!.snp.top)
                    make.leading.equalTo(lastButton!.snp.trailing).offset(10)
                }

                // 버튼 크기를 텍스트에 맞게 동적으로 설정
                button.sizeToFit()
                let buttonWidth = button.frame.width + 16 // 패딩 추가
                make.width.equalTo(buttonWidth)
                make.height.equalTo(40)
            }

            lastButton = button

            if index % 3 == 2 {
                currentY += 50
            }
        }

        categoryContentView.snp.makeConstraints { make in
            make.bottom.equalTo(lastButton!.snp.bottom).offset(20)
        }

        categoryScrollView.isHidden = true
    }

    private func createFilterButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return button
    }

    private func createCategoryButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)

        // 텍스트 양쪽에 더 많은 여백을 주기 위한 패딩 설정
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)

        // 버튼의 최소 너비 설정 (필요에 따라 조정)
        button.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.greaterThanOrEqualTo(100)
        }

        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        return button
    }

    private func setupCollectionView() {
        selectedFiltersCollectionView.register(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        selectedFiltersCollectionView.backgroundColor = .clear
        selectedFiltersCollectionView.showsHorizontalScrollIndicator = false
        selectedFiltersCollectionView.delegate = self
    }

    private func setupButtons() {
        resetButton.setTitle("초기화", for: .normal)
        resetButton.setTitleColor(.blue, for: .normal)

        applyButton.setTitle("옵션저장", for: .normal)
        applyButton.backgroundColor = .blue
        applyButton.setTitleColor(.white, for: .normal)
    }

    private func setupBindings() {
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        segmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] index in
                self?.updateContentVisibility(index == 1)
                self?.moveUnderlineView(to: index)
            })
            .disposed(by: disposeBag)

        resetButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.resetFilters()
                self?.selectedLocationIndex = nil
                self?.updateLocationButtonsUI()
                self?.updateSubcategoryScrollView()
                self?.updateCategoryButtonsUI()
            })
            .disposed(by: disposeBag)

        applyButton.rx.tap
            .subscribe(onNext: { [weak self] in
                // 카테고리 필터가 저장되면 onCategoryFilterApplied 클로저를 호출
                if let selectedCategory = self?.viewModel.getSelectedCategory() {
                    self?.onCategoryFilterApplied?(selectedCategory)
                }
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        viewModel.selectedFilters
            .bind(to: selectedFiltersCollectionView.rx.items(cellIdentifier: "FilterCell", cellType: FilterCell.self)) { [weak self] (row, filter, cell) in
                cell.configure(with: filter.name)
                cell.onRemove = {
                    self?.viewModel.removeFilter(filter)
                    self?.updateLocationButtonsUI()
                    self?.updateSubcategoryScrollView()
                    self?.updateCategoryButtonsUI()
                }
            }
            .disposed(by: disposeBag)
    }

    @objc private func locationButtonTapped(_ sender: UIButton) {
        selectedLocationIndex = sender.tag
        updateSubcategoryScrollView()
        updateLocationButtonsUI()
        view.layoutIfNeeded()
    }

    @objc private func categoryButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        updateCategoryButtonAppearance(sender)

        if let category = sender.titleLabel?.text {
            if sender.isSelected {
                viewModel.addFilter(MapVM.Filter(id: UUID().uuidString, name: category, type: .category))
            } else {
                viewModel.removeFilter(MapVM.Filter(id: "", name: category, type: .category))
            }
        }
        selectedFiltersCollectionView.reloadData()
    }

    private func updateSubcategoryScrollView() {
        guard let index = selectedLocationIndex else {
            balloonBackgroundView.isHidden = true
            balloonBackgroundView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            return
        }

        let subcategories = locationData[index].sub
        setupSubcategoryButtons(subcategories)

        balloonBackgroundView.isHidden = false
        updateBalloonPosition()
    }

    private func setupSubcategoryButtons(_ subcategories: [String]) {
        balloonBackgroundView.subviews.forEach { $0.removeFromSuperview() }
        subcategoryButtons.removeAll()

        let buttonHeight: CGFloat = 32
        let spacing: CGFloat = 10
        let verticalSpacing: CGFloat = 10
        let maxWidth = balloonBackgroundView.frame.width - 20

        var currentX: CGFloat = 10
        var currentY: CGFloat = 20

        for subcategory in subcategories {
            let button = UIButton(type: .system)
            button.setTitle(subcategory, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12) // 기본 텍스트 크기를 줄임
            button.addTarget(self, action: #selector(subcategoryButtonTapped(_:)), for: .touchUpInside)
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = buttonHeight / 2

            button.sizeToFit()
            let buttonWidth = button.frame.width + 24

            if currentX + buttonWidth > maxWidth {
                currentX = 10
                currentY += buttonHeight + spacing
            }

            button.frame = CGRect(x: currentX, y: currentY, width: buttonWidth, height: buttonHeight)
            balloonBackgroundView.addSubview(button)
            subcategoryButtons.append(button)

            currentX += buttonWidth + spacing
        }

        let contentHeight = currentY + buttonHeight + 10
        balloonBackgroundView.snp.updateConstraints { make in
            make.height.equalTo(contentHeight)
        }

        view.layoutIfNeeded()
    }

    @objc private func subcategoryButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        UIView.animate(withDuration: 0.3) {
            if sender.isSelected {
                sender.backgroundColor = .blue
                sender.setTitleColor(.white, for: .normal)

                let checkmarkAttachment = NSTextAttachment()
                checkmarkAttachment.image = UIImage(systemName: "checkmark")?.withTintColor(.white)
                checkmarkAttachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)

                // 현재 텍스트에 체크마크 추가
                let attributedString = NSMutableAttributedString(string: (sender.titleLabel?.text ?? "") + "\u{00A0}")
                attributedString.append(NSAttributedString(attachment: checkmarkAttachment))

                sender.setAttributedTitle(attributedString, for: .normal)

                // 버튼 크기 조정 (체크마크 포함)
                sender.sizeToFit()
                sender.frame.size.width += 24 // padding 추가

            } else {
                // 체크마크를 제거하고 원래 텍스트로 복구
                sender.backgroundColor = .white
                sender.setTitleColor(.black, for: .normal)

                // 체크마크 없는 원래 텍스트로 복구
                let originalTitle = sender.title(for: .normal) ?? ""
                sender.setAttributedTitle(nil, for: .normal)
                sender.setTitle(originalTitle, for: .normal)

                // 버튼 크기 조정 (원래 사이즈로 복구)
                sender.sizeToFit()
                sender.frame.size.width += 24 // padding 추가
            }
        }
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 12) // 작은 크기로 고정

        // 버튼의 내부 상태 업데이트
        if let subcategory = sender.titleLabel?.text {
            if sender.isSelected {
                let filter = MapVM.Filter(id: UUID().uuidString, name: subcategory, type: .location)
                viewModel.addFilter(filter)
            } else {
                viewModel.removeFilter(MapVM.Filter(id: "", name: subcategory, type: .location))
            }
            selectedFiltersCollectionView.reloadData()
        }
    }

    private func updateBalloonPosition() {
        guard let selectedButton = locationContentView.subviews.first(where: { ($0 as? UIButton)?.tag == selectedLocationIndex }) as? UIButton else { return }
        let buttonFrame = selectedButton.convert(selectedButton.bounds, to: view)
        let buttonCenterX = buttonFrame.midX
        let totalWidth = view.bounds.size.width
        balloonBackgroundView.arrowPosition = buttonCenterX / totalWidth
    }

    private func updateLocationButtonsUI() {
        locationContentView.subviews.forEach { view in
            if let button = view as? UIButton {
                button.backgroundColor = button.tag == selectedLocationIndex ? .blue : .systemGray6
                button.setTitleColor(button.tag == selectedLocationIndex ? .white : .black, for: .normal)
            }
        }
    }

    private func updateCategoryButtonsUI() {
        categoryButtons.forEach { button in
            let isSelected = viewModel.selectedFilters.value.contains { $0.name == button.titleLabel?.text && $0.type == .category }
            updateCategoryButtonAppearance(button, isSelected: isSelected)
        }
    }

    private func updateCategoryButtonAppearance(_ button: UIButton, isSelected: Bool? = nil) {
        let selected = isSelected ?? button.isSelected
        UIView.animate(withDuration: 0.3) {
            if selected {
                button.backgroundColor = .blue
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .white
                button.setTitleColor(.black, for: .normal)
            }
        }
    }

    private func moveUnderlineView(to index: Int) {
        let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)
        let targetPosition = segmentWidth * CGFloat(index)

        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.underlineView.snp.updateConstraints { make in
                make.leading.equalTo(self.segmentedControl.snp.leading).offset(targetPosition)
            }
            self.view.layoutIfNeeded()
        }
    }

    private func updateContentVisibility(_ isCategorySelected: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.categoryScrollView.isHidden = !isCategorySelected
            self.locationScrollView.isHidden = isCategorySelected
            self.balloonBackgroundView.isHidden = isCategorySelected
        }
    }
}

extension FilterBottomSheetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = viewModel.selectedFilters.value[indexPath.item].name
        let textSize = (text as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
        return CGSize(width: textSize.width + 40, height: 32)
    }
}
