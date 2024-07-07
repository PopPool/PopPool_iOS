//
//  MyPageMainProfileView.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/8/24.
//

import UIKit
import SnapKit

final class MyPageMainProfileView: UIView {
    
    // MARK: - Components
    private var containerView: UIView = UIView()
    private var imageView: UIImageView = UIImageView()
    private let testLabel = UILabel()
    private let bottomHoleView: UIView = UIView()
    private let bottomHoleBlockView: UIView = UIView()
    
    // MARK: - Properties
    private var containerViewHeight: Constraint?
    private var imageViewHeight: Constraint?
    private var imageViewBottom: Constraint?
    
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraints()
        setUpMask()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - SetUp
private extension MyPageMainProfileView {
    
    func setUp() {
        imageView.image = UIImage(systemName: "folder")
        imageView.backgroundColor = .yellow
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        bottomHoleView.backgroundColor = .systemBackground
        bottomHoleBlockView.backgroundColor = .systemBackground
    }
    
    func setUpConstraints() {
        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            containerViewHeight = make.height.equalToSuperview().constraint
        }
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.equalTo(containerView)
            imageViewBottom = make.bottom.equalTo(containerView).constraint
            imageViewHeight = make.height.equalTo(containerView).constraint
        }
        containerView.addSubview(bottomHoleView)
        bottomHoleView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(49)
        }
        containerView.addSubview(bottomHoleBlockView)
        bottomHoleBlockView.snp.makeConstraints { make in
            make.edges.equalTo(bottomHoleView)
        }
        containerView.addSubview(testLabel)
        testLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        testLabel.text = "TestTest"
    }
    
    func setUpMask() {
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: bounds.midX, y: bottomHoleView.bounds.midY),
                    radius: 12,
                    startAngle: 0.0,
                    endAngle: 2.0 * .pi,
                    clockwise: false)
        let size: CGSize = .init(width: frame.width, height: frame.height)
        path.addRect(CGRect(origin: .zero, size: size))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        bottomHoleView.layer.mask = maskLayer
    }
}

// MARK: - Methods
extension MyPageMainProfileView {
    func scrollViewDidScroll(scrollView: UIScrollView, alpha: Double) {
        containerViewHeight?.update(offset: scrollView.contentInset.top)
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom?.update(offset: offsetY >= 0 ? 0 : -offsetY / 2)
        imageViewHeight?.update(offset: max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top))
        bottomHoleBlockView.alpha = alpha
    }
}
