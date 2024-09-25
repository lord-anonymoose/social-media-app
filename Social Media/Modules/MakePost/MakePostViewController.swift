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
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Description:".localized
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.textColor = .secondaryColor
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textVIew = UITextView()
        textVIew.translatesAutoresizingMaskIntoConstraints = false
        textVIew.backgroundColor = .secondaryColor
        textVIew.accessibilityIgnoresInvertColors = true
        return textVIew
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
    
    
    private lazy var makePostButton = UICustomButton(customTitle: "Post".localized) { [unowned self] in
        print("Posted")
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
        
        contentView.addSubview(imageView)
        contentView.addSubview(makePostButton)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionTextView)
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
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.width - 20),
            imageView.widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
            descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
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
