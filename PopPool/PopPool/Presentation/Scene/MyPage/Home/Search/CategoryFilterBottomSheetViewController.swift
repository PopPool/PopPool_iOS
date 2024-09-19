import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CategoryFilterBottomSheetViewController: UIViewController {
    private let categories = ["게임", "라이프스타일", "반려동물", "뷰티", "스포츠", "애니메이션", "엔터테인먼트", "여행", "예술", "음식/요리", "키즈", "패션"]

    private var selectedCategories: [String] = []
    private let disposeBag = DisposeBag()

    // 선택된 필터를 전달하기 위한 클로저
    var onFiltersApplied: (([String]) -> Void)?

    // 제목 레이블
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리를 선택해주세요"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()

    // 초기화 버튼
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("초기화", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()

    // 저장 버튼
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("옵션 저장", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()

    // 카테고리 버튼 스택 뷰
    private let categoryContainerView = UIView()

    private var categoryContainerHeightConstraint: Constraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCategoryButtons()
        bindActions()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 16

        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(categoryContainerView)
        view.addSubview(resetButton)
        view.addSubview(saveButton)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }

        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }

        categoryContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            self.categoryContainerHeightConstraint = make.height.equalTo(195).constraint
        }

        resetButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(categoryContainerView.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(161)
        }

        saveButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(categoryContainerView.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(161)
        }
    }

    private func setupCategoryButtons() {
        let buttonHeight: CGFloat = 34
        let buttonSpacing: CGFloat = 12
        let maxWidth = view.frame.width - 30

        var currentX: CGFloat = 0
        var currentY: CGFloat = 0

        for category in categories {
            let button = createStyledButton(title: category)
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            categoryContainerView.addSubview(button)

            button.sizeToFit()
            let buttonWidth = button.frame.width + 10

            // 버튼이 화면의 폭을 넘어가면 다음 줄로
            if currentX + buttonWidth > maxWidth {
                currentX = 0
                currentY += buttonHeight + buttonSpacing
            }

            button.frame = CGRect(x: currentX, y: currentY, width: buttonWidth, height: buttonHeight)

            currentX += buttonWidth + buttonSpacing
        }

        categoryContainerHeightConstraint?.update(offset: currentY + buttonHeight)
        view.layoutIfNeeded()
    }

    // 카테고리 버튼 스타일 설정
    private func createStyledButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return button
    }

    // 버튼 탭 처리
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if let category = sender.titleLabel?.text {
            if sender.isSelected {
                selectedCategories.append(category)
                sender.backgroundColor = .systemBlue
                sender.setTitleColor(.white, for: .normal)
            } else {
                selectedCategories.removeAll(where: { $0 == category })
                sender.backgroundColor = .white
                sender.setTitleColor(.systemGray, for: .normal)
            }
        }
    }

    private func bindActions() {
        saveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                // 선택된 카테고리 전달
                self?.onFiltersApplied?(self?.selectedCategories ?? [])
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)

        resetButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.resetCategories()
            })
            .disposed(by: disposeBag)

        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }

    // 카테고리 초기화
    private func resetCategories() {
        selectedCategories.removeAll()
        categoryContainerView.subviews.forEach { view in
            if let button = view as? UIButton {
                button.isSelected = false
                button.backgroundColor = .white
                button.setTitleColor(.systemGray, for: .normal)
            }
        }
        print("카테고리 초기화됨")
    }
}
