//
//  SignUpSelectAgeModalVC.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpSelectAgeModalVC: ModalViewController {
    
    // MARK: - Components
    private let contentsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        return view
    }()
    private let topSpacingView = UIView()
    private let titlelabel: UILabel = {
        let label = UILabel()
        label.text = "나이를 선택해주세요"
        label.font = .KorFont(style: .bold, size: 18)
        return label
    }()
    private let primaryButton = ButtonCPNT(type: .primary, title: "확인")
    private let secondaryButton = ButtonCPNT(type: .secondary, title: "취소")
    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            self.secondaryButton,
            self.primaryButton
        ])
        view.spacing = 12
        view.distribution = .fillEqually
        return view
    }()
    private let ageSelectPicker: PickerCPNT
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var selectIndex: Int
    let selectIndexRelayObserver: PublishSubject<Int> = .init()
    
    init(ageRange: ClosedRange<Int>, selectIndex: Int) {
        self.selectIndex = selectIndex
        let components = ageRange.map({ "\($0) 세" })
        self.ageSelectPicker = PickerCPNT(components: components)
        super.init()
        bind()
        self.ageSelectPicker.itemSelectObserver.onNext(selectIndex)
        ageSelectPicker.setIndex(index: selectIndex)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - LifeCycle
extension SignUpSelectAgeModalVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraints()
    }
}

// MARK: - SetUp
private extension SignUpSelectAgeModalVC {
    
    func setUpConstraints() {
        
        topSpacingView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide._24px)
        }
        titlelabel.snp.makeConstraints { make in
            make.height.equalTo(25)
        }
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        contentsStackView.addArrangedSubview(topSpacingView)
        contentsStackView.addArrangedSubview(titlelabel)
        contentsStackView.addArrangedSubview(ageSelectPicker)
        contentsStackView.addArrangedSubview(buttonStackView)
        setContent(content: contentsStackView)
    }
    
    func bind() {
        primaryButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.selectIndexRelayObserver.onNext(owner.selectIndex)
                owner.dismissBottomSheet()
            }
            .disposed(by: disposeBag)
        
        secondaryButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.dismissBottomSheet()
            }
            .disposed(by: disposeBag)
        
        ageSelectPicker.itemSelectObserver
            .withUnretained(self)
            .subscribe { (owner, index) in
                owner.selectIndex = index
            }
            .disposed(by: disposeBag)
    }
}
