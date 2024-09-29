import UIKit
import SnapKit

class SearchSuggestionCell: UITableViewCell {

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(addressLabel)

        nameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
        }

        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }

    func configure(with suggestion: SearchPopUpStore, query: String) {
        let attributedName = highlightText(suggestion.name, matching: query)
        nameLabel.attributedText = attributedName
        addressLabel.text = suggestion.address
    }

    private func highlightText(_ text: String, matching query: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text.lowercased() as NSString).range(of: query.lowercased())
        if range.location != NSNotFound {
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
        }
        return attributedString
    }
}
