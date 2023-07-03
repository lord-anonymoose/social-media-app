import UIKit

class PostViewCell: UITableViewCell {
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imgView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, author: String, image: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(author: author, image: image)
        setupConstraints()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(author: "Unknown", image: "notFound")
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews(author: "Unknown", image: "notFound")
        setupConstraints()
    }
    
    private func addSubviews(author: String, image: String) {
        contentView.addSubview(authorLabel)
        contentView.addSubview(imgView)
        
        authorLabel.text = author
        imgView.image = UIImage(named: image)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            authorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 10),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor)
        ])
    }
}
