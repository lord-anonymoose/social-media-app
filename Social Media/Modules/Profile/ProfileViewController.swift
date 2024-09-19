//
//  ProfileViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 25.05.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let refreshControl = UIRefreshControl()
    
    private var user: User
    
    private var imagePath: String?
    
    private var userPosts: [Post]
    
    private var userPhotos: [UIImage]

    private var isMyUser: Bool
    // MARK: - Subviews

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
    
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        
        if let path = self.imagePath {
            imageView.image = ImageCacheService.shared.getCachedImage(from: path)
        } else {
            imageView.image = UIImage(named: "default")
        }
        
        
        imageView.layer.cornerRadius = 45
        imageView.clipsToBounds = true
        imageView.alpha = 1.0
        imageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPicture))
        imageView.addGestureRecognizer(tap)
        
        return imageView
    }()
    
    private lazy var changeImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change image", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.alpha = 0.0
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(changeImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    init(user: User, isMyUser: Bool) {
        self.user = user
        self.isMyUser = isMyUser
        self.userPosts = []//posts.filter { $0.author == "katyperry" }
            
        var photos = [UIImage]()
            
        for p in userPosts {
            //photos.append(UIImage(named: p.image)!)
        }
            
        self.userPhotos = photos
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePath()
        setupUserImage()
        setupUI()
        addSubviews()
        setupConstraints()
        downloadUserImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupKeyboardObservers()
        refresh()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        blurDissapears()
        removeKeyboardObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUserImage()
        feedView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func refresh() {
        print("Refreshed")
        do {
            let uid = try FirebaseService.shared.currentUserID()
            if let id = uid {
                FirebaseService.shared.fetchUser(by: id) { user in
                    if let user = user {
                        self.user = user
                        self.downloadUserImage()
                        self.feedView.reloadData()
                    } else {
                        print("User not found")
                    }
                }
            }
        }
        catch {
            showAlert(title: "Error!".localized, description: error.localizedDescription)
            refreshControl.endRefreshing()
            return
        }

        refreshControl.endRefreshing()
    }
    
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
        if let navigationController = self.navigationController {
            let coordinator = MainCoordinator(navigationController: navigationController)
            coordinator.logout()
        }
    }
    
    @objc func changeImageButtonTapped(_ button: UIButton) {
        if let navigationController = self.navigationController {
            let coordinator = MainCoordinator(navigationController: navigationController)
            coordinator.showProfilePicViewController(image: self.userImageView.image ?? UIImage(named: "default")!)
        }
    }
    
    @objc func settingsButtonTapped(_ button: UIButton) {
        if let navigationController = self.navigationController {
            let coordinator = MainCoordinator(navigationController: navigationController)
            coordinator.showSettingsViewController()
        }
    }
    
    // MARK: - Private
    private func setupImagePath() {
        do {
            guard let id = try FirebaseService.shared.currentUserID() else {
                return
            }
            self.imagePath = "ProfilePictures/\(id).jpg"
        } catch {
            self.showAlert(title: "Error!".localized, description: error.localizedDescription)
        }
    }
    
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(feedView)
        feedView.addSubview(refreshControl)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing".localized)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        view.addSubview(backgroundBlur)
        view.addSubview(blurCloseButton)
        view.addSubview(userImageView)
        view.bringSubviewToFront(userImageView)
        view.addSubview(changeImageButton)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            feedView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 0),
            feedView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            feedView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            feedView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            
            backgroundBlur.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundBlur.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundBlur.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundBlur.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            blurCloseButton.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 20),
            blurCloseButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -20),
            blurCloseButton.heightAnchor.constraint(equalToConstant: 30),
            blurCloseButton.widthAnchor.constraint(equalToConstant: 30),
            
            changeImageButton.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -20),
            changeImageButton.heightAnchor.constraint(equalToConstant: 50),
            changeImageButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 20),
            changeImageButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -20)
        ])
        
        
        feedView.delegate = self
        feedView.dataSource = self
        
        feedView.register(PostViewCell.self, forCellReuseIdentifier: "cell")
        feedView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: "ProfileHeaderView")
        feedView.register(AnyProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: "AnyProfileHeaderView")
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
        self.userImageView.alpha = 0.0
        let imageSize: CGFloat = 90
        let xPosition = self.view.safeAreaInsets.left + 16
        let yPosition = self.view.safeAreaInsets.top + 16 // Исправлено на safeAreaInsets.top
        
        self.userImageView.frame = CGRect(
            x: xPosition,
            y: yPosition,
            width: imageSize,
            height: imageSize
        )
        self.userImageView.layer.cornerRadius = imageSize / 2
    }
    
    private func downloadUserImage() {
        do {
            guard let id = try FirebaseService.shared.currentUserID() else {
                return
            }
            let path = "ProfilePictures/\(id).jpg"
            ImageCacheService.shared.loadImage(from: path) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.userImageView.image = image
                    self.feedView.reloadData()
                }
            }
        } catch {
            self.showAlert(title: "Error!".localized, description: error.localizedDescription)
        }
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
            self.backgroundBlur.alpha = 0.9
            self.userImageView.alpha = 1.0
            self.userImageView.layer.cornerRadius = 0
            self.userImageView.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
            
            self.userImageView.frame = CGRect(
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
                if self.isMyUser {
                    self.changeImageButton.alpha = 1.0
                    self.changeImageButton.isUserInteractionEnabled = true
                }
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
                self.userImageView.layer.cornerRadius = 45
                self.userImageView.alpha = 0.0
                self.changeImageButton.alpha = 0.0
                self.changeImageButton.isUserInteractionEnabled = false
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
            let identifier = isMyUser ? "ProfileHeaderView" : "AnyProfileHeaderView"

            if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? ProfileHeaderView {
                view.isUserInteractionEnabled = true
                view.user = user
                if let path = self.imagePath {
                    view.userImageView.image = ImageCacheService.shared.getCachedImage(from: path)
                } else {
                    view.userImageView.image = UIImage(named: "default")
                }
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPicture))
                view.userImageView.addGestureRecognizer(tapGestureRecognizer)
                view.logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
                view.settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
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
            
            let cell = PostViewCell(style: .default, reuseIdentifier: "cell", author: "Author", image: "image", description: "description", likes: 0)
            return cell
        }
    }
}

extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photosViewController = PhotosViewController(userPhotos: userPhotos, isMyUser: self.isMyUser)
            self.navigationController?.pushViewController(photosViewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
