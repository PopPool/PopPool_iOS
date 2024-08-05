//
//  InquiryVC.swift
//  PopPool
//
//  Created by Porori on 8/3/24.
//

import UIKit
import RxSwift
import SnapKit

class InquiryVC: BaseTableViewVC {
    
    let header = HeaderViewCPNT(title: "고객문의", style: .icon(nil))
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func bind() {
        // 셀 데이터 생성
        // 셀 바인딩
        // section별로 탭 시 늘어나는...
    }

    

}
