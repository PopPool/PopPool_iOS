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
    
    // MARK: - Components
    
    let headerView = HeaderViewCPNT(title: "공지사항", style: .icon(nil))
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .bold, size: 18)
        label.textColor = .g1000
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 14)
        label.textColor = .g400
        return label
    }()
    
    let contentContainerView: UILabel = {
        let label = UILabel()
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
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraint()
    }
    
    // MARK: - Methods
    
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
        
        mainTitleLabel.text = "팝풀 시스템 점검 일정 안내"
        dateLabel.text = "2024.06.12"
        contentContainerView.text = 
    """
    하위의 텍스트는 모두 로렘 입숨입니다.
    
    모든 국민은 학문과 예술의 자유를 가진다. 모든 국민은 언론·출판의 자유와 집회·결사의 자유를 가진다. 헌법재판소는 법률에 저촉되지 아니하는 범위안에서 심판에 관한 절차, 내부규율과 사무처리에 관한 규칙을 제정할 수 있다. 국가는 농지에 관하여 경자유전의 원칙이 달성될 수 있도록 노력하여야 하며, 농지의 소작제도는 금지된다.
    
    국교는 인정되지 아니하며, 종교와 정치는 분리된다. 훈장등의 영전은 이를 받은 자에게만 효력이 있고, 어떠한 특권도 이에 따르지 아니한다. 모든 국민은 보건에 관하여 국가의 보호를 받는다. 모든 국민은 주거의 자유를 침해받지 아니한다. 주거에 대한 압수나 수색을 할 때에는 검사의 신청에 의하여 법관이 발부한 영장을 제시하여야 한다.
    
    국회의 정기회는 법률이 정하는 바에 의하여 매년 1회 집회되며, 국회의 임시회는 대통령 또는 국회재적의원 4분의 1 이상의 요구에 의하여 집회된다. 근로조건의 기준은 인간의 존엄성을 보장하도록 법률로 정한다. 국회의원의 선거구와 비례대표제 기타 선거에 관한 사항은 법률로 정한다. 대통령은 국민의 보통·평등·직접·비밀선거에 의하여 선출한다.
    
    제1항의 지시를 받은 당해 행정기관은 이에 응하여야 한다. 국무총리 또는 행정각부의 장은 소관사무에 관하여 법률이나 대통령령의 위임 또는 직권으로 총리령 또는 부령을 발할 수 있다. 제2항의 재판관중 3인은 국회에서 선출하는 자를, 3인은 대법원장이 지명하는 자를 임명한다. 국민경제의 발전을 위한 중요정책의 수립에 관하여 대통령의 자문에 응하기 위하여 국민경제자문회의를 둘 수 있다.
    """
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
