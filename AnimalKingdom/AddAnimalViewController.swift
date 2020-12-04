/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Per-section specific layout example
*/

import UIKit

class AddAnimalViewController: UIViewController {

    enum SectionHeaders: String, CaseIterable {
        case first_section = "00:30:00"
        case second_section = "00:60:00"
        var duration: Int {
            switch self {
                case .first_section:
                    return 1800

                case .second_section:
                    return 3600
            }
        }
    }

    var dataSource: UICollectionViewDiffableDataSource<String, Animal>! = nil
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
//        AnimalData.shared().updateData { (error) in
//            print("Error loading animal data \(error)")
//        } completionHandler: {
//            self.configureDataSource()
//        }
        self.configureHierarchy()
        self.configureDataSource()
    }
}

extension AddAnimalViewController {
    /// - Tag: PerSection
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let columns = 3

            // The group auto-calculates the actual item width to make
            // the requested number of columns fit, so this widthDimension is ignored.
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

            let groupHeight = NSCollectionLayoutDimension.fractionalWidth(0.2)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            
            //add header
            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                         heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: "Header", alignment: .top)
        
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
        return layout
    }
}

extension AddAnimalViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        // MARK: Aadd background image for collection
        collectionView.backgroundView = UIImageView(image: UIImage(named: "place2"))
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    @objc func raiseAnimal(_ sender: AddAnimalRecognizer) {
        print("Touch raiseAnimal")
        if let objectId = sender.objectId {
            print("This is \(objectId)")
        }
        performSegue(withIdentifier: "addAnimalSegue", sender: sender)
        print("End raiseAnimal")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Called prepare for segue")
        if let controller = segue.destination as? LockScreenViewController,
           let animalRecognizer = sender as? AddAnimalRecognizer,
           let objectId = animalRecognizer.objectId {
            print("Get objectId prepare for segue")

            if let animal = AnimalData.shared().animals.first(where: { (animal) -> Bool in
                return animal.objectId == objectId
            }) {
                controller.animal = animal
                print("Get controller prepare for segue")

            }
            
        }
        
    }
    
    func configureDataSource() {
        let animalCellRegistration = UICollectionView.CellRegistration<AnimalCell, Animal> { (cell, indexPath, data) in
            // Populate the cell with our item description.
            // MARK: animal image
            let image = UIImage(named: data.imageURL)
            var imageView : UIImageView
            if let image = image {
                imageView = UIImageView(image: image)
            }
            else {
                imageView = UIImageView()
            }
            imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
            imageView.contentMode = .scaleAspectFit
            cell.addSubview(imageView)
//            cell.contentView.backgroundColor = .blue
            // MARK: Style cell
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 8
            
            // MARK: Add data for cell
            cell.objectId = data.objectId
            // MARK: Add cell action
            let touchInteraction = AddAnimalRecognizer(target: self, action: #selector(self.raiseAnimal))
            touchInteraction.objectId = data.objectId
            cell.addGestureRecognizer(touchInteraction)
        }
        
        // MARK: add header for each section
        let headers = ["00:30:00", "00:60:00"]
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: "Header") {
            (supplementaryView, string, indexPath) in
            supplementaryView.label.text = "\(headers[indexPath.section])"
            supplementaryView.backgroundColor = .lightGray
            supplementaryView.layer.borderColor = UIColor.black.cgColor
            supplementaryView.layer.borderWidth = 1.0
        }
        
        //add cell
        dataSource = UICollectionViewDiffableDataSource<String, Animal>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Animal) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: animalCellRegistration, for: indexPath, item: identifier)
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: index)
        }

        // initial data
//        let animal1 = Animal(name: "dog", level: 1, imageURL: "dog2-baby", duration: 1800)
//        let animal2 = Animal(name: "dog", level: 2, imageURL: "dog2-grown", duration: 3600)
//        let animal3 = Animal(name: "frog", level: 1, imageURL: "frog-baby", duration: 1800)
//        let animal4 = Animal(name: "frog", level: 2, imageURL: "frog-kid", duration: 3600)
//        let data = [animal1, animal2,animal3,animal4]
        
        let data = AnimalData.shared().animals
        var snapshot = NSDiffableDataSourceSnapshot<String, Animal>()
        
        SectionHeaders.allCases.forEach { (header) in
            snapshot.appendSections([header.rawValue])
            snapshot.appendItems(data.filter({ (animal) -> Bool in
                return animal.duration == header.duration
            }))
           
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension AddAnimalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
