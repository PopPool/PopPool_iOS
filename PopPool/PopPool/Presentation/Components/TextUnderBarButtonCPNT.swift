//
//  TextUnderBarButtonCPNT.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/15/24.
//

import UIKit
import SnapKit

final class TextUnderBarButtonCPNT: UIButton {
    
    enum Size: CGFloat {
        case small = 13
        case medium = 15
        
        var height: CGFloat {
            switch self {
            case .small:
                return 20
            case .medium:
                return 23
            }
        }
    }
    
    // MARK: - Properties
    override var isEnabled: Bool {
        didSet {
            lineView.backgroundColor = isEnabled ? .g1000 : .g300
        }
    }
    
    private var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .g1000
        return view
    }()
    
    // MARK: - init
    init(size: Size, title: String) {
        super.init(frame: .zero)
        setUp(size: size, title: title)
        setUpConstraints(size: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension TextUnderBarButtonCPNT {
    func setUp(size: Size, title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.g1000, for: .normal)
        setTitleColor(.g300, for: .disabled)
        titleLabel?.font = .KorFont(style: .regular, size: size.rawValue)
    }
    
    func setUpConstraints(size: Size) {
        self.snp.makeConstraints { make in
            make.height.equalTo(size.height)
        }
        self.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
