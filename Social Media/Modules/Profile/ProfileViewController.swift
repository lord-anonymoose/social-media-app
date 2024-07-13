//
//  ProfileViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 25.05.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Subviews
    private var user: StorageService.User
    
    private var userPosts: [StorageService.Post]
    
    private var userPhotos: [UIImage]
        
    private lazy var profileView: ProfileHeaderView = {
        let profileView = ProfileHeaderView()

        return profileView
    }()
    
    private lazy var feedView: UITableView = {
        let feedView = UITableView().feedView(isHeaderHidden: true)
        feedView.isUserInteractionEnabled = true
        feedView.allowsSelection = true
        return feedView
    }()
    
    private lazy var backgroundBlur: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.alpha = 0.0
        return view
    }()
    
    private lazy var blurCloseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = .systemBlue
        button.alpha = 0.0
        
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var userImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: user.login))
        
        imageView.layer.cornerRadius = 45
        imageView.clipsToBounds = true
                
        imageView.alpha = 0.0
        
        return imageView
    }()
    
    // MARK: - Lifecycle
    init(user: StorageService.User) {
            self.user = user
            self.userPosts = posts.filter { $0.author == user.login }
            
            var photos = [UIImage]()
            
            for p in userPosts {
                photos.append(UIImage(named: p.image)!)
            }
            
            self.userPhotos = photos
            super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUserImage()
    }
    
    // MARK: - Actions
    
    @objc private func didTapPicture() {
        blurAppears()
    }
    
    @objc private func didTapCloseButton() {
        blurDissapears()
    }
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        feedView.contentInset.bottom = 0.0
        feedView.contentInset.bottom += keyboardHeight ?? 0.0
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        feedView.contentInset.bottom = 0.0
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func logoutButtonTapped(_ button: UIButton) {
        print("logoutButtonTapped")
        if let navigationController = self.navigationController {
            let coordinator = ProfileCoordinator(navigationController: navigationController)
            coordinator.logout()
        }
        //self.navigationController?.pushViewController(LogInViewController(), animated: true)
        //self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = backgroundColor
    }
    
    private func addSubviews() {
        view.addSubview(feedView)
        view.addSubview(backgroundBlur)
        view.addSubview(blurCloseButton)
        view.addSubview(userImage)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            feedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            feedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            feedView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            feedView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            backgroundBlur.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundBlur.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundBlur.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundBlur.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            blurCloseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            blurCloseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            blurCloseButton.heightAnchor.constraint(equalToConstant: 30),
            blurCloseButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        
        feedView.delegate = self
        feedView.dataSource = self
        
        feedView.register(PostViewCell.self, forCellReuseIdentifier: "cell")
        feedView.register(ProfileHeaderView
            .self, forHeaderFooterViewReuseIdentifier: "ProfileHeaderView")
        feedView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotosTableViewCell")
        
    }
    
    private func setupKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willHideKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    private func setupUserImage() {
        self.userImage.frame = CGRect.init(x: self.view.bounds.inset(by: self.view.safeAreaInsets).minX + 16, y: self.view.bounds.inset(by: self.view.safeAreaInsets).minY + 16, width: 90, height: 90)
    }
    
    private func blurAppears() {
        let screenWidth = self.view.frame.size.width
        let finalWidth = screenWidth
        let finalHeight = screenWidth
        
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: .curveLinear
        ) {
            self.backgroundBlur.alpha = 0.7
            self.userImage.alpha = 1.0
            self.userImage.layer.cornerRadius = 0
            self.userImage.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
            
            self.userImage.frame = CGRect(
                x: (screenWidth - finalWidth) / 2,
                y: (self.view.frame.size.height - finalHeight) / 2,
                width: finalWidth,
                height: finalHeight
            )
        } completion: { finished in
            UIView.animate(
                withDuration: 0.3,
                delay: 0.0,
                options: .curveLinear
            ) {
                self.blurCloseButton.alpha = 1.0
            }
        }
    }
    
    private func blurDissapears() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: .curveLinear
        ) {
            self.blurCloseButton.alpha = 0.0
        } completion: { finished in
            UIView.animate(
                withDuration: 0.5,
                delay: 0.0,
                options: .curveLinear
            ) {
                self.backgroundBlur.alpha = 0.0
                self.setupUserImage()
                self.userImage.layer.cornerRadius = 45
                self.userImage.alpha = 0.0
            }
        }
    }
}
    

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProfileHeaderView") as? ProfileHeaderView {
                view.isUserInteractionEnabled = true
                view.user = user
                let tapRed = UITapGestureRecognizer(
                    target: self,
                    action: #selector(didTapPicture)
                )
                tapRed.numberOfTapsRequired = 1
                view.userImage.addGestureRecognizer(tapRed)
                view.logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
                return view
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userPosts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = PhotosTableViewCell(style: .default, reuseIdentifier: "PhotosTableViewCell")
            cell.userPhotos = userPhotos
            return cell
        } else {
            let post = userPosts[indexPath.row - 1]
            let cell = PostViewCell(style: .default, reuseIdentifier: "cell", author: post.author, image: post.image, description: post.description, likes: post.likes, views: post.views)
            return cell
        }
    }
}

extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photosViewController = PhotosViewController(userPhotos: userPhotos)
            self.navigationController?.pushViewController(photosViewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
