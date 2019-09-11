import UIKit

class ViewController: UIViewController {
    
    let data: [Data] = [Data(image: UIImage(named: ""), isNew: false),
                        Data(image: UIImage(named: "1"), isNew: false),
                        Data(image: UIImage(named: "2"), isNew: false),
                        Data(image: UIImage(named: "3"), isNew: false),
                        Data(image: UIImage(named: "4"), isNew: false),
                        Data(image: UIImage(named: "5"), isNew: false),
                        Data(image: UIImage(named: "6"), isNew: false),
                        Data(image: UIImage(named: "7"), isNew: false)
    ]

    //MARK: - Outlets
    @IBOutlet weak var collectionView: CustomCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.configure()
    }

}

extension ViewController: UICollectionViewDataSource {
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? CustomCollectionViewCell
            else { return UICollectionViewCell() }

        cell.configure(image: data[indexPath.item].image)
        return cell
    }
    
}
