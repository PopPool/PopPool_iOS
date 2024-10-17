import UIKit
import SnapKit

protocol UserMoreInfoDelegate: AnyObject {
    func didSelectBlockUser()
}


class UserMoreInfoViewController: UIViewController {
    weak var delegate: UserMoreInfoDelegate?
    var onSelectViewAllComments: ((String) -> Void)?
    var nickname: String?
    var userId: String?
    private let userCommentsViewModel: UserCommentsViewModel



    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()

    private let optionsTableView = UITableView()

    init(nickname: String?, userId: String?, userCommentsViewModel: UserCommentsViewModel) {
            self.nickname = nickname
        self.userId = userId
            self.userCommentsViewModel = userCommentsViewModel
            super.init(nibName: nil, bundle: nil)
        }
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupTableView()
        titleLabel.text = "\(nickname ?? "유저")님에 대해 더 알아보기"
        closeButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(optionsTableView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(closeButton.snp.left).offset(-20)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }

        optionsTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func setupTableView() {
        optionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "optionCell")
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
    }

    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}

extension UserMoreInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath)
        cell.textLabel?.text = indexPath.row == 0 ? "코멘트를 작성한 팝업 모두보기" : "이 유저 차단하기"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // "코멘트를 작성한 팝업 모두보기" 선택 시
            if let userId = self.userId {
                dismiss(animated: true) { [weak self] in
                    self?.onSelectViewAllComments?(userId)
                }
            }
        case 1:
            // "이 유저 차단하기" 선택 시
            delegate?.didSelectBlockUser()
            dismiss(animated: true, completion: nil)
        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }


}
