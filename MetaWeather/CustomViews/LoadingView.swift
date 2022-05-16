//
//  LoadingView.swift
//  MetaWeather
//
//  Created by David Martin on 26/02/2022.
//

import UIKit
import Lottie

class LoadingView: UIView {
    private let animationView = AnimationView(name: Constants.lottieFileName)
    
    static let shared = LoadingView()
    
    func startLoadingVia(parentView: UIView) {
        stopLoading()
        DispatchQueue.main.async {[weak self] in
            if let animationView = self?.animationView {
                self?.configAnimationBy(view: parentView)
                parentView.addSubview(animationView)
                parentView.bringSubviewToFront(animationView)
                animationView.play(completion: nil)
            }
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {[weak self] in
            if let animationView = self?.animationView {
                animationView.stop()
                animationView.removeFromSuperview()
            }
        }
    }
    
    private func configAnimationBy(view: UIView) {
        var frame = CGRect.zero
        if view.isKind(of: UITableView.self) {
            frame = CGRect(x: view.center.x - 75, y: view.center.y - 350, width: 150, height: 150)
        } else {
            frame = CGRect(x: view.center.x - 75, y: view.center.y - 150, width: 150, height: 150)
        }
        animationView.frame = frame
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
    }
    
}
