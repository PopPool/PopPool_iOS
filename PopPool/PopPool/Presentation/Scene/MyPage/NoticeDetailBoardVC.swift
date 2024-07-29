//
//  NoticeDetailBoardVC.swift
//  PopPool
//
//  Created by Porori on 7/29/24.
//

import UIKit
import RxSwift
import SnapKit

class NoticeDetailBoardVC: UIViewController, UIScrollViewDelegate {
    
    let headerView = HeaderViewCPNT(title: "공지사항", style: .icon(nil))
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트 라벨"
        label.font = .KorFont(style: .regular, size: 18)
        label.textColor = .g1000
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2024.06.12"
        label.font = .KorFont(style: .regular, size: 14)
        label.textColor = .g400
        return label
    }()
    
    let contentContainerView: UILabel = {
        let label = UILabel()
        label.text = "테스팅"
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    lazy var titleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.addArrangedSubview(mainTitleLabel)
        stack.addArrangedSubview(dateLabel)
        return stack
    }()
    
    lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.addArrangedSubview(titleStackView)
        stack.addArrangedSubview(contentTopSpaceView)
        stack.addArrangedSubview(contentContainerView)
        stack.addArrangedSubview(contentBottomSpaceView)
        return stack
    }()
    
    let containerView = UIView()
    private let headerSpaceView = UIView()
    private let contentTopSpaceView = UIView()
    private let contentBottomSpaceView = UIView()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraint()
    }
    
    private func bind() {
        headerView.leftBarButton.rx.tap
            .withUnretained(self)
            .bind { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setUp() {
        scrollView.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setUpConstraint() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        containerView.addSubview(headerView)
        containerView.addSubview(headerSpaceView)
        
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        headerSpaceView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.height.equalTo(Constants.spaceGuide.small300)
            make.leading.trailing.equalToSuperview()
        }
        
        containerView.addSubview(contentStackView)
        
        contentTopSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.medium100)
        }
        
        contentBottomSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.large100)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(headerSpaceView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
