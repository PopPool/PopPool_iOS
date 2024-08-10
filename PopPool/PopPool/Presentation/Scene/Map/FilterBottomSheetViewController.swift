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

    private let segmentedControl = UISegmentedControl(items: ["지역", "카테고리"])
    private let underlineView = UIView()

    private let locationScrollView = UIScrollView()
    private let locationContentView = UIView()

    private let subcategoryScrollView = UIScrollView()
    private let subcategoryContentView = UIView()
    private let balloonBackgroundView = BalloonBackgroundView()

    private let categoryStackView = UIStackView()

    private let selectedFiltersView = UIView()
    private let selectedFiltersLabel = UILabel()
    private let selectedFiltersCollectionView: UICollectionView

    private let resetButton = UIButton(type: .system)
    private let applyButton = UIButton(type: .system)

    // 지역 및 하위 카테고리 데이터
    private let locationData: [(main: String, sub: [String])] = [
        ("서울", ["강남구", "서초구", "송파구", "강동구"]),
        ("경기", ["수원시", "성남시", "용인시", "고양시"]),
        ("인천", ["중구", "동구", "미추홀구", "연수구"]),
        ("부산", ["중구", "서구", "동구", "영도구"]),
        ("제주", ["제주시", "서귀포시"])
    ]

    private var selectedLocationIndex: Int? = nil

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

        containerView.addSubview(subcategoryScrollView)
        subcategoryScrollView.addSubview(subcategoryContentView)

        containerView.addSubview(balloonBackgroundView)

        containerView.addSubview(categoryStackView)

        containerView.addSubview(selectedFiltersView)
        selectedFiltersView.addSubview(selectedFiltersLabel)
        selectedFiltersView.addSubview(selectedFiltersCollectionView)

        containerView.addSubview(resetButton)
        containerView.addSubview(applyButton)

        setupConstraints()
        setupLocationScrollView()
        setupSubcategoryScrollView()
        setupCategoryStackView()
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
            make.height.equalTo(view.snp.height).multipliedBy(0.9)
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

        subcategoryScrollView.snp.makeConstraints { make in
            make.top.equalTo(locationScrollView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }

        subcategoryContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }

        balloonBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(subcategoryScrollView.snp.top).offset(-10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(64)
        }

        categoryStackView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        selectedFiltersView.snp.makeConstraints { make in
            make.top.equalTo(subcategoryScrollView.snp.bottom).offset(20)
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
            make.width.equalTo(100)
            make.height.equalTo(44)
        }

        applyButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.width.equalTo(100)
            make.height.equalTo(44)
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

    private func setupSubcategoryScrollView() {
        // 초기에는 비어있음. 지역 선택 시 동적으로 채워짐
    }

    private func setupCategoryStackView() {
        categoryStackView.axis = .vertical
        categoryStackView.spacing = 10
        categoryStackView.alignment = .fill
        categoryStackView.distribution = .fillEqually

        let categoryTitles = ["뷰티", "스포츠", "예능", "바이브룸", "맛집"]
        categoryTitles.forEach { title in
            let button = createFilterButton(title: title)
            categoryStackView.addArrangedSubview(button)
        }

        categoryStackView.isHidden = true
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

    @objc private func locationButtonTapped(_ sender: UIButton) {
        selectedLocationIndex = sender.tag
        updateSubcategoryScrollView()
        updateLocationButtonsUI()
        updateBalloonPosition()
    }

    private func updateSubcategoryScrollView() {
        subcategoryContentView.subviews.forEach { $0.removeFromSuperview() }

        guard let index = selectedLocationIndex else { return }

        let subcategories = locationData[index].sub
        var lastButton: UIButton?

        for (index, subcategory) in subcategories.enumerated() {
            let button = createFilterButton(title: subcategory)
            subcategoryContentView.addSubview(button)

            button.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                if let lastButton = lastButton {
                    make.leading.equalTo(lastButton.snp.trailing).offset(10)
                } else {
                    make.leading.equalToSuperview().offset(20)
                }
                if index == subcategories.count - 1 {
                    make.trailing.equalToSuperview().inset(20)
                }
            }

            lastButton = button
        }
    }

    private func updateBalloonPosition() {
        guard let selectedButton = locationContentView.subviews.first(where: { ($0 as? UIButton)?.tag == selectedLocationIndex }) as? UIButton else { return }
        let buttonFrame = selectedButton.frame
        let buttonCenterX = buttonFrame.origin.x + buttonFrame.size.width / 2
        let totalWidth = view.bounds.size.width - 40 // 인셋을 고려한 전체 너비
        balloonBackgroundView.arrowPosition = buttonCenterX / totalWidth
        balloonBackgroundView.arrowDirection = .up
    }

    private func updateLocationButtonsUI() {
        locationContentView.subviews.forEach { view in
            if let button = view as? UIButton {
                button.backgroundColor = button.tag == selectedLocationIndex ? .blue : .systemGray6
                button.setTitleColor(button.tag == selectedLocationIndex ? .white : .black, for: .normal)
            }
        }
    }

    private func setupCollectionView() {
        selectedFiltersCollectionView.register(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        selectedFiltersCollectionView.backgroundColor = .clear
        selectedFiltersCollectionView.showsHorizontalScrollIndicator = false
    }

    private func setupButtons() {
        resetButton.setTitle("초기화", for: .normal)
        resetButton.setTitleColor(.blue, for: .normal)

        applyButton.setTitle("옵션저장", for: .normal)
        applyButton.backgroundColor = .blue
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.layer.cornerRadius = 22
    }

    private func setupBindings() {
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        segmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] index in
                self?.locationScrollView.isHidden = index != 0
                self?.subcategoryScrollView.isHidden = index != 0
                self?.categoryStackView.isHidden = index != 1
                self?.moveUnderlineView(to: index)
            })
            .disposed(by: disposeBag)

        resetButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.resetFilters()
                self?.selectedLocationIndex = nil
                self?.updateLocationButtonsUI()
                self?.updateSubcategoryScrollView()
            })
            .disposed(by: disposeBag)

        applyButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.applyFilters()
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        viewModel.selectedFilters
            .bind(to: selectedFiltersCollectionView.rx.items(cellIdentifier: "FilterCell", cellType: FilterCell.self)) { (row, item, cell) in
                cell.configure(with: item.name)
            }
            .disposed(by: disposeBag)
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
}
