//
//  DCUI
//

import UIKit

open class ZoomBox: NSObject {
    
    fileprivate static let cacheKey = "ZoomBoxBlur"
    
    open var image: UIImage? {
        didSet {
            reloadBlur()
        }
    }
    
    fileprivate var blurKey: String?
    fileprivate let numberOfBlurFrames = 10
    fileprivate let maxBlurOffset: CGFloat = 100
    
    open var onBlurImageUpdated: ((UIImage?, CGFloat) -> Void)? {
        didSet {
            reloadBlur()
        }
    }
    
    fileprivate var contentTop: NSLayoutConstraint?
    @IBOutlet open weak var scrollView: UIScrollView? {
        didSet {
            reload()
        }
    }
    fileprivate var connected = false
    
    @IBOutlet open weak var containerView: UIView? {
        didSet {
            reload()
        }
    }
    @IBOutlet open weak var contentView: UIView? {
        didSet {
            reload()
        }
    }
    
    deinit {
        clear()
    }
    
    override public init() {
        super.init()
        _ = Cache.initialize(ZoomBox.cacheKey, options: CacheOptions(converter: CacheImageConverter(type: .JPEG)))
    }
    
    open func clear() {
        guard connected else {return}
        scrollView?.removeObserver(self, forKeyPath: "contentOffset")
        connected = false
    }
    
    func connect() -> Bool {
        guard !connected else {return false}
        guard let scrollView = scrollView else {return false}
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        connected = true
        return true
    }
    
    open func reload() {
        guard let containerView = containerView else {return}
        guard let contentView = contentView else {return}
        clear()
        guard connect() else {return}
//        guard containerView.isPreparedForConstraints() else {return}
        containerView.superview?.clipsToBounds = false
        containerView.clipsToBounds = false
        contentView.clipsToBounds = true
        contentView.removeConstraints(contentView.constraints)
        contentView.removeFromSuperview()
        contentView.frame = CGRect(x: 0, y: 0, width: containerView.width, height: containerView.height)
        containerView.addSubview(contentView)
        containerView.removeConstraints(containerView.constraints)
        contentTop = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
        containerView.addConstraints([
            contentTop!,
            NSLayoutConstraint(item: contentView, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentView, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0),
        ])
    }
    
    fileprivate func cacheItemKey(_ index: Int) -> String? {
        guard let key = blurKey else {return nil}
        return "\(key)_\(index)"
    }
    
    fileprivate func cacheItem(_ index: Int) -> UIImage? {
        return Cache.named(ZoomBox.cacheKey)[cacheItemKey(index)] as? UIImage
    }
    
    fileprivate func reloadBlur() {
        guard let image = image else {
            blurKey = nil
            return
        }
        blurKey = image.jpegData(compressionQuality: 0.2)?.base64EncodedString(options: .lineLength64Characters).MD5
        guard blurKey != nil else {return}
        if cacheItem(0) == nil {
            for i in 0...numberOfBlurFrames {
                Cache.named(ZoomBox.cacheKey)[cacheItemKey(i)] = image.blured(level: i.toCGFloat())
            }
        }
        onBlurImageUpdated?(cacheItem(numberOfBlurFrames - 1), 0)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let offset = scrollView?.contentOffset.y else {return}
        guard offset <= 0 else {return}
        contentTop?.constant = offset
        containerView?.layoutIfNeeded()
        if blurKey != nil {
            var blurOffset: CGFloat = -offset
            if blurOffset < 0 {
                blurOffset = 0
            } else if blurOffset > maxBlurOffset {
                blurOffset = maxBlurOffset
            }
            onBlurImageUpdated?(cacheItem(((maxBlurOffset - blurOffset)/numberOfBlurFrames.toCGFloat()).toInt()), blurOffset/maxBlurOffset)
        }
    }
    
}
