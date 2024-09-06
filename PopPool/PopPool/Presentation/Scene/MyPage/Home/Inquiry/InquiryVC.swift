//
//  InquiryVC.swift
//  PopPool
//
//  Created by Porori on 8/3/24.
//

import UIKit
import RxSwift
import SnapKit
import RxRelay

final class InquiryVC: BaseViewController {
    
    // MARK: - Component
    
    private let headerView = HeaderViewCPNT(title: "고객문의", style: .icon(nil))
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let firstSectionHeader = ListTitleViewCPNT(title: "자주 묻는 질문",
                                                       size: .large(subtitle: "", image: nil))
    private let secondSectionHeader = ListTitleViewCPNT(title: "직접 문의하기",
                                                        size: .large(subtitle: "", image: nil))
    
    private let pagenationButton = ButtonCPNT(type: .tertiary, title: "더보기")
    private let moveToMailView = ListMenuCPNT(titleText: "메일로 문의", style: .none)
    
    private lazy var listStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        return stack
    }()
    
    private let topSpaceView = UIView()
    private let paginationSpaceView = UIView()
    
    // MARK: - Properties
    
    private var dropLists: [ListDropDownCPNT] = []
    private let disposeBag = DisposeBag()
    private let viewModel: InquiryVM
    
    // MARK: - Initializer
    
    init(viewModel: InquiryVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraint()
        bind()
    }
    
    // MARK: - Method
    
    private func bind() {
        
        let input = InquiryVM.Input(
            
        )
        let output = viewModel.transform(input: input)
        
        // viewModel 데이터 바인딩
        output.data
            .subscribe(onNext: { dataArray in
                self.dropLists.removeAll()
                for data in dataArray {
                    let content = self.setUpList(data: data)
                    self.dropLists.append(content)
                    self.listStack.addArrangedSubview(content)
                }
            })
            .disposed(by: disposeBag)
        
        headerView.leftBarButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        moveToMailView.iconButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                // 사용자 이메일 주소로 변동 필요
                let test = "test@gmail.com"
                self?.openEmail(emailAccount: test)
            })
            .disposed(by: disposeBag)
        
        pagenationButton.rx.tap
            .subscribe(onNext: {
                print("화면 늘림")
            })
            .disposed(by: disposeBag)
    }
    
    /// iOS 시스템 이메일을 열기 위한 메서드입니다
    /// - Parameter emailAccount: 이메일을 보낼 String 타입 주소를 받습니다
    private func openEmail(emailAccount: String) {
        if let url = URL(string: "mailto:\(emailAccount)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    /// 콘텐츠 내용을 채우는 ListDropDownCPNT를 생성하는 메서드입니다
    /// - Parameter data: 컴포넌트 내부를 채울 데이터를 받습니다
    /// - Returns: ListDropDownCPNT를 생성합니다
    private func setUpList(data: [String]) -> ListDropDownCPNT {
        let dropList = ListDropDownCPNT()
        dropList.configure(title: data[0], content: data[1])
        return dropList
    }
    
    private func setUp() {
        navigationController?.navigationBar.isHidden = true
        firstSectionHeader.rightButton.isHidden = true
        secondSectionHeader.rightButton.isHidden = true
    }
    
    private func setUpConstraint() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(headerView)
        containerView.addSubview(topSpaceView)
        containerView.addSubview(firstSectionHeader)
        containerView.addSubview(listStack)
        containerView.addSubview(paginationSpaceView)
        containerView.addSubview(secondSectionHeader)
        containerView.addSubview(moveToMailView)
        containerView.addSubview(pagenationButton)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(scrollView.snp.height)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        topSpaceView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.height.equalTo(Constants.spaceGuide.small300)
            make.leading.trailing.equalToSuperview()
        }
        
        firstSectionHeader.snp.makeConstraints { make in
            make.top.equalTo(topSpaceView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        listStack.snp.makeConstraints { make in
            make.top.equalTo(firstSectionHeader.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        paginationSpaceView.snp.makeConstraints { make in
            make.top.equalTo(listStack.snp.bottom)
            make.height.equalTo(Constants.spaceGuide.small300)
            make.leading.trailing.equalToSuperview()
        }
        
        pagenationButton.snp.makeConstraints { make in
            make.top.equalTo(paginationSpaceView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(95)
        }
        
        secondSectionHeader.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        moveToMailView.snp.makeConstraints { make in
            make.top.equalTo(secondSectionHeader.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
