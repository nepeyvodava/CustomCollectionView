import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    //MARK: - options
    private let borderCell: CGFloat = 1
    private let borderImage: CGFloat = 2
    
    //MARK: - variables
    let imageView: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        iV.translatesAutoresizingMaskIntoConstraints = false
        return iV
    }()
    override var frame: CGRect {
        didSet{
            layer.cornerRadius = frame.height/2
        }
    }
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func configure(image: UIImage?) {
        self.imageView.image = image
    }

}

private extension FilterCollectionViewCell {
    
    func setup() {
        layer.borderWidth = self.borderCell
        layer.borderColor = UIColor.black.cgColor
        layer.masksToBounds = true
        backgroundColor = .clear
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: borderCell),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -borderCell),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: borderCell),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -borderCell)
            ])
        layoutIfNeeded()
        imageView.layer.borderWidth = self.borderImage
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.height/2
    }
    
}
