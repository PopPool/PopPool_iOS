import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewCPNT: UIView {
    // MARK: - UI Components
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "팝업스토어명을 입력해보세요"
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = .clear
        searchBar.layer.cornerRadius = 4
        searchBar.clipsToBounds = true
        searchBar.isTranslucent = true
        searchBar.isUserInteractionEnabled = false
        return searchBar
    }()

    // Blur effect view
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.layer.cornerRadius = 10 // Adjusted to match searchBar's corner radius
        blurView.layer.masksToBounds = true
        return blurView
    }()

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let viewModel: SearchViewModel

    // MARK: - Initialization
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupViews() {
        addSubview(blurEffectView)
        addSubview(searchBar)
    }

    private func setupConstraints() {
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalTo(searchBar)
        }

        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }

    private func setupBindings() {

    }

    // MARK: - Helper Methods
    private func handleSearchInput(text: String) {
        let isEmpty = text.isEmpty
//        cancelButton.isHidden = isEmpty
    }

    private func clearSearch() {
        searchBar.text = ""
//        cancelButton.isHidden = true
    }
}
