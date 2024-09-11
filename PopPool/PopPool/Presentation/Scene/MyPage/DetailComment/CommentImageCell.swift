//
//  CommentImageCell.swift
//  PopPool
//
//  Created by Porori on 9/8/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import SnapKit

protocol CommentImageDelegate: AnyObject {
    func didRequestImage()
    func didRequestRemoval(at index: Int)
}

final class CommentImageCell: UICollectionViewCell {
    
    enum State {
        case unTapped
        case tapped
        
        var borderColor: UIColor? {
            switch self {
            case .tapped:
                return .blu400
            case .unTapped:
                return .g100
            }
        }
    }
    
    // MARK: - Components
    
    private let imageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "lasso"), for: .normal)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "name=canel")
        button.setImage(image, for: .normal)
        return button
    }()
    
    //MARK: - Properties
    private var isTapped: State = .unTapped
    private var disposeBag = DisposeBag()
    private var imageData: Data?
    var delegate: CommentImageDelegate?
    
    var tapSubject: BehaviorSubject<State> = .init(value: .unTapped)
    var index: Int?
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraint()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        imageButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                print("이미지")
                owner.isTapped = (owner.isTapped == .unTapped ? .tapped : .unTapped)
                owner.tapSubject.onNext(owner.isTapped)
                
                if owner.imageData == nil {
                    owner.delegate?.didRequestImage()
                }
            })
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                guard let index = owner.index else { return }
                print("인덱스 값", index)
                owner.delegate?.didRequestRemoval(at: index)
            })
            .disposed(by: disposeBag)
        
        tapSubject
            .withUnretained(self)
            .subscribe(onNext: { (owner, state) in
                owner.configureState(state: state)
            })
            .disposed(by: disposeBag)
    }
    
    public func configure(with imageData: Data?) {
        self.imageData = imageData
        if let image = imageData, let image = UIImage(data: image) {
            self.imageButton.setImage(image, for: .normal)
            imageButton.contentMode = .scaleToFill
        } else {
            let image = UIImage(systemName: "photo")
            imageButton.setImage(image, for: .normal)
            imageButton.contentMode = .scaleToFill
        }
    }
    
    private func configureState(state: State) {
        self.imageButton.layer.borderColor = state.borderColor?.cgColor
    }
    
    private func setUp() {
        imageButton.layer.cornerRadius = 4
        imageButton.layer.borderWidth = 1.2
        imageButton.layer.borderColor = UIColor.blu500.cgColor
    }
    
    private func setUpConstraint() {
        contentView.addSubview(imageButton)
        imageButton.addSubview(cancelButton)
        
        imageButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.top.trailing.equalToSuperview().inset(6)
        }
    }
}
