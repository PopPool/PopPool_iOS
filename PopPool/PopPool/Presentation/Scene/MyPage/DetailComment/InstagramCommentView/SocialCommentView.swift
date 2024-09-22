//
//  SocialFinalView.swift
//  PopPool
//
//  Created by Porori on 9/18/24.
//

import UIKit
import SnapKit
import RxSwift

final class SocialCommentView: UIStackView {
    
    let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4
        imageView.image = UIImage(systemName: "lasso")
        return imageView
    }()
    
    let listTitle = ListTitleViewCPNT(
        title: "코멘트 작성",
        size: .large(
            subtitle: "방문했던 $팝업스토어명$에 대한 감상평을 작성해주세요",
            image: nil))
    
    let dynamicTF = DynamicTextViewCPNT(
        placeholder: "최소 10자 이상 입력해주세요",
        textLimit: 500)
    
    let topSpaceView = UIView()
    let middleSpaceView = UIView()
    
    init() {
        super.init(frame: .zero)
        setUp()
        setUpConstraint()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
//        self.backgroundColor = .blue
//        topSpaceView.backgroundColor = .orange
//        middleSpaceView.backgroundColor = .red
        self.axis = .vertical
        
        self.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.isLayoutMarginsRelativeArrangement = true
    }
    
    private func setUpConstraint() {
        self.addArrangedSubview(topSpaceView)
        self.addArrangedSubview(contentImageView)
        self.addArrangedSubview(middleSpaceView)
        self.addArrangedSubview(listTitle)
        self.addArrangedSubview(dynamicTF)
        
        topSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small300)
        }
        
        middleSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small300)
        }
        
        dynamicTF.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(220)
        }
    }
}
