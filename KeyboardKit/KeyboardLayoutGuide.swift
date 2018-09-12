import UIKit

class KeyboardObserver {
    static let shared = KeyboardObserver()
    
    private weak var keyboardWillShowNotificationToken: NSObjectProtocol?
    private weak var keyboardWillHideNotificationToken: NSObjectProtocol?
    private weak var keyboardWillChangeFrameNotificationToken: NSObjectProtocol?
    
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
    }
    
    private init() {
        keyboardWillShowNotificationToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main, using: didReceive(notification:))
        keyboardWillHideNotificationToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main, using: didReceive(notification:))
        keyboardWillChangeFrameNotificationToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main, using: didReceive(notification:))
    }
    
    private func didReceive(notification: Notification) {
        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            print("keyboardWillShowNotification")
            guard let userInfo = notification.userInfo else { return }
            print(userInfo)
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
            print(userInfo)
            guard let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            guard let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
            guard let animationCurveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
                let animationCurve = UIView.AnimationCurve(rawValue: animationCurveValue) else { return }
            let context = KeyboardContext(frame: frame, animationDuration: animationDuration, animationCurve: animationCurve)
            keyboardWillChangeFrameHandler?(context)
        case UIResponder.keyboardDidShowNotification: break
        case UIResponder.keyboardDidHideNotification: break
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
}


// iphone, ipad, split view, split keyboard, third party keyboard.
public final class KeyboardLayoutGuide: UILayoutGuide {
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public enum DefaultPosition {
        case safeAreaBottom(constant: CGFloat)
        case superviewBottom(constant: CGFloat)
        case constraint(constrant: NSLayoutAnchor<NSLayoutYAxisAnchor>)
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
        
        KeyboardObserver.shared.keyboardWillShowHandler = { [weak self] (context) -> Void in
            guard let me = self else { return }
            me.layout(context: context, hide: false)
        }
        
        KeyboardObserver.shared.keyboardWillHideHandler = { [weak self] (context) -> Void in
            guard let me = self else { return }
            me.layout(context: context, hide: true)
        }
        
        KeyboardObserver.shared.keyboardWillChangeFrameHandler = { [weak self] (context) -> Void in
            guard let me = self else { return }
            me.layout(context: context, hide: false)
        }

    }
    
    func layout(context: KeyboardObserver.KeyboardContext, hide: Bool) {
        guard let view = self.owningView else { return }
        
        switch (hide, isAnchoredViewsAnimationEnabled) {
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
            topConstraint?.isActive = true
            bottomConstraint?.isActive = false
            
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
            topConstraint?.isActive = true
            bottomConstraint?.isActive = false
            view.layoutIfNeeded()
        }
    }
    
    
}

public protocol KeyboardLayoutSupporting {}

public extension KeyboardLayoutSupporting where Self: UIViewController {
    
    var keyboardLayoutGuide: KeyboardLayoutGuide {
        guard let view = view else { fatalError("Keyboard Layout Guide not found because view is nil.") }
        
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
                    layoutGuide.heightConstraint = layoutGuide.heightAnchor.constraint(equalToConstant: 100)
                    layoutGuide.heightConstraint?.isActive = true
                case .superviewBottom(constant: let constant):
                    break
                case .constraint(constrant: let anchor):
                    break
                }
            }
            return layoutGuide
        } else {
            fatalError("Keyboard Layout Guide not found because view is nil.")
        }
    }
    
}

public extension KeyboardLayoutSupporting where Self: UIView {
}
