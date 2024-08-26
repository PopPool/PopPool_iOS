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
    var selectedIndex: Int = 0 {
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
            make.edges.equalToSuperview()
        }
        
        for (index, item) in items.enumerated() {
            let itemView = createItemView(for: item, at: index)
            stackView.addArrangedSubview(itemView)
        }
        
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
    }
    
    private func createItemView(for item: TabBarItemType, at index: Int) -> UIView {
        let itemView = UIView()
        let imageView = UIImageView(image: item.icon)
        let label = UILabel()
        
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
        
        label.text = item.title
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        
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
            } else {
                imageView.image = items[index].icon
                label.textColor = .gray
            }
        }
    }
}
