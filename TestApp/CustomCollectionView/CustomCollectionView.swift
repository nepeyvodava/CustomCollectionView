import UIKit

class FilterCollectionView: UICollectionView {
    
    //MARK: - variables
    var minimumLineSpacing: CGFloat = 20
    var loupeWidth: CGFloat { return itemWidth }
    var centerCellScale: CGFloat = 1.4
    var selectedItem: Int = 0 {
        didSet{
            guard itemsQty > 0 else { return }
            filterDelegate?.itemDidSelected(item: selectedItem)
        }
    }
    let collectionViewFlowLayout: FilterCollectionFlowLayout = {
        let collectionLayout =  FilterCollectionFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        return collectionLayout
    }()
    
    var filterDelegate: FilterCollectionDelegate?
    
    //MARK: - init
    convenience init() {
        self.init()
        self.setup()
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    /*
     / MARK: - configure
     / use this method in viewDidLoad() of datasourse class
     */
    func configure() {
        layoutIfNeeded()
        updateTransforms()
        selectedItem = 0
    }
    
}

private extension FilterCollectionView {
    
    func setup() {
        self.isPagingEnabled = false
        self.isMultipleTouchEnabled = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = .clear
        self.layer.masksToBounds = true
        self.collectionViewLayout = collectionViewFlowLayout
        
        self.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
        delegate = self
        self.decelerationRate = .fast
    }
    
}

extension FilterCollectionView: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateTransforms()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item != selectedItem else { return }
        selectedItem = indexPath.item
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        // for duoble cklick bug fix
        self.isUserInteractionEnabled = false
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // for duoble cklick bug fix
        self.isUserInteractionEnabled = true
    }
    
}

extension FilterCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let offset = (self.bounds.width - itemWidth)/2
        return UIEdgeInsets(top: 0, left: offset, bottom: 0, right: offset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.itemSize
    }
    
}


private extension FilterCollectionView {
    
    var itemSize: CGSize { return CGSize(width: frame.height/centerCellScale, height: frame.height/centerCellScale) }
    var itemWidth: CGFloat { return self.itemSize.width }
    var itemSpacing: CGFloat { return self.minimumLineSpacing }
    var itemsQty: Int { return numberOfItems(inSection: 0) }
    var scrollOffset: CGFloat { return self.contentOffset.x + self.contentInset.left }
    var scrollMaxOffset: CGFloat { return CGFloat(itemsQty - 1) * (itemWidth + itemSpacing) }

    func getCenterOfItem(_ item: Int) -> CGFloat {
        let result = CGFloat(item)*(itemWidth + itemSpacing) - scrollOffset
        return result
    }
    
    func updateTransforms() {
        guard itemsQty > 0 else { return }
        for i in 0...(itemsQty-1) {
            guard let cell = cellForItem(at: IndexPath(item: i, section: 0)) else { continue }
            let centerX = abs(getCenterOfItem(i))
            if centerX > loupeWidth {
                cell.transform = .identity
            } else {
                let scale = centerCellScale - (centerCellScale - 1)*centerX/loupeWidth
                cell.transform = .init(scaleX: scale, y: scale)
            }
        }
    }
    
    func calculateTarget(offset: CGFloat) -> Int {
        guard scrollMaxOffset > 0 else { return 0 }
        let qty = itemsQty - 1
        let target = Int(round(CGFloat(qty) * offset/scrollMaxOffset))
        if target > qty { return qty }
        if target < 0 { return 0 }
        return target
    }
    
}

protocol FilterCollectionDelegate: class {
    
    func itemDidSelected(item: Int)
    
}


class FilterCollectionFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView as? FilterCollectionView else {
            return super .targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let pageWidth = collectionView.itemWidth + collectionView.itemSpacing
        let approximatePage = collectionView.contentOffset.x/pageWidth
        
        var currentPage: CGFloat = 0
        if velocity.x == 0 {
            currentPage = round(approximatePage)
        } else {
            currentPage = (velocity.x < 0.0) ? floor(approximatePage) : ceil(approximatePage)
        }
        
        let flickedPages = (abs(round(velocity.x)) <= 0.8) ? 0 : round(velocity.x)
        
        let newHorizontalOffset = ((currentPage + flickedPages) * pageWidth) - self.collectionView!.contentInset.left
        
        collectionView.selectedItem = collectionView.calculateTarget(offset: newHorizontalOffset)
        
        return CGPoint(x: newHorizontalOffset, y: proposedContentOffset.y)
    }
    
}
