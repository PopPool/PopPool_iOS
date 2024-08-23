//
//  FavoritePopUpFilterModalVC.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/27/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FavoritePopUpFilterModalVC: ModalViewController {
    // MARK: - Components
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let titleView: ContentTitleCPNT = {
        let view = ContentTitleCPNT(title: "보기 옵션을 선택해주세요", type: .title_bs(buttonImage: UIImage(named: "xmark_signUp")))
        return view
    }()
    
    private let titleViewBottomSpacing = SpacingFactory.createSpace(size: 32)
    
    private let segmentControlTitleView: ListTitleViewCPNT = {
        let view = ListTitleViewCPNT(title: "화면설정", size: .medium)
        view.rightButton.isHidden = true
        return view
    }()
    
    private let segmentControlTopSpacing = SpacingFactory.createSpace(size: 8)
    
    private lazy var segmentControl: SegmentedControlCPNT = {
        let view = SegmentedControlCPNT(type: .base, segments: ["크게 보기", "모아서 보기"], selectedSegmentIndex: viewModel.viewType.value.rawValue)
        return view
    }()
    
    private let segmentControlBottomSpacing = SpacingFactory.createSpace(size: 36)
    
    private let saveButton = ButtonCPNT(type: .primary, title: "저장", disabledTitle: "저장")
    
    // MARK: - Properties
    private var viewModel: FavoritePopUpVM
    
    private let disposeBag = DisposeBag()
    
    // MARK: - init
    init(viewModel: FavoritePopUpVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCycle
extension FavoritePopUpFilterModalVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
        bind()
    }
}

// MARK: - SetUp
private extension FavoritePopUpFilterModalVC {
    func setUp() {
        saveButton.isEnabled = false
    }
    
    func setUpConstraints() {
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        contentStackView.addArrangedSubview(titleView)
        contentStackView.addArrangedSubview(titleViewBottomSpacing)
        contentStackView.addArrangedSubview(segmentControlTitleView)
        contentStackView.addArrangedSubview(segmentControlTopSpacing)
        contentStackView.addArrangedSubview(segmentControl)
        contentStackView.addArrangedSubview(segmentControlBottomSpacing)
        contentStackView.addArrangedSubview(saveButton)
        setContent(content: contentStackView)
    }
    
    func bind() {
        segmentControl.rx.selectedSegmentIndex
            .withUnretained(self)
            .subscribe { (owner, index) in
                owner.saveButton.isEnabled = owner.viewModel.viewType.value.rawValue != index
            }
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                let index = owner.segmentControl.selectedSegmentIndex
                owner.viewModel.viewType.accept(.init(rawValue: index) ?? .grid)
                owner.dismissBottomSheet()
            }
            .disposed(by: disposeBag)
    }
}
