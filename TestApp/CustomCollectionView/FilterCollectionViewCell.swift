import UIKit

//MARK: - Class FilterCollectionViewCell
class FilterCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = String(describing: FilterCollectionViewCell.self)
    
    //MARK: options
    private let borderCell: CGFloat = 1
    private let borderImage: CGFloat = 2
    
    //MARK: variables
    let imageView: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        iV.translatesAutoresizingMaskIntoConstraints = false
        return iV
    }()
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func configure(image: UIImage?) {
        self.imageView.image = image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderWidth = self.borderCell
        layer.borderColor = UIColor.black.cgColor
        layer.masksToBounds = true
        backgroundColor = .clear
        layer.cornerRadius = bounds.height/2
        
        imageView.layer.borderWidth = self.borderImage
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.height/2
    }

}

//MARK: - Private Ext FilterCollectionViewCell
private extension FilterCollectionViewCell {
    
    func setupViews() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: borderCell),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -borderCell),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: borderCell),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -borderCell)
            ])
    }
    
}
