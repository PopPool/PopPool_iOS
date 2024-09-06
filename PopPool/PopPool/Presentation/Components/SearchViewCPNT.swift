import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewCPNT: UIView {
    // MARK: - UI 컴포넌트
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "팝업스토어명, 지역을 입력해보세요"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        return searchBar
    }()

    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.isHidden = true // 초기에는 숨김 상태
        return button
    }()

    let bellButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bell"), for: .normal)
        button.tintColor = .gray
        return button
    }()

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()

    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .gray
        button.isHidden = true
        return button
    }()

    // MARK: - 속성
    private let disposeBag = DisposeBag()
    private let viewModel: SearchViewModel

    // MARK: - 초기화
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:)가 구현되지 않았습니다")
    }

    // MARK: - 설정
    private func setupViews() {
        addSubview(backgroundView)
        backgroundView.addSubview(searchBar)
        backgroundView.addSubview(bellButton)
        backgroundView.addSubview(clearButton)
        addSubview(cancelButton)
    }

    private func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }

        searchBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }

        bellButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        }

        clearButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(bellButton.snp.leading).offset(-8)
            make.size.equalTo(20)
        }

        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(backgroundView)
            make.trailing.equalToSuperview().inset(16)
        }
    }

    private func setupBindings() {
        // 검색어 입력 바인딩
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                self?.handleSearchInput(text: text)
            })
            .disposed(by: disposeBag)

        // 취소 버튼 바인딩
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.clearSearch()
            })
            .disposed(by: disposeBag)

        // Clear 버튼 동작
        clearButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.searchBar.text = ""
                self?.handleSearchInput(text: "")
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Helper Methods
    private func handleSearchInput(text: String) {
        let isEmpty = text.isEmpty
        clearButton.isHidden = isEmpty
        bellButton.isHidden = !isEmpty
        cancelButton.isHidden = isEmpty
    }

    private func clearSearch() {
        searchBar.text = ""
        clearButton.isHidden = true
        bellButton.isHidden = false
        cancelButton.isHidden = true
    }
}
