import UIKit

class KeyboardNotificationCenter {
    static let shared = KeyboardNotificationCenter()
    
    private weak var keyboardWillShowNotificationToken: NSObjectProtocol?
    private weak var keyboardWillHideNotificationToken: NSObjectProtocol?
    private weak var keyboardWillChangeFrameNotificationToken: NSObjectProtocol?
    
    private weak var keyboardDidShowNotificationToken: NSObjectProtocol?
    private weak var keyboardDidHideNotificationToken: NSObjectProtocol?
    private weak var keyboardDidChangeFrameNotificationToken: NSObjectProtocol?

    deinit {
        if let token = keyboardWillShowNotificationToken {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = keyboardWillHideNotificationToken {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = keyboardWillChangeFrameNotificationToken {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = keyboardDidShowNotificationToken {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = keyboardDidHideNotificationToken {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = keyboardDidChangeFrameNotificationToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    private init() {
        keyboardWillShowNotificationToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main, using: didReceive(notification:))
        keyboardWillHideNotificationToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main, using: didReceive(notification:))
        keyboardWillChangeFrameNotificationToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main, using: didReceive(notification:))
        
        keyboardDidShowNotificationToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main, using: didReceive(notification:))
        keyboardDidHideNotificationToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main, using: didReceive(notification:))
        keyboardDidChangeFrameNotificationToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidChangeFrameNotification, object: nil, queue: .main, using: didReceive(notification:))
    }
    
    private func didReceive(notification: Notification) {
        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            print("keyboardWillShowNotification")
            guard let userInfo = notification.userInfo else { return }
            guard let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            guard let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
            guard let animationCurveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
                let animationCurve = UIView.AnimationCurve(rawValue: animationCurveValue) else { return }
            let context = KeyboardContext(frame: frame, animationDuration: animationDuration, animationCurve: animationCurve)
            keyboardWillShowHandler?(context)
        case UIResponder.keyboardWillHideNotification:
            print("keyboardWillHideNotification")
            guard let userInfo = notification.userInfo else { return }
            guard let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            guard let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
            guard let animationCurveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
                let animationCurve = UIView.AnimationCurve(rawValue: animationCurveValue) else { return }
            let context = KeyboardContext(frame: frame, animationDuration: animationDuration, animationCurve: animationCurve)
            keyboardWillHideHandler?(context)
        case UIResponder.keyboardWillChangeFrameNotification:
            print("keyboardWillChangeFrameNotification")
            guard let userInfo = notification.userInfo else { return }
            guard let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            guard let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
            guard let animationCurveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
                let animationCurve = UIView.AnimationCurve(rawValue: animationCurveValue) else { return }
            let context = KeyboardContext(frame: frame, animationDuration: animationDuration, animationCurve: animationCurve)
            keyboardWillChangeFrameHandler?(context)
        case UIResponder.keyboardDidShowNotification:
            print("keyboardDidShowNotification")
            guard let userInfo = notification.userInfo else { return }
            guard let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            guard let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
            guard let animationCurveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
                let animationCurve = UIView.AnimationCurve(rawValue: animationCurveValue) else { return }
            let context = KeyboardContext(frame: frame, animationDuration: animationDuration, animationCurve: animationCurve)
            keyboardDidShowHandler?(context)
        case UIResponder.keyboardDidHideNotification:
            print("keyboardDidHideNotification")
            guard let userInfo = notification.userInfo else { return }
            guard let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            guard let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
            guard let animationCurveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
                let animationCurve = UIView.AnimationCurve(rawValue: animationCurveValue) else { return }
            let context = KeyboardContext(frame: frame, animationDuration: animationDuration, animationCurve: animationCurve)
            keyboardDidHideHandler?(context)
        case UIResponder.keyboardDidChangeFrameNotification:
            print("keyboardDidChangeFrameNotification")
            guard let userInfo = notification.userInfo else { return }
            guard let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            guard let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
            guard let animationCurveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
                let animationCurve = UIView.AnimationCurve(rawValue: animationCurveValue) else { return }
            let context = KeyboardContext(frame: frame, animationDuration: animationDuration, animationCurve: animationCurve)
            keyboardDidChangeFrameHandler?(context)
        default: break
        }
    }
    
    struct KeyboardContext {
        var frame: CGRect
        var animationDuration: Double
        var animationCurve: UIView.AnimationCurve
    }
    
    typealias KeyboardHandler = (KeyboardContext) -> Void
    var keyboardWillShowHandler: KeyboardHandler?
    var keyboardWillHideHandler: KeyboardHandler?
    var keyboardWillChangeFrameHandler: KeyboardHandler?
    
    var keyboardDidShowHandler: KeyboardHandler?
    var keyboardDidHideHandler: KeyboardHandler?
    var keyboardDidChangeFrameHandler: KeyboardHandler?
    
}


public final class KeyboardLayoutGuide: UILayoutGuide {
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public enum DefaultPosition {
        case safeAreaBottom(constant: CGFloat)
        case owningViewBottom(constant: CGFloat)
        
        /**
         Use when custom positioning.
         
         Your anchor will be used following code below.
         
         ```
         KeyboardLayoutGuide.bottomAnchor.constraint(equalTo: `Your Anchor`, constant: constant)
         ```
         */
        case anyAnchor(anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat)
    }
    
    let defaultPosition: DefaultPosition
    
    var topConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    
    public var isAnchoredViewsAnimationEnabled: Bool = true
    
    public init(defaultPosition: DefaultPosition, isAnchoredViewsAnimationEnabled: Bool = true) {
        self.defaultPosition = defaultPosition
        self.isAnchoredViewsAnimationEnabled = isAnchoredViewsAnimationEnabled
        super.init()
        
        identifier = "KeyboardLayoutGuide"
        
        KeyboardNotificationCenter.shared.keyboardWillShowHandler = { [weak self] (context) -> Void in
            guard let me = self else { return }
            me.layoutVisibility(context: context, isHidden: false)
        }
        
        KeyboardNotificationCenter.shared.keyboardWillHideHandler = { [weak self] (context) -> Void in
            guard let me = self else { return }
            me.layoutVisibility(context: context, isHidden: true)
        }
        
        KeyboardNotificationCenter.shared.keyboardWillChangeFrameHandler = { [weak self] (context) -> Void in
            guard let me = self else { return }
            me.layoutFrameChange(context: context)
        }
        
        KeyboardNotificationCenter.shared.keyboardDidShowHandler = { [weak self] (context) -> Void in
            guard let me = self else { return }
            if UIDevice.current.userInterfaceIdiom == .pad {
                me.layoutVisibility(context: context, isHidden: false)
            }
        }
        
        KeyboardNotificationCenter.shared.keyboardDidHideHandler = { [weak self] (context) -> Void in
            guard let me = self else { return }
            if UIDevice.current.userInterfaceIdiom == .pad {
                me.layoutVisibility(context: context, isHidden: true)
            }
        }
        
        KeyboardNotificationCenter.shared.keyboardDidChangeFrameHandler = { [weak self] (context) -> Void in
            guard let me = self else { return }
            if UIDevice.current.userInterfaceIdiom == .pad {
                me.layoutFrameChange(context: context)
            }
        }
        
    }
    
    func layoutVisibility(context: KeyboardNotificationCenter.KeyboardContext, isHidden: Bool) {
        guard let view = self.owningView else { return }
        
        switch (isHidden, isAnchoredViewsAnimationEnabled) {
        case (true, true):
            topConstraint?.isActive = false
            bottomConstraint?.isActive = true
            heightConstraint?.constant = 0
            view.layoutIfNeeded()
        case (true, false):
            topConstraint?.isActive = false
            bottomConstraint?.isActive = true
            heightConstraint?.constant = 0
            UIView.animate(withDuration: context.animationDuration,
                           delay: 0,
                           options: [.curveEaseInOut],
                           animations: {
                            view.layoutIfNeeded()
            },
                           completion: nil)
        case (false, true):
            view.layoutIfNeeded()
            
            topConstraint?.constant = context.frame.minY
            heightConstraint?.constant = context.frame.height
            bottomConstraint?.isActive = false
            topConstraint?.isActive = true
            
            UIView.animate(withDuration: context.animationDuration,
                           delay: 0,
                           options: [.curveEaseInOut],
                           animations: {
                            view.layoutIfNeeded()
            },
                           completion: nil)
        case (false, false):
            topConstraint?.constant = context.frame.minY
            heightConstraint?.constant = context.frame.height
            bottomConstraint?.isActive = false
            topConstraint?.isActive = true
            view.layoutIfNeeded()
        }
    }
    
    private func layoutFrameChange(context: KeyboardNotificationCenter.KeyboardContext) {
        guard let view = self.owningView else { return }
        
//        if isAnchoredViewsAnimationEnabled {
//            view.layoutIfNeeded()
//
//            topConstraint?.constant = context.frame.minY
//            heightConstraint?.constant = context.frame.height
//            bottomConstraint?.isActive = false
//            topConstraint?.isActive = true
//
//            UIView.animate(withDuration: context.animationDuration,
//                           delay: 0,
//                           options: [.curveEaseInOut],
//                           animations: {
//                            view.layoutIfNeeded()
//            },
//                           completion: nil)
//        } else {
//            topConstraint?.constant = context.frame.minY
//            heightConstraint?.constant = context.frame.height
//            bottomConstraint?.isActive = false
//            topConstraint?.isActive = true
//            view.layoutIfNeeded()
//        }
    }
    
}

public protocol KeyboardLayoutSupporting {}

public extension KeyboardLayoutSupporting where Self: UIViewController {
    
    var keyboardLayoutGuide: KeyboardLayoutGuide {
        guard let view = view else { fatalError("KeyboardLayoutGuide not found because view is nil.") }
        
        if let layoutGuide = view.layoutGuides.first(where: { (element) -> Bool in return element is KeyboardLayoutGuide }) as? KeyboardLayoutGuide {
            if layoutGuide.heightConstraint == nil {
                switch layoutGuide.defaultPosition {
                case .safeAreaBottom(constant: let constant):
                    layoutGuide.topConstraint = layoutGuide.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
                    layoutGuide.topConstraint?.isActive = false
                    if #available(iOS 11.0, *) {
                        layoutGuide.bottomConstraint = layoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: constant)
                        layoutGuide.bottomConstraint?.isActive = true
                    } else {
                        layoutGuide.bottomConstraint = layoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
                        layoutGuide.bottomConstraint?.isActive = true
                    }
                    layoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
                    layoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
                    layoutGuide.heightConstraint = layoutGuide.heightAnchor.constraint(equalToConstant: 0)
                    layoutGuide.heightConstraint?.isActive = true
                case .owningViewBottom(constant: let constant):
                    layoutGuide.topConstraint = layoutGuide.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
                    layoutGuide.topConstraint?.isActive = false
                    layoutGuide.bottomConstraint = layoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)
                    layoutGuide.bottomConstraint?.isActive = true
                    layoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
                    layoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
                    layoutGuide.heightConstraint = layoutGuide.heightAnchor.constraint(equalToConstant: 0)
                    layoutGuide.heightConstraint?.isActive = true
                case .anyAnchor(anchor: let anchor, constant: let constant):
                    layoutGuide.topConstraint = layoutGuide.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
                    layoutGuide.topConstraint?.isActive = false
                    layoutGuide.bottomConstraint = layoutGuide.bottomAnchor.constraint(equalTo: anchor, constant: constant)
                    layoutGuide.bottomConstraint?.isActive = true
                    layoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
                    layoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
                    layoutGuide.heightConstraint = layoutGuide.heightAnchor.constraint(equalToConstant: 0)
                    layoutGuide.heightConstraint?.isActive = true
                }
            }
            return layoutGuide
        } else {
            fatalError("KeyboardLayoutGuide not found.")
        }
    }
    
}

public extension KeyboardLayoutSupporting where Self: UIView {
}
