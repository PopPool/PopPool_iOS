import UIKit
import SnapKit

enum TabBarItemType {
    case map
    case home
    case my

    var title: String {
        switch self {
        case .map:
            return "지도"
        case .home:
            return "홈"
        case .my:
            return "마이"
        }
    }

    var icon: UIImage? {
        switch self {
        case .map:
            return UIImage(systemName: "map")
        case .home:
            return UIImage(systemName: "house")
        case .my:
            return UIImage(systemName: "person")
        }
    }

    var selectedIcon: UIImage? {
        switch self {
        case .map:
            return UIImage(systemName: "map.fill")
        case .home:
            return UIImage(systemName: "house.fill")
        case .my:
            return UIImage(systemName: "person.fill")
        }
    }
}

class CustomTabBarCPNT: UIView {

    // MARK: - Properties
    private var items: [TabBarItemType] = []
    var selectedIndex: Int = 0 {  // 초기 선택은 중앙에 있는 홈 탭으로 설정
        didSet {
            updateSelection()
        }
    }
    var onItemSelected: ((Int) -> Void)?

    // MARK: - UI Components
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        return view
    }()

    private let pointerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 8  // 포인터를 둥글게 만들기 (16x16 크기)
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor  // 포인터 경계선 색
        return view
    }()

    // MARK: - Initialization
    init(items: [TabBarItemType]) {
        super.init(frame: .zero)
        self.items = items
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setup() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)) // 하단 여유 공간
        }

        items.enumerated().forEach { index, item in
            let itemView = createItemView(for: item, at: index)
            stackView.addArrangedSubview(itemView)
        }

        // 중앙 포인터 뷰 추가
        addSubview(pointerView)
        pointerView.snp.makeConstraints { make in
            make.width.equalTo(16)
            make.height.equalTo(16)
            make.centerX.equalTo(stackView.arrangedSubviews[selectedIndex].snp.centerX)
            make.bottom.equalTo(stackView.snp.top).offset(6)
        }

        backgroundColor = .white


        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4

        updateSelection()
    }

    // MARK: - 탭바 하단에 곡선 추가
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addCurvePath(to: rect)
    }

    private func addCurvePath(to rect: CGRect) {
        let pointerDiameter: CGFloat = 16
        let curveHeight: CGFloat = pointerDiameter * 1.2
        let curveWidth: CGFloat = pointerDiameter * 1.5

        let path = UIBezierPath()

        // 좌측 상단 시작
        path.move(to: CGPoint(x: 0, y: 0))

        // 중앙으로 직선 이동
        path.addLine(to: CGPoint(x: (rect.width / 2) - (curveWidth / 2), y: 0))

        // 곡선을 깊게 파기 (포인터 아래로 자연스럽게 파여서 떠 있는 느낌으로)
        path.addQuadCurve(
            to: CGPoint(x: (rect.width / 2) + (curveWidth / 2), y: 0),
            controlPoint: CGPoint(x: rect.width / 2, y: curveHeight)
        )

        // 우측 상단 끝으로 직선 이동
        path.addLine(to: CGPoint(x: rect.width, y: 0))

        // 우측 하단 끝으로 직선 이동
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))

        // 좌측 하단 끝으로 직선 이동
        path.addLine(to: CGPoint(x: 0, y: rect.height))

        // 경로 닫기
        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        layer.insertSublayer(shapeLayer, at: 0)
    }

    // MARK: - 아이템 뷰 생성
    private func createItemView(for item: TabBarItemType, at index: Int) -> UIView {
        let itemView = UIView()
        let imageView = UIImageView(image: item.icon)
        let label = UILabel()

        label.text = item.title
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center

        itemView.addSubview(imageView)
        itemView.addSubview(label)

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(24)
        }

        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(itemTapped(_:)))
        itemView.addGestureRecognizer(tapGesture)
        itemView.tag = index

        return itemView
    }

    // MARK: - Actions
    @objc private func itemTapped(_ gesture: UITapGestureRecognizer) {
        guard let index = gesture.view?.tag else { return }
        selectedIndex = index
        onItemSelected?(index)
    }

    private func updateSelection() {
        for (index, itemView) in stackView.arrangedSubviews.enumerated() {
            guard let imageView = itemView.subviews.first as? UIImageView,
                  let label = itemView.subviews.last as? UILabel else { continue }

            if index == selectedIndex {
                imageView.image = items[index].selectedIcon
                label.textColor = .systemBlue
                pointerView.isHidden = false  // 포인터 표시
                pointerView.snp.remakeConstraints { make in
                    make.width.equalTo(16)
                    make.height.equalTo(16)
                    make.centerX.equalTo(stackView.arrangedSubviews[selectedIndex].snp.centerX)
                    make.bottom.equalTo(stackView.snp.top).offset(6)
                }

            } else {
                imageView.image = items[index].icon
                label.textColor = .gray
            }
        }
    }
}
