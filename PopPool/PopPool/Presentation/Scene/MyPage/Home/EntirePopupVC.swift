//
//  EntirePopupVC.swift
//  PopPool
//
//  Created by Porori on 8/11/24.
//

import UIKit
import RxSwift
import SnapKit

final class EntirePopupVC: UIViewController {
    
    private let header: HeaderViewCPNT = HeaderViewCPNT(title: "큐레이션 팝업 전체보기",
                                                        style: .icon(nil))
    private let entirePopUpTableView = UITableView()
    
    private let viewModel: EntirePopupVM
    let disposeBag = DisposeBag()
    
    init(viewModel: EntirePopupVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraint()
        bind()
    }
    
    private func bind() {
        header.leftBarButton.rx.tap
            .subscribe(onNext: {
                print("버튼이 눌렸습니다.")
            })
            .disposed(by: disposeBag)
    }
    
    private func setUp() {
        view.backgroundColor = .systemBackground
        header.rightBarButton.isHidden = true
        navigationController?.navigationBar.isHidden = true
        entirePopUpTableView.backgroundColor = .green
    }
    
    private func setUpConstraint() {
        view.addSubview(header)
        view.addSubview(entirePopUpTableView)
        
        header.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        entirePopUpTableView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
