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
    var selectedIndex: Int?
    var totalPictures: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
     // p
    }
    */

}
