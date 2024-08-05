//
//  HeaderViewCPNT.swift
//  PopPool
//
//  Created by Porori on 6/26/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HeaderViewCPNT: UIStackView {

    enum Style {
        case icon(UIImage?)
        case text(String)
        case search
    }

    // MARK: - Components
    let leftBarButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .g1000
        return button
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 15)
        label.textColor = .g1000
        label.textAlignment = .center
        return label
    }()
    let rightBarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.g1000, for: .normal)
        return button
    }()
    private let leftTrailingView = UIView()
    private let centerTrailingView = UIView()
    private let rightTrailingView = UIView()

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "팝업스토어명, 지역을 입력해보세요"
        searchBar.isHidden = true
        return searchBar
    }()

    // MARK: - Initializer
    init(title: String = "", style: Style) {
        super.init(frame: .zero)
        setupLayout()
        setupViews(title: title, style: style)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
extension HeaderViewCPNT {

    /// 기본 헤더 뷰의 화면 구성
    private func setupLayout() {
        self.axis = .vertical
        self.spacing = 8
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 16)

        let navigationBar = UIStackView()
        navigationBar.axis = .horizontal
        navigationBar.distribution = .equalSpacing

        leftTrailingView.addSubview(leftBarButton)
        centerTrailingView.addSubview(titleLabel)
        rightTrailingView.addSubview(rightBarButton)

        leftBarButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        rightBarButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        navigationBar.addArrangedSubview(leftTrailingView)
        navigationBar.addArrangedSubview(centerTrailingView)
        navigationBar.addArrangedSubview(rightTrailingView)

        self.addArrangedSubview(navigationBar)
        self.addArrangedSubview(searchBar)
    }

    /// 헤더 뷰의 컴포넌트 설정
    /// - Parameters:
    ///   - title: 바꿀 제목명을 받습니다
    ///   - style: rightBarButton의 아이콘 타입 (ie. text / icon / search)
    private func setupViews(title: String, style: Style) {
        leftBarButton.setImage(UIImage(named: "icoLine"), for: .normal)
        titleLabel.text = title

        switch style {
        case .icon(let image):
            if let image = image {
                rightBarButton.setImage(image.withTintColor(.g1000, renderingMode: .alwaysOriginal), for: .normal)
            }
            searchBar.isHidden = true
        case .text(let buttonText):
            rightBarButton.setTitle(buttonText, for: .normal)
            rightBarButton.titleLabel?.font = .KorFont(style: .regular, size: 14)
            searchBar.isHidden = true
        case .search:
            rightBarButton.isHidden = true
            searchBar.isHidden = false
        }
    }
}

// MARK: - Reactive Extension
extension Reactive where Base: HeaderViewCPNT {
    var leftButtonTap: ControlEvent<Void> {
        return base.leftBarButton.rx.tap
    }

    var rightButtonTap: ControlEvent<Void> {
        return base.rightBarButton.rx.tap
    }

    var searchText: ControlProperty<String?> {
        return base.searchBar.rx.text
    }
}
