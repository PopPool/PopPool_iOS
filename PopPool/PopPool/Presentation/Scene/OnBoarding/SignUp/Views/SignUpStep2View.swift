//
//  SignUpStep2View.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/29/24.
//

import UIKit
import SnapKit

final class SignUpStep2View: UIStackView {
    // MARK: - Components
    private let topSpacingView = UIView()
    let validationTextField = ValidationTextField(placeHolder: "별명을 적어주세요", limitTextCount: 10)
    private let bottomSpacingView = UIView()
    
    // MARK: - init
    init() {
        super.init(frame: .zero)
        setUp()
        setUpConstraints()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension SignUpStep2View {
    
    func setUp() {
        self.axis = .vertical
    }
    
    func setUpConstraints() {
        self.addArrangedSubview(topSpacingView)
        self.addArrangedSubview(validationTextField)
        self.addArrangedSubview(bottomSpacingView)
        
        topSpacingView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.medium400)
        }
    }
}
