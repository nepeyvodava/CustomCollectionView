import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    //MARK: - variables
    private let offset: CGFloat = 2
    private let imageView: UIImageView = {
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

private extension CustomCollectionViewCell {
    
    func setup() {
        layer.borderWidth = offset
        layer.borderColor = UIColor.white.cgColor
        layer.masksToBounds = true
        backgroundColor = .clear
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: offset),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: offset),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: offset),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: offset)
            ])
    }
    
}
