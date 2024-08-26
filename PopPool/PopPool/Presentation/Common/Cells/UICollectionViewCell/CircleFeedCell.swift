//
//  CircleFeedCell.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/15/24.
//

import UIKit

import SnapKit
import Kingfisher

final class CircleFeedCell: UICollectionViewCell {
    // MARK: - Components
    private let colorBackGroundView = AnimatedGradientView()
    private let imageBackGroundView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension CircleFeedCell {
    func setUp() {
        contentView.backgroundColor = .clear
        colorBackGroundView.contentMode = .scaleAspectFill
        colorBackGroundView.layer.cornerRadius = contentView.bounds.width / 2
        colorBackGroundView.clipsToBounds = true
        colorBackGroundView.backgroundColor = .g100
        
        imageBackGroundView.backgroundColor = .systemBackground
        imageBackGroundView.layer.cornerRadius = (contentView.bounds.width - (3 * 2)) / 2
        imageBackGroundView.clipsToBounds = true
        
        imageView.layer.cornerRadius = (contentView.bounds.width - (3 * 4)) / 2
        imageView.clipsToBounds = true
        titleLabel.font = .KorFont(style: .regular, size: 11)
        titleLabel.textColor = .g1000
        titleLabel.textAlignment = .center
    }
    
    func setUpConstraints() {
        contentView.addSubview(colorBackGroundView)
        colorBackGroundView.snp.makeConstraints { make in
            make.size.equalTo(contentView.bounds.width)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        colorBackGroundView.addSubview(imageBackGroundView)
        imageBackGroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(3)
        }
        
        imageBackGroundView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(3)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(17)
        }
    }
}

// MARK: - Cellable
extension CircleFeedCell: Cellable {

    struct Input {
        var title: String?
        var isActive: Bool
        var imageURL: URL?
    }
    
    struct Output {
        
    }
    
    func injectionWith(input: Input) {
        titleLabel.text = input.title
        if let url = input.imageURL {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url) { [weak self] result in
                switch result {
                case .success:
                    print("ImageLoad Success")
                case .failure:
                    self?.imageView.image = UIImage(named: "defaultLogo")
                }
            }
        }
        if input.isActive {
            colorBackGroundView.startAnimatingGradient()
        } else {
            colorBackGroundView.stopAnimatingGradient()
        }
    }
    
    func getOutput() -> Output {
        return Output()
    }
}

// MARK: - AnimatedGradientView
class AnimatedGradientView: UIView {
    
    private var gradientLayer: CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }
    
    private func setupGradient() {
        let startColor = UIColor.init(hexCode: "00E6BD")
        let endColor = UIColor.init(hexCode: "1570FC")

        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        layer.addSublayer(gradientLayer)
    }
    
    func startAnimatingGradient() {
        let newColors: [CGColor] = [
            UIColor.init(hexCode: "00E6BD").cgColor,
            UIColor.init(hexCode: "3BA5C3").cgColor,
            UIColor.init(hexCode: "1D88A5").cgColor,
            UIColor.init(hexCode: "6196C5").cgColor,
            UIColor.init(hexCode: "468CAE").cgColor,
            UIColor.init(hexCode: "1570FC").cgColor,
        ]
        
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = gradientLayer.colors
        animation.toValue = newColors
        animation.duration = 3.0
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        gradientLayer.add(animation, forKey: "animateGradient")
    }
    
    func stopAnimatingGradient() {
        gradientLayer.removeAllAnimations()
        gradientLayer.removeFromSuperlayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
