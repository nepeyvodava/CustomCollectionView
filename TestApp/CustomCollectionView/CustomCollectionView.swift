import UIKit

class CustomCollectionView: UICollectionView {
    
    //MARK: - variables
    var minimumLineSpacing: CGFloat = 20
    var itemSize: CGSize { return CGSize(width: frame.height, height: frame.height) }
    var centerCellScale: CGFloat = 1.3
    var selectedItem: Int = 0 {
        didSet{
            guard itemsQty > 0 else { return }
            let index = IndexPath(item: selectedItem, section: 0)
            self.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        }
    }
    let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        return collectionLayout
    }()
    
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

private extension CustomCollectionView {
    
    func setup() {
        self.isPagingEnabled = false
        self.isMultipleTouchEnabled = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = .clear
        self.layer.masksToBounds = false
        self.collectionViewLayout = collectionViewFlowLayout
        self.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
        delegate = self
        self.decelerationRate = .fast
    }
    
}

extension CustomCollectionView: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let target = calculateTarget()
        selectedItem = target
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard abs(velocity.x) == 0 else { return }
        let target = calculateTarget()
        selectedItem = target
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateTransforms()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(scrollView.contentOffset, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = indexPath.item
    }
 
}

extension CustomCollectionView: UICollectionViewDelegateFlowLayout {
    
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


private extension CustomCollectionView {
    
    var windowWidth: CGFloat { return itemWidth }
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
            if centerX > windowWidth {
                cell.transform = .identity
            } else {
                let scale = centerCellScale - (centerCellScale - 1)*centerX/windowWidth
                cell.transform = .init(scaleX: scale, y: scale)
            }
        }
    }
    
    func calculateTarget() -> Int {
        guard scrollMaxOffset > 0 else { return 0 }
        let qty = itemsQty - 1
        let target = Int(round(CGFloat(qty) * scrollOffset/scrollMaxOffset))
        if target > qty { return qty }
        if target < 0 { return 0 }
        return target
    }
    
}


class CustomCollectionFlowLayout: UICollectionViewFlowLayout {
    
    private var previousOffset: CGFloat = 0
    var currentPage: Int = 0
    
    override init() {
        super.init()
        scrollDirection = .horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
/*
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        print(proposedContentOffset.x)
////        guard abs(velocity.x) < 0.1 else {
////            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
////        }
//
//        guard let collectionView = self.collectionView else {
//            return CGPoint.zero
//        }
//
//        guard let itemsCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0) else {
//            return CGPoint.zero
//        }
//
//        if (previousOffset > collectionView.contentOffset.x)  {
//            currentPage = max(currentPage - 1, 0)
//        } else if (previousOffset < collectionView.contentOffset.x)  {
//            let scrolledPages = round((proposedContentOffset.x - previousOffset)/(itemSize.width + minimumLineSpacing))
//            currentPage = min(currentPage + Int(scrolledPages), itemsCount - Int(scrolledPages));
////            let index = IndexPath(item: currentPage, section: 0)
////            collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
//        }
//
//        let itemEdgeOffset: CGFloat = (collectionView.frame.width - itemSize.width -  minimumLineSpacing * 2) / 2
//        let updatedOffset: CGFloat = (itemSize.width + minimumLineSpacing) * CGFloat(currentPage) - (itemEdgeOffset + minimumLineSpacing);
//
//        previousOffset = updatedOffset;
//
//        return CGPoint(x: updatedOffset, y: proposedContentOffset.y)
       return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
   }
    */
    
    /* //govno
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x
        let targetRect = CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: self.collectionView!.bounds.size)
        
        for layoutAttributes in super.layoutAttributesForElements(in: targetRect)! {
            let itemOffset = layoutAttributes.frame.origin.x
            if (abs(itemOffset - horizontalOffset) < abs(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
 */
    
 /*    //variant + -
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        // Page width used for estimating and calculating paging.
        let pageWidth = self.itemSize.width + self.minimumLineSpacing
        
        // Make an estimation of the current page position.
        let approximatePage = self.collectionView!.contentOffset.x/pageWidth
        
        // Determine the current page based on velocity.
        let currentPage = (velocity.x < 0.0) ? floor(approximatePage) : ceil(approximatePage)
        
        // Create custom flickVelocity.
        let flickVelocity = velocity.x * 0.3
        
        // Check how many pages the user flicked, if <= 1 then flickedPages should return 0.
        let flickedPages = (abs(round(flickVelocity)) <= 1) ? 0 : round(flickVelocity)
        
        // Calculate newHorizontalOffset.
        let newHorizontalOffset = ((currentPage + flickedPages) * pageWidth) - self.collectionView!.contentInset.left
        
        return CGPoint(x: newHorizontalOffset, y: proposedContentOffset.y)
    }
    */
    
}


