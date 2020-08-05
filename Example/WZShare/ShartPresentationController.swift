//
//  ShartPresentationController.swift
//  WZShare_Example
//
//  Created by xiaobin liu on 2020/5/2.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

/// MARK - ShartPresentationController
public final class ShartPresentationController: UIPresentationController {

    /// 隐藏
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.alpha = 0.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(Self.dimmingViewTapped(_:)))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private let height: CGFloat

    /// 初始化
    public init(presentedViewController: UIViewController,
                         presenting presentingViewController: UIViewController?,
                         height: CGFloat) {
        self.height = height
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
    }

    /// presentationTransitionWillBegin
    override public func presentationTransitionWillBegin() {
        self.dimmingView.frame = containerView!.bounds
        self.dimmingView.alpha = 0.0
        self.containerView?.insertSubview(self.dimmingView, at: 0)

        let animations = {
            self.dimmingView.alpha = 1.0
        }

        if let transitionCoordinator = self.presentingViewController.transitionCoordinator {

            transitionCoordinator.animate(alongsideTransition: { _ in
                animations()
            }, completion: nil)
        } else {
            animations()
        }
    }

    /// dismissalTransitionWillBegin
    override public func dismissalTransitionWillBegin() {
        let animations = {
            self.dimmingView.alpha = 0.0
        }

        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { _ in
                animations()
            }, completion: nil)
        } else {
            animations()
        }
    }

    /// UIModalPresentationStyle
    override public var adaptivePresentationStyle: UIModalPresentationStyle {
        .none
    }

    /// shouldPresentInFullscreen
    override public var shouldPresentInFullscreen: Bool {
        true
    }

    /// :nodoc:
    override public func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        CGSize(width: parentSize.width,
               height: round(height))
    }

    /// containerViewWillLayoutSubviews
    override public func containerViewWillLayoutSubviews() {
        self.dimmingView.frame = self.containerView!.bounds
        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
    }

    /// :nodoc:
    override public var frameOfPresentedViewInContainerView: CGRect {
        let size = self.size(forChildContentContainer: presentedViewController,
                             withParentContainerSize: containerView!.bounds.size)
        let origin = CGPoint(x: 0.0, y: self.containerView!.frame.maxY - height)
        return CGRect(origin: origin, size: size)
    }

    // MARK: Private

    @objc
    private func dimmingViewTapped(_ tap: UITapGestureRecognizer) {
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }
}

