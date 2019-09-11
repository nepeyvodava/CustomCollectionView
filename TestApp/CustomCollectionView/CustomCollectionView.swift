import UIKit

class CustomCollectionView: UICollectionView {
    
    //MARK: - variables
    var minimumLineSpacing: CGFloat = 20
    var itemSize: CGSize { return CGSize(width: frame.height/centerCellScale, height: frame.height/centerCellScale) }
    var centerCellScale: CGFloat = 1.4
    var tempTarget: Int = 0
    var selectedItem: Int = 0 {
        didSet{
            guard itemsQty > 0 else { return }
            let index = IndexPath(item: selectedItem, section: 0)
//            self.selectItem(at: index, animated: true, scrollPosition: .centeredHorizontally)
            self.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            filterDelegate?.itemDidSelected(item: selectedItem)
        }
    }
    let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionLayout = UICollectionViewFlowLayout()
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

private extension CustomCollectionView {
    
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

extension CustomCollectionView: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let target = calculateTarget()
        selectedItem = target
    }
    
//    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        scrollView.setContentOffset(scrollView.contentOffset, animated: true)
//        selectedItem = tempTarget
//    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        tempTarget = calculateTarget(cordinate: targetContentOffset.pointee.x)
//        print("tempTarget: \(tempTarget), velocity: \(velocity.x)")
        guard abs(velocity.x) == 0 else { return }
        let target = calculateTarget()
        selectedItem = target
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        guard decelerate else { return }
//        selectedItem = tempTarget
//    }
    
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
    
    func calculateTarget(cordinate: CGFloat) -> Int {
        guard scrollMaxOffset > 0 else { return 0 }
        let qty = itemsQty - 1
        let target = Int(round(CGFloat(qty) * cordinate/scrollMaxOffset))
        if target > qty { return qty }
        if target < 0 { return 0 }
        return target
    }
}

protocol FilterCollectionDelegate: class {
    
    func itemDidSelected(item: Int)
    
}
