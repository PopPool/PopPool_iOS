import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SortOrderBottomSheetViewController: UIViewController {
    private var selectedOrder: String?
    private let disposeBag = DisposeBag()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "노출 순서를 선택해주세요"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()

    private let exposureLabel: UILabel = {
        let label = UILabel()
        label.text = "노출조건"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let popupOrderLabel: UILabel = {
        let label = UILabel()
        label.text = "팝업순서"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let exposureSegmentedControl: SegmentedControlCPNT = {
        let control = SegmentedControlCPNT(type: .radio, segments: ["오픈", "종료"], selectedSegmentIndex: 0)
        return control
    }()

    private let orderSegmentedControl: SegmentedControlCPNT = {
        let control = SegmentedControlCPNT(type: .radio, segments: ["신규순", "인기순"], selectedSegmentIndex: 1)
        return control
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 8
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 16

        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(exposureLabel)
        view.addSubview(exposureSegmentedControl)
        view.addSubview(popupOrderLabel)
        view.addSubview(orderSegmentedControl)
        view.addSubview(saveButton)

        // 레이아웃 설정
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }

        exposureLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }

        exposureSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(exposureLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }

        popupOrderLabel.snp.makeConstraints { make in
            make.top.equalTo(exposureSegmentedControl.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }

        orderSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(popupOrderLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(orderSegmentedControl.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50) // 저장 버튼 너비와 높이 확장
        }
    }

    private func bindUI() {
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        exposureSegmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] index in
                self?.selectedOrder = index == 0 ? "오픈" : "종료"
                print("노출순서: \(self?.selectedOrder ?? "")")
            })
            .disposed(by: disposeBag)

        orderSegmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { index in
                let order = index == 0 ? "신규순" : "인기순"
                print("팝업 순서: \(order)")
            })
            .disposed(by: disposeBag)

        saveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                print("저장됨: \(self?.selectedOrder ?? "")")
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
