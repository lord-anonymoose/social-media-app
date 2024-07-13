//
//  logInViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 28.06.2023.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import CoreData



class LogInViewController: UIViewController {
    
    var loginDelegate: LoginViewControllerDelegate?
    var isBruteforsing: Bool = false
    var ref: DatabaseReference!

    // MARK: - Subviews
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.isUserInteractionEnabled = true
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.isUserInteractionEnabled = true
        
        return contentView
    }()
    
    private lazy var appLogo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "appLogo"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var logInInputContainer = LoginInputContainer()
    
    private lazy var loginInput: UITextFieldWithPadding = {
        let textField = UITextFieldWithPadding()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        textField.textColor = textColor
        textField.font = .systemFont(ofSize: 16)
        textField.tintColor = accentColor
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.masksToBounds = true
        textField.keyboardType = .emailAddress
        
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        return textField
    }()
    
    private lazy var passwordInput: UITextFieldWithPadding = {
        let textField = UITextFieldWithPadding()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.textColor = textColor
        textField.font = .systemFont(ofSize: 16)
        textField.tintColor = accentColor
        textField.layer.masksToBounds = true
        
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        return textField
    }()
    
    private lazy var logInButton = CustomButton(customTitle: "Log In") { [unowned self] in
        
        startLoginOperation()
        
        let service = CheckerService()
        service.checkCredentials(email: loginInput.text ?? "", password: passwordInput.text ?? "", completion: {result in
            switch result {
            case .success(let user):
                print("Sign-in successful")
                self.loginInput.text = ""
                self.passwordInput.text = ""
                if let navigationController = self.navigationController {
                    self.stopLoginOperation()
                    let coordinator = ProfileCoordinator(navigationController: navigationController)
                    coordinator.authenticate(user: user)
                    coordinator.start()
                }
                
                //self.ref = Database.database(url: "https://social-media-5eea4-default-rtdb.firebaseio.com/").reference()

            case .failure(let error):
                self.showErrorAlert(description: error.description)
                self.stopLoginOperation()
            }
        })
    }
    
    private lazy var showPasswordButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleShowPassword), for: .touchUpInside)
        button.tintColor = .systemGray
        
        return button
    }()
    
    private lazy var bruteforceButton = CustomButton(customTitle: "Bruteforce password", action: {
    })
    
    private lazy var bruteForceIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    private lazy var loginIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    private lazy var signUpButton = CustomButton(customTitle: "Not a member yet? Sign up!", customBackgroundColor: secondaryColor ,action: {
        let signUpViewController = SignUpViewController()
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    })
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addSubviews()
        setupConstraints()
        setupContentOfScrollView()
        //setupBruteforceButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupKeyboardObservers()
        self.loginInput.delegate = self
        self.passwordInput.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.bruteForceIndicator.stopAnimating()
        self.loginIndicator.stopAnimating()
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    // MARK: - Actions
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        scrollView.contentInset.bottom = 0.0
        scrollView.contentInset.bottom += keyboardHeight ?? 0.0
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0.0
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func toggleShowPassword() {
        if showPasswordButton.image(for: .normal) == UIImage(systemName: "eye") {
            showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            passwordInput.isSecureTextEntry = false
        } else {
            showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
            passwordInput.isSecureTextEntry = true
        }
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = backgroundColor
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(appLogo)
        
        contentView.addSubview(logInInputContainer)
        logInInputContainer.addSubview(loginInput)
        logInInputContainer.addSubview(passwordInput)
        logInInputContainer.addSubview(showPasswordButton)
        
        contentView.addSubview(logInButton)
        contentView.addSubview(loginIndicator)
        contentView.addSubview(signUpButton)
        //contentView.addSubview(bruteforceButton)
        //contentView.addSubview(bruteForceIndicator)
        
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        let bottom = view.safeAreaLayoutGuide.layoutFrame.height
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            scrollView.widthAnchor.constraint(equalTo: safeAreaGuide.widthAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.heightAnchor.constraint(equalToConstant: bottom),
        ])
    }
    
    private func setupContentOfScrollView() {
        
        let centerY = view.safeAreaLayoutGuide.layoutFrame.height / 2
        
        NSLayoutConstraint.activate([
            logInInputContainer.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: centerY),
            logInInputContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            logInInputContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            logInInputContainer.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            loginInput.topAnchor.constraint(equalTo: logInInputContainer.topAnchor, constant: 0),
            loginInput.bottomAnchor.constraint(equalTo: logInInputContainer.bottomAnchor, constant: -50),
            loginInput.leadingAnchor.constraint(equalTo: logInInputContainer.leadingAnchor, constant: 0),
            loginInput.trailingAnchor.constraint(equalTo: logInInputContainer.trailingAnchor, constant: 0),
            
            passwordInput.topAnchor.constraint(equalTo: loginInput.bottomAnchor, constant: 0),
            passwordInput.bottomAnchor.constraint(equalTo: logInInputContainer.bottomAnchor, constant: 0),
            passwordInput.leadingAnchor.constraint(equalTo: logInInputContainer.leadingAnchor, constant: 0),
            passwordInput.trailingAnchor.constraint(equalTo: logInInputContainer.trailingAnchor, constant: 0),
            
            showPasswordButton.topAnchor.constraint(equalTo: passwordInput.topAnchor),
            showPasswordButton.bottomAnchor.constraint(equalTo: passwordInput.bottomAnchor),
            showPasswordButton.trailingAnchor.constraint(equalTo: passwordInput.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            appLogo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            appLogo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            appLogo.heightAnchor.constraint(equalToConstant: 100),
            appLogo.widthAnchor.constraint(equalToConstant: 100),
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -150),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            logInButton.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -10),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            logInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            logInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25)
        ])

        NSLayoutConstraint.activate([
            loginIndicator.centerYAnchor.constraint(equalTo: logInButton.centerYAnchor),
            loginIndicator.trailingAnchor.constraint(equalTo: logInButton.trailingAnchor, constant: -16),
            loginIndicator.widthAnchor.constraint(equalToConstant: 50),
            loginIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        /*
        NSLayoutConstraint.activate([
            bruteforceButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 16),
            bruteforceButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            bruteforceButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bruteforceButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bruteforceButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            bruteForceIndicator.centerYAnchor.constraint(equalTo: bruteforceButton.centerYAnchor),
            bruteForceIndicator.trailingAnchor.constraint(equalTo: bruteforceButton.trailingAnchor, constant: -16),
            bruteForceIndicator.widthAnchor.constraint(equalToConstant: 50),
            bruteForceIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
        */
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
    
    /*
    private func setupBruteforceButtonAction() {
        bruteforceButton.buttonAction = { [unowned self] in
            do {
                try self.startBruteforceOperation()
            } catch {
                let alert = UIAlertController(title: "Error!", message: "Such user doesn't exist!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func startBruteforceOperation() throws {
        
        let login = self.loginInput.text ?? ""
        let result = try getUser(login: login)
        
        switch result {
        case .success(let user):
            DispatchQueue.main.async {
                self.bruteForceIndicator.startAnimating()
                self.bruteForceIndicator.isHidden = false
                self.bruteforceButton.setBackgroundColor(.systemGray, forState: .normal)
                self.bruteforceButton.isUserInteractionEnabled = false
                self.loginInput.isUserInteractionEnabled = false
            }
            
            DispatchQueue.global(qos: .background).async {
                
                let bruteforce = AppBruteforce()
                let password = bruteforce.bruteForce(userToUnclock: user.login)
                
                DispatchQueue.main.async {
                    self.bruteForceIndicator.stopAnimating()
                    self.bruteForceIndicator.isHidden = true
                    self.bruteforceButton.setBackgroundColor(accentColor, forState: .normal)
                    self.bruteforceButton.isUserInteractionEnabled = true
                    self.loginInput.isUserInteractionEnabled = true
                    self.passwordInput.text = password
                    self.passwordInput.isSecureTextEntry = false
                }
            }
            
        case .failure(let error):
            throw error
        }
    }
    
    private func stopBruteForceOperation(with password: String) {
        self.bruteForceIndicator.stopAnimating()
        self.bruteForceIndicator.isHidden = true
    }
    */

    
    private func startLoginOperation() {
        self.logInButton.setBackgroundColor(.systemGray, forState: .normal)
        
        self.loginIndicator.startAnimating()
        self.loginIndicator.isHidden = false
        
        self.bruteforceButton.isUserInteractionEnabled = false
        self.loginInput.isUserInteractionEnabled = false
        self.passwordInput.isUserInteractionEnabled = false
    }
    
    private func stopLoginOperation() {
        self.logInButton.setBackgroundColor(accentColor, forState: .normal)
        
        self.loginIndicator.stopAnimating()
        self.loginIndicator.isHidden = true
        
        self.bruteforceButton.isUserInteractionEnabled = true
        self.loginInput.isUserInteractionEnabled = true
        self.passwordInput.isUserInteractionEnabled = true
    }
    
    func textFieldShouldReturn(userText: UITextField!) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    private func showErrorAlert(description: String) {
        let alert = UIAlertController(title: "Error!", message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    private func fetchUsernames(completion: @escaping ([User]) -> Void) {
        ref.child("users").observeSingleEvent(of: .value, with: { snapshot in
            var users: [User] = []
            
            // Iterate through all users and fetch their usernames
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let name = child.value as? String {
                    users.append(User(login: child.key, name: name))
                }
            }
            
            completion(users)
        }) { error in
            print("Error fetching usernames: \(error.localizedDescription)")
            completion([])
        }
    }
    */
}
