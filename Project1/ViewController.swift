//
//  ViewController.swift
//  Project1
//
//  Created by Maksim Li on 01/09/2024.
//

import UIKit

class ViewController: UIViewController {
    
    var pictures = [String]()
    var collectionView: UICollectionView!
    var viewsCount = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewDidLoad started")
        loadViewsCount()
        setupNavigationBar()
        setupCollectionView()
        loadPictures()
    }
    
    func setupNavigationBar() {
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Recommend",
            style: .plain,
            target: self,
            action: #selector(recommendApp)
        )
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(PictureCell.self, forCellWithReuseIdentifier: "Picture")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func loadPictures() {
        print("Loading pictures started")
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            var loadedPictures = [String]()
            
            for item in items {
                if item.hasPrefix("nssl") {
                    loadedPictures.append(item)
                }
            }
            
            loadedPictures.sort()
            print("Found pictures: \(loadedPictures)")
            
            DispatchQueue.main.async {
                self?.pictures = loadedPictures
                self?.collectionView.reloadData()
                print("Collection view reloaded with \(loadedPictures.count) pictures")
            }
        }
    }
    
    func saveViewsCount() {
        print("Saving views count: \(viewsCount)")
        UserDefaults.standard.set(viewsCount, forKey: "ViewsCount")
        UserDefaults.standard.synchronize()
    }
    
    func loadViewsCount() {
        if let savedViewsCount = UserDefaults.standard.dictionary(forKey: "ViewsCount") as? [String: Int] {
            viewsCount = savedViewsCount
            print("Loaded views count: \(viewsCount)")
        } else {
            print("No saved views count found")
        }
    }
    
    @objc func recommendApp() {
        let message = "Check out Storm Viewer! It's an amazing app!"
        let vc = UIActivityViewController(activityItems: [message], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

class PictureCell: UICollectionViewCell {
    var imageView: UIImageView!
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.text = nil
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as! PictureCell
        
        let pictureName = pictures[indexPath.item]
        let viewCount = viewsCount[pictureName, default: 0]
        
        print("Configuring cell for \(pictureName) with \(viewCount) views")
        
        cell.imageView.image = UIImage(named: pictureName)
        cell.label.text = "\(pictureName) \n(\(viewCount) views)"
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected cell at index \(indexPath.item)")
        let detailVC = DetailViewController()
        detailVC.selectedImage = pictures[indexPath.item]
        detailVC.selectedIndex = indexPath.item
        detailVC.totalPictures = pictures.count
        
        detailVC.viewsCountCallback = { [weak self] imageName in
            print("Callback executed for: \(imageName)")
            self?.viewsCount[imageName, default: 0] += 1
            print("New count for \(imageName): \(self?.viewsCount[imageName] ?? 0)")
            self?.saveViewsCount()
            
            if let index = self?.pictures.firstIndex(of: imageName) {
                let indexPath = IndexPath(item: index, section: 0)
                DispatchQueue.main.async {
                    self?.collectionView.reloadItems(at: [indexPath])
                }
                print("Reloaded cell at index \(index)")
            }
        }
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 40) / 3
        return CGSize(width: width, height: width + 40)
    }
}
