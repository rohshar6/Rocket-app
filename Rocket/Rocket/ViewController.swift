//
//  ViewController.swift
//  Rocket
//
//  Created by Rohit sharma(rohshar6).
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var spaceShipImage: UIImageView!
    @IBOutlet weak var launchButtton: UIButton!
    
    var spaceShipTracker: SpaceShipStatus = .readyForLaunch
    var animationSessionIsActive: Bool = false
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shouldSetupButtonAppearance()
        audioPlayer()
    }
    
    func shouldSetupButtonAppearance() {
        launchButtton.setTitle("Launch", for: .normal)
        launchButtton.layer.cornerRadius = 25
    }
    
    
    @IBAction func launchButtonAction(_ sender: Any) {
        switch spaceShipTracker {
        case .launched:
            animateSpaceShip(yValue: .zero)
            audioPlayer()
        case .readyForLaunch:
            animateSpaceShip(yValue: -UIScreen.main.bounds.height)
            playRocket()
        }
    }
    
    func animateSpaceShip(yValue: CGFloat) {
        if !animationSessionIsActive {
            animationSessionIsActive = true
            UIView.animate(withDuration: 3.0, delay: .zero, options: .curveEaseIn) {
                self.spaceShipImage.transform = CGAffineTransform(translationX: .zero, y: yValue)
            } completion: {[unowned self] (success) in
                if success {
                    if self.spaceShipTracker == .readyForLaunch {
                        self.launchButtton.setTitle("Land Rocket", for: .normal)
                        self.spaceShipTracker = .launched
                        self.animationSessionIsActive = false
                    } else {
                        self.launchButtton.setTitle("Launch", for: .normal)
                        self.spaceShipTracker = .readyForLaunch
                        self.animationSessionIsActive = false
                    }
                }
            }
        }
    }
    
    private func audioPlayer() {
        guard let backgroundAudioTrack = Bundle.main.url(forResource: "spaceBackground", withExtension: "wav") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: backgroundAudioTrack)
            player?.play()
            player?.volume = 1
        } catch let error {
            print(error)
        }
    }
    
    private func playRocket() {
        if player != nil {
            player?.stop()
        }
        guard let backgroundAudioTrack = Bundle.main.url(forResource: "rocketLaunch", withExtension: "wav") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: backgroundAudioTrack)
            player?.play()
            player?.volume = 1
        } catch let error {
            print(error)
        }
    }
}

enum SpaceShipStatus {
    case readyForLaunch, launched
}
