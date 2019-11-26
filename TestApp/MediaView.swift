//
//  MediaView.swift
//
//  Created by Igor Danich on 27.06.16.
//  Copyright © 2016 dclife. All rights reserved.
//

import DCUI

@IBDesignable
class MediaView: UIButton {
    
    fileprivate var indicator: UIActivityIndicatorView?
    fileprivate var task: CacheTask?
    var loading = false {
        didSet {
            updateImage()
        }
    }
    @IBInspectable var largeIndicator: Bool = false {
        didSet {
            indicator?.removeFromSuperview()
            indicator = UIActivityIndicatorView(activityIndicatorStyle: largeIndicator ? .whiteLarge : .white)
            indicator?.hidesWhenStopped = true
            indicator?.color = indicatorColor
            addSubview(indicator!)
        }
    }
    
    @IBInspectable var indicatorColor: UIColor? = UIColor.black {
        didSet {
            indicator?.color = indicatorColor
        }
    }
    
    @IBInspectable var defaultImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    @IBInspectable var image: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    var cache = Cache.named("Images")
    
    var onImageUpdated: ((UIImage?) -> UIImage?)?
    
    var url: String? {
        didSet {
            if oldValue == url && image != nil {
                return
            }
            image = nil
            task?.cancel()
            task = nil
            if let task = cache.perform(key: url) {
                loading = true
                self.task = task
                task.onComplete = { [weak self](object,error) in
                    self?.loading = false
                    self?.task = nil
                    if let image = object as? UIImage {
                        if let updated = self?.onImageUpdated {
                            self?.image = updated(image)
                        } else {
                            self?.image = image
                        }
                    } else {
                        self?.image = nil
                    }
                }
            } else {
                loading = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView?.contentMode = .scaleAspectFill
        indicator = UIActivityIndicatorView(activityIndicatorStyle: largeIndicator ? .whiteLarge : .white)
        indicator?.hidesWhenStopped = true
        addSubview(indicator!)
    }
    
    fileprivate func updateImage() {
        if loading {
            indicator?.startAnimating()
            setImage(nil, for: UIControlState())
        } else {
            indicator?.stopAnimating()
            if let image = image {
                setImage(image, for: UIControlState())
            } else {
                setImage(defaultImage, for: UIControlState())
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicator?.center = CGPoint(x: width/2, y: height/2)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: self.width, height: self.height)
    }
    
}
