//
//  PicturePickerViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 11.09.2024.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseAuth

final class PicturePickerViewController: UIViewController, UINavigationControllerDelegate {
    
    
    let imagePicker = UIImagePickerController()
    
    // MARK: - Subviews
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray
        return imageView
    }()

    private lazy var chooseImageButton = UICustomButton(customTitle: String(localized: "Choose Image"), customBackgroundColor: .secondaryColor ,action: {
        self.pickImage()
    })
    
    private lazy var saveImageButton = UICustomButton(customTitle: String(localized: "Save"), customBackgroundColor: .accentColor ,action: {
        self.saveImage()
    })
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addSubviews()
        setupConstraints()
        setupDelegates()
    }
    
    // MARK: - Actions
    @objc
    
    // MARK: - Private
    private func sayHello() {
        print("Hello, world!")
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(saveImageButton)
        view.addSubview(chooseImageButton)
        chooseImageButton.isEnabled = true
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            
            saveImageButton.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -10),
            saveImageButton.heightAnchor.constraint(equalToConstant: 50),
            saveImageButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 25),
            saveImageButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -25),
            
            chooseImageButton.bottomAnchor.constraint(equalTo: saveImageButton.topAnchor, constant: -10),
            chooseImageButton.heightAnchor.constraint(equalTo: saveImageButton.heightAnchor),
            chooseImageButton.leadingAnchor.constraint(equalTo: saveImageButton.leadingAnchor),
            chooseImageButton.trailingAnchor.constraint(equalTo: saveImageButton.trailingAnchor)
        ])
    }
    
    private func setupDelegates() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    private func pickImage() {
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
    
    private func saveImage() {
        guard let image = imageView.image else {
             print("No image found to upload")
             return
         }
         
         // 2. Convert the image to JPEG data with a compression quality (adjust quality as needed)
         guard let imageData = image.jpegData(compressionQuality: 0.8) else {
             print("Could not convert image to data")
             return
         }
         
         // 3. Create a unique filename for the image (for example, using a timestamp)
        guard let id = Auth.auth().currentUser?.uid else {
            print("User not found")
            return
        }
        let filename = "ProfilePictures/\(id).jpg"
         
         // 4. Create a reference to Firebase Storage
         let storageRef = Storage.storage().reference().child(filename)
         
         // 5. Upload the image data to Firebase Storage
         storageRef.putData(imageData, metadata: nil) { metadata, error in
             if let error = error {
                 print("Failed to upload image: \(error.localizedDescription)")
                 return
             }
             
             // 6. Optionally, get the download URL
             storageRef.downloadURL { url, error in
                 if let error = error {
                     print("Failed to get download URL: \(error.localizedDescription)")
                     return
                 }
                 
                 if let downloadURL = url {
                     print("Image uploaded successfully, download URL: \(downloadURL)")
                     // You can now use this URL to save in your database or display to the user
                 }
             }
         }
        
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}

extension PicturePickerViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        imageView.image = pickedImage
        
        dismiss(animated: true, completion: nil)
    }
}
