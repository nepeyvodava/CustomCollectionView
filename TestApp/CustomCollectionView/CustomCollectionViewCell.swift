import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    //MARK: options
    let borderCell: CGFloat = 1
    let borderImage: CGFloat = 2
    
    var containerView = UIView()
    
    override func layoutSubviews() {
         super.layoutSubviews()
         
         layer.borderWidth = self.borderCell
         layer.borderColor = UIColor.black.cgColor
         layer.masksToBounds = true
         backgroundColor = .clear
         layer.cornerRadius = bounds.height/2
         
         containerView.layer.borderWidth = self.borderImage
         containerView.layer.borderColor = UIColor.white.cgColor
         containerView.layer.masksToBounds = true
         containerView.layer.cornerRadius = contentView.bounds.height/2
     }
    
}


//MARK: - Ext FilterCollectionViewCell
extension CustomCollectionViewCell {
    
    func setupViews() {
        addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: borderCell),
            containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -borderCell),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: borderCell),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -borderCell)
            ])
    }
    
}
