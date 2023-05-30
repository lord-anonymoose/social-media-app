//
//  FeedViewController.swift
//  iOS UI HW2
//
//  Created by Philipp Lazarev on 18.05.2023.
//

import UIKit

class FeedViewController: UIViewController, UIScrollViewDelegate {
    
    private lazy var labels: [UILabel] = {
        var labels = [UILabel]()
        for i in 0..<posts.count {
            let label = makePost(with: i)
            labels.append(label)
        }
        return labels
    }()
    
    private lazy var post: UIButton = {
        var post = UIButton(type: .system)
        post.translatesAutoresizingMaskIntoConstraints = false
        post.setTitleColor(.label, for: .normal)
        post.sizeToFit()
        post.titleLabel?.numberOfLines = 0
        post.titleLabel?.lineBreakMode = .byWordWrapping
        
        // Setting post title
        post.tag = 0
        let title = "\(posts[post.tag].user.name)\n\(posts[post.tag].text)"
        let attributedTitle = NSMutableAttributedString(string: title)
        let range = (title as NSString).range(of: posts[post.tag].user.name)
        attributedTitle.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: range)
        post.setAttributedTitle(attributedTitle, for: .normal)
        
        // Adding target function
        post.addTarget(self, action: #selector(tapFunction), for: .touchUpInside)
        return post
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newSetupUI()
    }
    
    func newSetupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        view.addSubview(post)
        NSLayoutConstraint.activate([
            post.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            post.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            post.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    // Following function is legacy code
    func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        for label in labels {
            view.addSubview(label)
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            ])
        }
        
        if labels.count > 0 {
            NSLayoutConstraint.activate([
                labels[0].topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
            ])
        }
        
        if labels.count > 1 {
            for i in 1..<labels.count {
                NSLayoutConstraint.activate([
                    labels[i].topAnchor.constraint(equalTo: labels[i-1].bottomAnchor, constant: 20)
                ])
            }
        }
    }
    
    // Following function is legacy code
    private func makePost(with arrayNum: Int) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let text = "\(posts[arrayNum].user.name)\n\(posts[arrayNum].text)"
        let attributedText = NSMutableAttributedString(string: text)
        
        if let range = text.range(of: "\n") {
            attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(location: 0, length: range.lowerBound.utf16Offset(in: text)))
        }
        
        label.attributedText = attributedText
        label.sizeToFit()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.tag = arrayNum
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(FeedViewController.tapFunction))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        
        return label
    }
         
    @IBAction func tapFunction(sender: UIButton) {
        // Legacy code
        /*
        guard let label = sender.view as? UILabel else {
            let errorViewController = ErrorViewController()
            errorViewController.title = "Error"
            let navigationController = UINavigationController(rootViewController: errorViewController)
            present(navigationController, animated: true)
            return
        }*/
        let postViewController = PostViewController(post: posts[sender.tag])
        postViewController.title = "@\(posts[sender.tag].user.login)"
        let navigationController = UINavigationController(rootViewController: postViewController)
        present(navigationController, animated: true)
    }
}
