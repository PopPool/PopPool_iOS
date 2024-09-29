//
//  EntirePopupTableViewCell.swift
//  PopPool
//
//  Created by Porori on 8/12/24.
//

import UIKit
import SnapKit
import RxSwift

final class HomeDetailPopUpCell: UICollectionViewCell {
    
    enum ButtonState {
        case tapped
        case untapped
        
        var imageState: UIImage? {
            switch self {
            case .tapped:
                return UIImage(named: "bookmark")
            case .untapped:
                return UIImage(named: "bookmarkUncheck")
            }
        }
    }
    
    // MARK: - Component
    
    lazy var contentContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    let popUpImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let bookMark: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "bookmarkUncheck"), for: .normal)
        return button
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blu500
        label.font = .KorFont(style: .bold, size: 13)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .bold, size: 14)
        label.numberOfLines = 2
        let text = "팝업 명칭"
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.4
        label.attributedText = NSMutableAttributedString(
            string: text,
            attributes: [.paragraphStyle: style]
        )
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .g400
        label.font = .KorFont(style: .regular, size: 11)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .g400
        label.font = .KorFont(style: .regular, size: 11)
        return label
    }()
    
    // MARK: - Properties
    
    private var currentState: ButtonState = .untapped
    let bookmarkSubject: PublishSubject<ButtonState> = .init()
    var disposeBag = DisposeBag()
    let service = PreSignedService()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraint()
        bind()
    }
    
    // MARK: - Initializer
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        bind()
    }
    
    // MARK: - Methods
    
    private func bind() {
        bookMark.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.currentState = owner.currentState == .untapped ? .tapped : .untapped
                owner.bookmarkSubject.onNext(owner.currentState)
            }
            .disposed(by: disposeBag)
        
        bookmarkSubject
            .subscribe(onNext: { state in
                self.updateView(state: state)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateView(state: ButtonState) {
        switch state {
        case .tapped:
            self.bookMark.setImage(state.imageState, for: .normal)
        case .untapped:
            self.bookMark.setImage(state.imageState, for: .normal)
        }
    }
    
    private func setUp() {
        
    }
    
    private func setUpConstraint() {
        addSubview(popUpImageView)
        popUpImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
        }
        addSubview(contentContainer)
        contentContainer.snp.makeConstraints { make in
            make.top.equalTo(popUpImageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        contentContainer.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(14)
            make.height.equalTo(15)
        }
        contentContainer.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(14)
            make.height.equalTo(15)
        }
        contentContainer.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(categoryLabel.snp.bottom).offset(4)
            make.height.equalTo(40)
        }
        contentContainer.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.height.equalTo(17)
        }
        contentContainer.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(locationLabel.snp.bottom)
            make.height.equalTo(15)
        }
        popUpImageView.addSubview(bookMark)
        bookMark.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(6)
            make.size.equalTo(24)
        }
    }
}

extension HomeDetailPopUpCell: Cellable {
    
    struct Input {
        var image: String?
        var category: String?
        var title: String?
        var location: String?
        var date: String?
    }
    
    struct Output {
        
    }
    
    func injectionWith(input: Input) {
        popUpImageView.kf.indicatorType = .activity
        popUpImageView.image = UIImage(named: "defaultLogo")
        
        if let path = input.image {
            service.tryDownload(filePaths: [path])
                .subscribe { [weak self] images in
                    guard let image = images.first else { return }
                    self?.popUpImageView.image = image
                } onFailure: { [weak self] error in
                    self?.popUpImageView.image = UIImage(named: "defaultLogo")
                    print("ImageDownLoad Fail")
                }
                .disposed(by: disposeBag)
        }
        
        titleLabel.text = input.title
        categoryLabel.text = input.category
        locationLabel.text = input.location
        dateLabel.text = input.date
    }
    
    func getOutput() -> Output {
        return Output()
    }
}
