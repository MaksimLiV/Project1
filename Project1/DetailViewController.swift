//
//  DetailViewController.swift
//  Project1
//
//  Created by Maksim Li on 05/09/2024.
//

import UIKit

class DetailViewController: UIViewController {
    var imageView: UIImageView!
    var selectedImage: String?
    var selectedIndex: Int?
    var totalPictures: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share Image", style: .plain, target: self, action: #selector(shareImage))
        
        if let imageToLoad = selectedImage, let image = UIImage(named: imageToLoad) {
            imageView.image = image
        }
        
        if let index = selectedIndex, let total = totalPictures {
            title = "Picture \(index + 1) of \(total)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareImage() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8), let imageName = selectedImage else {
            print("No image to share.")
            return
        }

        let message = "Hey, you're trying to share \(imageName)!"
        let vc = UIActivityViewController(activityItems: [message, image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
