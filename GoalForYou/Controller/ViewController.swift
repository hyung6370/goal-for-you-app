//
//  ViewController.swift
//  GoalForYou
//
//  Created by KIM Hyung Jun on 2023/08/20.
//

import UIKit
import Lottie

class ViewController: UIViewController {
    
    @IBOutlet weak var lottieView: LottieAnimationView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lottieAnimation()
        configureUI()
    }
    
    func lottieAnimation() {
        let animationView = LottieAnimationView(name: "animation")
        animationView.contentMode = .scaleAspectFit
                
        lottieView.addSubview(animationView)
        animationView.frame = lottieView.bounds
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func configureUI() {
        loginButton.layer.cornerRadius = 20
        loginButton.clipsToBounds = true
        
        registerButton.layer.cornerRadius = 20
        registerButton.clipsToBounds = true
    }
    
    

    
}

