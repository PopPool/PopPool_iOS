import UIKit
import SnapKit

class UserBlockAlertViewController: UIViewController {

    var onConfirmBlock: (() -> Void)?
    var nickname: String?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "차단하시면 앞으로 이 유저가 남긴\n코멘트와 반응을 볼 수 없어요."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()

    private let blockButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("차단하기", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()

        titleLabel.text = "\(nickname ?? "유저명")님을 차단할까요?"
        cancelButton.addTarget(self, action: #selector(dismissSheet), for: .touchUpInside)
        blockButton.addTarget(self, action: #selector(blockUser), for: .touchUpInside)
    }

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(cancelButton)
        view.addSubview(blockButton)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }

        cancelButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(blockButton.snp.leading).offset(-10)
            make.bottom.equalTo(view.snp.bottom).offset(-32)
            make.height.equalTo(52)
            make.width.equalTo(blockButton.snp.width)
        }

        blockButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.bottom.equalTo(view.snp.bottom).offset(-32)
            make.height.equalTo(52)
            make.width.equalTo(cancelButton.snp.width)
        }
    }

    @objc private func blockUser() {
        dismiss(animated: true) {
            self.onConfirmBlock?()
        }
    }

    @objc private func dismissSheet() {
        dismiss(animated: true, completion: nil)
    }
}
