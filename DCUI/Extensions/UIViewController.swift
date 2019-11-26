//
//  UIViewController.swift
//  DCUI
//

import Foundation

public struct KeyboardInfo {
    public let frameBegin      : CGRect
    public let frameEnd        : CGRect
    public let isLocal         : Bool
    public let animationCurve  : Int
    public let duration        : TimeInterval
}

public extension KeyboardInfo {
    
    init(notification: NSNotification) {
        frameBegin      = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        frameEnd        = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        isLocal         = (notification.userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? Bool) ?? true
        animationCurve  = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int) ?? 0
        duration        = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval) ?? 0
    }
    
}

public enum KeyboardConnectionType: String {
    case willShow
    case didShow
    case willHide
    case didHide
    case willChangeFrame
    case didChangeFrame
    
    fileprivate var notification: NSNotification.Name {
        let info: [KeyboardConnectionType:NSNotification.Name] = [
            .willShow           : UIResponder.keyboardWillShowNotification,
            .didShow            : UIResponder.keyboardDidShowNotification,
            .willHide           : UIResponder.keyboardWillHideNotification,
            .didHide            : UIResponder.keyboardDidHideNotification,
            .willChangeFrame    : UIResponder.keyboardWillChangeFrameNotification,
            .didChangeFrame     : UIResponder.keyboardDidChangeFrameNotification,
        ]
        return info[self]!
    }
    
}

public extension UIViewController {
    
    public func connectKeyboard(action: KeyboardConnectionType, _ handler: ((KeyboardInfo) -> Void)?) {
        NotificationAdd(observer: self, name: action.notification) { (ntf) in
            handler?(KeyboardInfo(notification: ntf))
        }
    }
    
    func disconnectKeyboard(action: KeyboardConnectionType? = nil) {
        if let action = action {
            NotificationRemove(observer: self, name: action.notification)
        } else {
            disconnectKeyboard(action: .willShow)
            disconnectKeyboard(action: .didShow)
            disconnectKeyboard(action: .willHide)
            disconnectKeyboard(action: .didHide)
            disconnectKeyboard(action: .willChangeFrame)
            disconnectKeyboard(action: .didChangeFrame)
        }
    }
    
}
