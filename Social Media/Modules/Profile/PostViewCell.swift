import UIKit

class PostViewCell: UITableViewCell {
    
    // MARK: - Subviews

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
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, author: String, image: String, description: String, likes: Int, views: Int) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(author: author, image: image, description: description, likes: NSMutableAttributedString(string: "0"), views: NSMutableAttributedString(string: "0"))
        setupConstraints()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(author: "Unknown", image: "notFound", description: "Unknown", likes: NSMutableAttributedString(string: "0"), views: NSMutableAttributedString(string: "0"))
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews(author: "Unknown", image: "notFound", description: "Unknown", likes: NSMutableAttributedString(string: "0"), views: NSMutableAttributedString(string: "0"))
        setupConstraints()
    }
    
    // MARK: - Private

    private func addSubviews(author: String, image: String, description: String, likes: NSMutableAttributedString, views: NSMutableAttributedString) {
        contentView.addSubview(authorLabel)
        contentView.addSubview(imgView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likesLabel)
        contentView.addSubview(viewsLabel)
        
        authorLabel.text = author
        imgView.image = UIImage(named: image)
        descriptionLabel.text = description
        likesLabel.attributedText = likes
        viewsLabel.attributedText = views
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 16),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor),
            imgView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: likesLabel.topAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            likesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            likesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            likesLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            viewsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            viewsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            viewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            viewsLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
