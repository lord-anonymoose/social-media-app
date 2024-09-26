//
//  MakePostViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 20.09.2024.
//

import Foundation
import UIKit



final class MakePostViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {
    
    
    
    // MARK: Subviews
    
    let imagePicker = UIImagePickerController()

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
        contentView.accessibilityIdentifier = "contentView"

        return contentView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description:".localized
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .secondaryColor
        textView.accessibilityIgnoresInvertColors = true
        return textView
    }()
    
    private lazy var imageLabel: UILabel = {
        let label = UILabel()
        label.text = "Image:".localized
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultPostImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .green
        imageView.isUserInteractionEnabled = true
        let imageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        imageView.addGestureRecognizer(imageTapGestureRecognizer)
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .secondaryLabel
        activityIndicator.isHidden = true
        //activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    
    private lazy var makePostButton = UICustomButton(customTitle: "Post".localized) { [unowned self] in
            
        if imageView.image == UIImage(named: "defaultPostImage") {
            self.showAlert(title: "Error!".localized, description: "You didn't choose an image to upload!".localized)
            stopLoadingUI()
        } else {
            startLoadingUI()
            PostService.shared.publishPost(image: imageView.image!, description: descriptionTextView.text ?? "") { error in
                self.stopLoadingUI()
                if let error {
                    self.showAlert(title: "Error!".localized, description: error.localizedDescription)
                } else {
                    print("posted!")
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDelegates()
        addSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopLoadingUI()
        removeKeyboardObservers()
    }
    
    
    
    // MARK: Actions
    
    @objc func imageTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        showImagePicker()
    }
    
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

    
    
    // MARK: Private
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imageLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(makePostButton)
        contentView.addSubview(activityIndicator)

        descriptionTextView.isEditable = true
    }
    
    private func setupDelegates() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        descriptionTextView.delegate = self
    }
    
    private func setupConstraints() {
        self.makeScrollable()
                
        NSLayoutConstraint.activate([
            makePostButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            makePostButton.heightAnchor.constraint(equalToConstant: 50),
            makePostButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            makePostButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            makePostButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            activityIndicator.centerYAnchor.constraint(equalTo: makePostButton.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalTo: makePostButton.heightAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: makePostButton.trailingAnchor, constant: -10),
            
            imageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            imageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            
            imageView.topAnchor.constraint(equalTo: imageLabel.bottomAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.width - 20),
            imageView.widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
            descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
    
    private func startLoadingUI() {
        self.imageView.alpha = 0.8
        self.descriptionTextView.alpha = 0.8
        self.makePostButton.alpha = 0.8
        
        self.imageView.isUserInteractionEnabled = false
        self.descriptionLabel.isUserInteractionEnabled = false
        self.makePostButton.isUserInteractionEnabled = false
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    private func stopLoadingUI() {
        self.imageView.alpha = 1.0
        self.descriptionLabel.alpha = 1.0
        self.makePostButton.alpha = 1.0
        
        self.imageView.isUserInteractionEnabled = true
        self.descriptionLabel.isUserInteractionEnabled = true
        self.makePostButton.isUserInteractionEnabled = true
        
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    private func showImagePicker() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (button) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil
        )}))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (button) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil
        )}))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
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
}

extension MakePostViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        imageView.image = pickedImage
        
        dismiss(animated: true, completion: nil)
    }
}
