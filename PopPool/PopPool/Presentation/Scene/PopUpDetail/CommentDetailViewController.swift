import UIKit
import SnapKit
import Kingfisher

class CommentDetailViewController: UIViewController {

    var comment: Comment?

    // UI 요소들
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
    }()

    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0 // 전체 텍스트 표시를 위해 0 설정
        return label
    }()

    private let commentImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CommentGalleryCell.self, forCellWithReuseIdentifier: "CommentGalleryCell")
        return collectionView
    }()

    private var commentImageCollectionHeightConstraint: Constraint?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindCommentData()
        setupSheetPresentation() // 바텀 시트 설정 추가
    }

    // MARK: - 바텀 시트 설정
    private func setupSheetPresentation() {
        if let sheet = self.sheetPresentationController {
            // 바텀 시트로 표시할 크기 옵션 설정 (medium, large 두 단계)
            sheet.detents = [.medium(), .large()]
            // 리사이즈 인디케이터(Grabber) 표시
            sheet.prefersGrabberVisible = true
        }
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(profileImageView)
        view.addSubview(nicknameLabel)
        view.addSubview(dateLabel)
        view.addSubview(commentImageCollectionView)
        view.addSubview(contentLabel)

        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }

        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.leading.equalTo(nicknameLabel)
        }

        commentImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            commentImageCollectionHeightConstraint = make.height.equalTo(80).constraint // 높이 제약을 변수에 저장
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(commentImageCollectionView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        commentImageCollectionView.delegate = self
        commentImageCollectionView.dataSource = self
    }

    // MARK: - Bind Data
    private func bindCommentData() {
        guard let comment = comment else { return }

        // 닉네임
        nicknameLabel.text = comment.nickname

        // 내용
        contentLabel.text = comment.content

        // 프로필 이미지
        if let profileUrl = URL(string: comment.profileImageUrl ?? "") {
            profileImageView.kf.setImage(with: profileUrl)
        } else {
            profileImageView.image = UIImage(named: "defaultProfileImage")
        }

        // 이미지가 없는 경우 이미지 컬렉션 뷰 숨김 처리 및 높이를 0으로 설정
        if let commentImages = comment.commentImageList, !commentImages.isEmpty {
            commentImageCollectionView.isHidden = false
            commentImageCollectionHeightConstraint?.update(offset: 80)
            commentImageCollectionView.reloadData()
        } else {
            commentImageCollectionView.isHidden = true
            commentImageCollectionHeightConstraint?.update(offset: 0)
        }
    }
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CommentDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comment?.commentImageList?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentGalleryCell", for: indexPath) as! CommentGalleryCell
        if let imageUrl = comment?.commentImageList?[indexPath.item].imageUrl {
            cell.configure(with: imageUrl)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CommentDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
