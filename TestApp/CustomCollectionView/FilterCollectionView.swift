import UIKit

//MARK: - Protocol FilterCollectionViewDelegate
protocol FilterCollectionViewDelegate: class {
    
    func didSelectItem(item: Int)
    
}


//MARK: - Class FilterCollectionView
class FilterCollectionView: UICollectionView {
    
    //MARK: options
    var minimumLineSpacing: CGFloat = 20
    var loupeWidth: CGFloat { return itemWidth }
    var centerCellScale: CGFloat = 1.4
    
    //MARK: variables
    fileprivate var selectedItem: Int = 0 {
        didSet{
            guard itemsQuantity > 0, selectedItem != oldValue else { return }
            let index = IndexPath(item: selectedItem, section: 0)
            self.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            filterDelegate?.didSelectItem(item: selectedItem)
        }
    }
    
    var filterDelegate: FilterCollectionViewDelegate?
    
    //MARK: init
    init() {
        super.init(frame: .zero, collectionViewLayout: FilterCollectionFlowLayout())
        self.setup()
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: FilterCollectionFlowLayout())
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateTransforms()
    }
    
}

//MARK: - Private Ext FilterCollectionView
private extension FilterCollectionView {
    
    func setup() {
        self.isPagingEnabled = false
        self.isMultipleTouchEnabled = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = .clear
        self.layer.masksToBounds = true
        
        self.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.reuseID)
        delegate = self
        self.decelerationRate = .fast
    }
    
}

//MARK: - UICollectionViewDelegate methods
extension FilterCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item != selectedItem else { return }
        selectedItem = indexPath.item

        // for double cklick bug fix
        self.isUserInteractionEnabled = false
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // for double cklick bug fix
        self.isUserInteractionEnabled = true
    }
    
    // -------------------
    // Animation if needed
    // -------------------
    /*
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 1, y: 0.3)
        UIView.animate(withDuration: 0.2) {
            cell.transform = .identity
        }
    }
     */
    
}

//MARK: - UICollectionViewDelegateFlowLayout methods
extension FilterCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let offset = (self.bounds.width - itemWidth)/2
        return UIEdgeInsets(top: 0, left: offset, bottom: 0, right: offset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return bounds.height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.itemSize
    }
    
}

//MARK: - calculate methods
private extension FilterCollectionView {
    
    var itemSize: CGSize { return CGSize(width: bounds.height/centerCellScale, height: bounds.height/centerCellScale) }
    var itemWidth: CGFloat { return self.itemSize.width }
    var itemSpacing: CGFloat { return self.minimumLineSpacing }
    var itemsQuantity: Int { return numberOfItems(inSection: 0) }
    var scrollOffset: CGFloat { return self.contentOffset.x + self.contentInset.left }
    var scrollMaxOffset: CGFloat { return CGFloat(itemsQuantity - 1) * (itemWidth + itemSpacing) }

    func getItemOffset(_ item: Int) -> CGFloat {
        let result = CGFloat(item)*(itemWidth + itemSpacing) - scrollOffset
        return result
    }
    
    func updateTransforms() {
        guard itemsQuantity > 0 else { return }
        for i in 0...(itemsQuantity-1) {
            guard let cell = cellForItem(at: IndexPath(item: i, section: 0)) else { continue }
            let itemOffset = abs(getItemOffset(i))
            if itemOffset > loupeWidth {
                cell.transform = .identity
            } else {
                let scale = centerCellScale - (centerCellScale - 1)*itemOffset/loupeWidth
                cell.transform = .init(scaleX: scale, y: scale)
            }
        }
    }
    
    func calculateTarget(offset: CGFloat) -> Int {
        guard scrollMaxOffset > 0 else { return 0 }
        let qty = itemsQuantity - 1
        let target = Int(round(CGFloat(qty) * offset/scrollMaxOffset))
        if target > qty { return qty }
        if target < 0 { return 0 }
        return target
    }
    
}


//MARK: - Class FilterCollectionFlowLayout
private class FilterCollectionFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView as? FilterCollectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let pageWidth = collectionView.itemWidth + collectionView.itemSpacing
        let approximateNumberPage = collectionView.contentOffset.x/pageWidth
        
        var currentPage: CGFloat = 0
        if velocity.x == 0 {
            currentPage = round(approximateNumberPage)
        } else {
            currentPage = (velocity.x < 0.0) ? floor(approximateNumberPage) : ceil(approximateNumberPage)
        }
        
        let flickedPages = (abs(round(velocity.x)) < 0.8) ? 0 : round(velocity.x)
        
        let newHorizontalOffset = ((currentPage + flickedPages) * pageWidth) - collectionView.contentInset.left
        
        let item = collectionView.calculateTarget(offset: newHorizontalOffset)
        collectionView.selectedItem = item
        
        return CGPoint(x: newHorizontalOffset, y: proposedContentOffset.y)
    }
    
    override init() {
        super.init()
        scrollDirection = .horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
