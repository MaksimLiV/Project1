//
//  DetailViewController.swift
//  Project1
//
//  Created by Maksim Li on 05/09/2024.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedImage

        if let imageToLoad = selectedImage, let image = UIImage(named: imageToLoad) {
            imageView.image = image
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navController = navigationController {
            navController.hidesBarsOnTap = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navController = navigationController {
            navController.hidesBarsOnTap = false
        }
    }

}
