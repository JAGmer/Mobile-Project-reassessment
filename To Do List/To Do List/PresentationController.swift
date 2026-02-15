//
//  PresentationController.swift
//  To Do List
//
//  Created by JAGmer J on 10/02/2026.
//

import UIKit

class PresentationController: UIPresentationController {

    let blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var emptySpace: CGFloat = 0.35
    var viewControllerSpace: CGFloat = 0.50
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        self.blurView.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc func dismissController()
    {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    override func presentationTransitionWillBegin()
    {
        guard let containerView = containerView else { return }
        self.blurView.alpha = 0
        containerView.addSubview(blurView)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: containerView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in self.blurView.alpha = 1.0 } )
    }
    override func dismissalTransitionWillBegin()
    {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { UIViewControllerTransitionCoordinatorContext in
            self.blurView.alpha = 0
        }, completion: { UIViewControllerTransitionCoordinatorContext in
            self.blurView.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews()
    {
        super.containerViewWillLayoutSubviews()
        
        presentedView?.layer.cornerRadius = 20
        presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        presentedView?.layer.masksToBounds = true
        
        /*presentedView!.roundCorners([.topLeft, .topRight], radius: 15)
        presentedView!.layer.masksToBounds = false
        presentedView!.layer.shadowColor = UIColor.black.cgColor
        presentedView!.layer.shadowOpacity = 0.65
        presentedView!.layer.shadowRadius = 20
        presentedView!.layer.shadowOffset = CGSize(width: 0, height: 0)*/
    }
    override func containerViewDidLayoutSubviews()
    {
        super.containerViewDidLayoutSubviews()
        
        presentedView?.frame = frameOfPresentedViewInContainerView
        blurView.frame = containerView!.bounds
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        
        let height = containerView.bounds.height * viewControllerSpace
        let yOrigin = containerView.bounds.height - height
        
        return CGRect(x: 0, y: yOrigin, width: containerView.bounds.width, height: height)
    }
}
extension UIView
{
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat)
    {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
