import UIKit

class AllCommentsViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.reuseIdentifier)
        return tableView
    }()

    var userId: String
    var comments: [Comment] = []

    init(comments: [Comment], userId: String) {
          self.comments = comments
          self.userId = userId
          super.init(nibName: nil, bundle: nil)
      }

      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }

    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        updateCommentCount()

        // 네비게이션 바 백 버튼 커스텀
        let backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBackButton))
        backBarButtonItem.tintColor = .black
        navigationItem.leftBarButtonItem = backBarButtonItem

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(commentCountLabel)
        view.addSubview(tableView)

        commentCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)

            tableView.snp.makeConstraints { make in
                make.top.equalTo(commentCountLabel.snp.bottom).offset(36)
                make.leading.trailing.bottom.equalToSuperview()
            }
        }
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func updateCommentCount() {
        commentCountLabel.text = "총 \(comments.count)건"
    }

    // 네비게이션 백 버튼 액션
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AllCommentsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.reuseIdentifier, for: indexPath) as! CommentCell
        let comment = comments[indexPath.row]
        cell.configure(with: comment, userId: self.userId)
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
