import UIKit
import SnapKit

class SearchResultsView: UIView {

    private let searchQueryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.text = ""
        return label
    }()

    private let searchResultCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .left
        label.text =
        return label
    }()

    private let resultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        let width = (UIScreen.main.bounds.width - 48) / 2
        layout.itemSize = CGSize(width: width, height: width * 1.5)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        cv.backgroundColor = .white
        return cv
    }()

    // 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }a

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // UI 설정
    private func setupUI() {
        addSubview(searchQueryLabel)
        addSubview(searchResultCountLabel)
        addSubview(resultsCollectionView)

        // 레이아웃 설정
        searchQueryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        searchResultCountLabel.snp.makeConstraints { make in
            make.top.equalTo(searchQueryLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }

        resultsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchResultCountLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    // 라벨 업데이트 함수
    func updateLabels(query: String, resultCount: Int) {
        searchQueryLabel.text = "\(query)이/가 포함된 팝업"
        searchResultCountLabel.text = "총 \(resultCount)개의 팝업을 찾았어요."
    }

    // 컬렉션 뷰를 외부에서 접근할 수 있도록 설정
    func getCollectionView() -> UICollectionView {
        return resultsCollectionView
    }
}
