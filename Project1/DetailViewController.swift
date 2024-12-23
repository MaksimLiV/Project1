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
    var viewsCountCallback: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailViewController viewDidLoad started")
        
        view.backgroundColor = .white
        setupImageView()
        setupNavigationItem()
        
        if let imageToLoad = selectedImage {
            print("Loading image: \(imageToLoad)")
            imageView.image = UIImage(named: imageToLoad)
            viewsCountCallback?(imageToLoad)
            print("Called viewsCountCallback for \(imageToLoad)")
        }
        
        updateTitle()
    }
    
    func setupImageView() {
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
    }
    
    func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Share Image",
            style: .plain,
            target: self,
            action: #selector(shareImage)
        )
    }
    
    func updateTitle() {
        if let index = selectedIndex, let total = totalPictures {
            title = "Picture \(index + 1) of \(total)"
            print("Updated title: \(title ?? "")")
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
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8),
              let imageName = selectedImage else {
            print("Failed to prepare image for sharing")
            return
        }
        
        let message = "Check out this storm image: \(imageName)!"
        let vc = UIActivityViewController(activityItems: [message, image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
