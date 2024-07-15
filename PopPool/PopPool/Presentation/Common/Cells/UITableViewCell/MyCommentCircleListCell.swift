//
//  MyCommentCircleListCell.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

// TODO: - 수정필요
struct MyCommentCircleListCellSection: TableViewSectionable {
    
    struct Input {
        var sectionTitle: String?
    }
    
    struct Output {
        var didTapRightButton: ControlEvent<Void>
    }
    
    typealias CellType = MyCommentCircleListCell
    
    var sectionInput: Input
    
    var sectionCellInputList: [MyCommentCircleListCell.Input]
    
    lazy var titleView: ListTitleViewCPNT = {
        let view = ListTitleViewCPNT(title: sectionInput.sectionTitle, size: .medium)
        view.titleLabel.font = .KorFont(style: .bold, size: 16)
        return view
    }()
    
    
    mutating func makeHeaderView() -> UIView? {
        let containerView = UIView()
        containerView.backgroundColor = .systemBackground
        containerView.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constants.spaceGuide.small100)
        }
        return containerView
    }
    
    mutating func sectionOutput() -> Output {
        return Output(didTapRightButton: titleView.rightButton.rx.tap)
    }
    
    func makeFooterView() -> UIView? {
        return nil
    }
}

// TODO: - 수정 필요
final class MyCommentCircleListCell: UITableViewCell {
    
    // MARK: - Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 15)
        return label
    }()
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension MyCommentCircleListCell {
    func setUp() {
        
    }
    
    func setUpConstraints() {
        contentView.backgroundColor = .red
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(100)
        }
    }
}

// MARK: - Methods
extension MyCommentCircleListCell: Cellable {

    
    struct Output {
        
    }
    
    
    struct Input {

    }
    
    func injectionWith(input: Input) {
    }
    
    func getOutput() -> Output {
        return Output()
    }
}
