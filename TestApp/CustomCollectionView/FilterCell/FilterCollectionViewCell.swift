import UIKit

//MARK: - Class FilterCollectionViewCell
class FilterCollectionViewCell: CustomCollectionViewCell {
    
    static let reuseID = String(describing: FilterCollectionViewCell.self)
    
    //MARK: configure
    func configure(view: UIView) {
        self.containerView = view
        self.setupViews()
    }

}

