import UIKit

//MARK: - Class ViewController
class ViewController: UIViewController {
    
    //MARK: variables
    let data: [Data] = [Data(image: UIImage(named: " "), title: "original"),
                        Data(image: UIImage(named: "1"), title: "filter 1"),
                        Data(image: UIImage(named: "2"), title: "filter 2"),
                        Data(image: UIImage(named: "3"), title: "filter 3"),
                        Data(image: UIImage(named: "4"), title: "filter 4"),
                        Data(image: UIImage(named: "5"), title: "filter 5"),
                        Data(image: UIImage(named: "6"), title: "filter 6"),
                        Data(image: UIImage(named: "7"), title: "filter 7")
    ]
    
    let round: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        v.layer.borderWidth = 5
        v.layer.borderColor = UIColor.white.cgColor
        v.isUserInteractionEnabled = false
        return v
    }()

    //MARK: Outlets
    @IBOutlet weak var collectionView: FilterCollectionView!
    @IBOutlet weak var filterLabel: UILabel!
    
    //MARK: ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.filterDelegate = self
        collectionView.configure()
        
        setupViews()
    }
    
}

//MARK: - Private Ext
private extension ViewController {
    
    func setupViews() {
        view.addSubview(round)
        NSLayoutConstraint.activate([
            round.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor, constant: 0),
            round.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: 0),
            round.widthAnchor.constraint(equalTo: collectionView.heightAnchor, constant: round.layer.borderWidth*2),
            round.heightAnchor.constraint(equalTo: collectionView.heightAnchor, constant: round.layer.borderWidth*2)
            ])
        round.layoutIfNeeded()
        round.layer.cornerRadius = round.bounds.width/2
    }
    
}

//MARK: - UICollectionViewDataSource Methods
extension ViewController: UICollectionViewDataSource {
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterViewCell", for: indexPath) as? FilterCollectionViewCell
            else { return UICollectionViewCell() }

        cell.configure(image: data[indexPath.item].image)
        return cell
    }
    
}

//MARK: - FilterCollectionViewDelegate Methods
extension ViewController: FilterCollectionViewDelegate {
    
    func itemDidChanged(item: Int) {
        self.filterLabel.text = data[item].title
    }
    
}
