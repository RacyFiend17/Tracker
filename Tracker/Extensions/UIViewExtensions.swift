import UIKit

extension UIView {
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach({ addSubview($0) })
    }
    
    func translatesAutoResizingMaskFalseTo(_ subviews: [UIView]) {
        subviews.forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })
    }
    
    @discardableResult func edgesToSuperView() -> Self {
        guard let superview = superview else {
                fatalError("View is not in ierarchy!")
        }
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
        
        return self
    }
    
}
