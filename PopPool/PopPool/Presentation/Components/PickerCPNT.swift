//
//  PickerCPNT.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/3/24.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa

final class PickerCPNT: UIView {
    
    // MARK: - Components
    private let components: [String]
    private let pickerView = UIPickerView()
    private var selectView: UIView = {
        let view = UIView()
        view.backgroundColor = .g50
        view.layer.cornerRadius = 4
        return view
    }()
    private let disposeBag = DisposeBag()
    /// 항목 선택 이벤트를 전달하는 PublishSubject입니다.
    let itemSelectObserver: PublishSubject<Int> = .init()
    
    // MARK: - init
     /// PickerCPNT init
     /// - Parameter components: UIPickerView에 표시할 문자열 배열입니다.
    init(components: [String]) {
        self.components = components
        super.init(frame: .zero)
        setUp()
        setUpConstraints()
        bind()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
extension PickerCPNT {
    /// 초기 설정
    func setUp() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func setUpConstraints() {
        self.addSubview(selectView)
        self.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        selectView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
            make.center.equalToSuperview()
        }
    }
    
    func bind() {
        pickerView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { (owner, selectData) in
                owner.itemSelectObserver.onNext(selectData.row)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Methods
extension PickerCPNT {
    
    /// 지정된 인덱스로 UIPickerView를 설정
    /// - Parameter index: 설정할 인덱스 값
    func setIndex(index: Int) {
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }
}

// MARK: - Delegate
extension PickerCPNT: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return components.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = components[row]
        label.textAlignment = .center
        label.font = .KorFont(style: .medium, size: 16)
        DispatchQueue.main.async {
            if let label = pickerView.view(forRow: row, forComponent: component) as? UILabel {
                label.font = .KorFont(style: .bold, size: 18)
            }
        }
        pickerView.subviews[1].isHidden = true
        return label
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 48
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
    }
}
