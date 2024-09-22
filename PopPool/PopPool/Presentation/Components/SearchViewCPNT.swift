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
        searchBar.backgroundColor = .clear
        searchBar.barTintColor = .clear
        searchBar.isTranslucent = true
        searchBar.isUserInteractionEnabled = false

        return searchBar
    }()

    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.isHidden = true
        return button
    }()

    let bellButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bell"), for: .normal)
        button.tintColor = .gray
        return button
    }()

    // Blur effect view
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.layer.cornerRadius = 10 // Adjusted to match searchBar's corner radius
        blurView.layer.masksToBounds = true
        return blurView
    }()

//    let clearButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
//        button.tintColor = .gray
//        button.isHidden = true
//        return button
//    }()

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
//        addSubview(clearButton)
        addSubview(bellButton)
        addSubview(cancelButton)
    }

    private func setupConstraints() {
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalTo(searchBar)
        }

        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(bellButton.snp.leading).offset(-16)
            make.height.equalTo(36)
        }

        bellButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }

//        clearButton.snp.makeConstraints { make in
//            make.centerY.equalTo(searchBar)
//            make.trailing.equalTo(searchBar).offset(-8)
//            make.size.equalTo(20)
//        }

        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar)
            make.trailing.equalToSuperview().inset(16)
        }
    }

    private func setupBindings() {
//        searchBar.rx.text.orEmpty
//            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .subscribe(onNext: { [weak self] text in
//                self?.handleSearchInput(text: text)
//            })
//            .disposed(by: disposeBag)
//
//        cancelButton.rx.tap
//            .subscribe(onNext: { [weak self] in
//                self?.clearSearch()
//            })
//            .disposed(by: disposeBag)

//        clearButton.rx.tap
//            .subscribe(onNext: { [weak self] in
//                self?.searchBar.text = ""
//                self?.handleSearchInput(text: "")
//            })
//            .disposed(by: disposeBag)
    }

    // MARK: - Helper Methods
    private func handleSearchInput(text: String) {
        let isEmpty = text.isEmpty
//        clearButton.isHidden = isEmpty
        bellButton.isHidden = !isEmpty
        cancelButton.isHidden = isEmpty
    }

    private func clearSearch() {
        searchBar.text = ""
//        clearButton.isHidden = true
        bellButton.isHidden = false
        cancelButton.isHidden = true
    }
}
