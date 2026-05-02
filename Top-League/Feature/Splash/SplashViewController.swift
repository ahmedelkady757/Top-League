//
//  SplashViewController.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 02/05/2026.
//

import UIKit
import Lottie


class SplashViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Start the setup here
        setupLottie()
    }
    func goToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBar = storyboard.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else { return }
        
        // Switch the window's rootViewController so the Splash is removed from memory
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            
            tabBar.modalTransitionStyle = .crossDissolve
            window.rootViewController = tabBar
            
            // Add a nice fade transition
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        }
    }

    func setupLottie() {
        let animationView = LottieAnimationView(name: "SportLoading")
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        view.addSubview(animationView)

        animationView.play { [weak self] (finished) in
            self?.goToHome()
        }
    }
}
