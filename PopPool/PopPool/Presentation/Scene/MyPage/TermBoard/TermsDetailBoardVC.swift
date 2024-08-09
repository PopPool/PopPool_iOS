//
//  TermsDetailBoardVC.swift
//  PopPool
//
//  Created by Porori on 8/3/24.
//

import UIKit
import RxSwift
import SnapKit

final class TermsDetailBoardVC: ModalViewController {
    
    // MARK: - Components
    
    lazy var entireStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stack.axis = .vertical
        return stack
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .KorFont(style: .regular, size: 15)
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private let headerTopSpaceView = UIView()
    private let headerBottomSpaceView = UIView()
    let headerView: HeaderViewCPNT = HeaderViewCPNT(title: "이런 내용",
                                                    style: .icon(UIImage(named: "xmark_signUp")))
    
    // MARK: - Properties
    
    private let viewModel: TermsDetailBoardVM
    private let dataSubject = BehaviorSubject<[String]>(value: [])
    private let disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
        bind()
    }
    
    // MARK: - Initializer
    
    init(viewModel: TermsDetailBoardVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func bind() {
        let input = TermsDetailBoardVM.Input(
            dismissTapped: headerView.rightBarButton.rx.tap,
            data: dataSubject.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.title
            .bind(to: headerView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.content
            .bind(to: textLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.dismissFromScreen
            .subscribe(onNext: {
                print("버튼 눌림")
                self.dismissBottomSheet()
            })
            .disposed(by: disposeBag)
    }
    
    func configure(with data: [String]) {
        dataSubject.onNext(data)
    }
    
    private func setUp() {
        headerView.leftBarButton.isHidden = true
        headerView.titleLabel.font = .KorFont(style: .bold, size: 15)
    }
    
    private func setUpConstraints() {
        headerTopSpaceView.snp.makeConstraints { make in
            make.height.equalTo(14)
        }
        
        headerBottomSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.medium100)
        }
        
        contentStackView.addArrangedSubview(headerBottomSpaceView)
        contentStackView.addArrangedSubview(textLabel)
        entireStackView.addArrangedSubview(headerTopSpaceView)
        entireStackView.addArrangedSubview(headerView)
        entireStackView.addArrangedSubview(contentStackView)
        setContent(content: entireStackView)
    }
}
