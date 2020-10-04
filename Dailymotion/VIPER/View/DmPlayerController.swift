//
//  ImageListController.swift
//  DailyMotion
//
//  Created by Natarajan on 04/10/20.
//  Copyright © 2020 Natarajan. All rights reserved.
//

import UIKit
import SafariServices
import DailymotionPlayerSDK

class DmPlayerController: UIViewController, ViewProtocol {
    
    var presenter: PresenterProtocol?
    var videoId: String = ""

    fileprivate var isPlayerFullscreen = false
    
    fileprivate lazy var playerViewController: DMPlayerViewController = {
        let parameters: [String: Any] = [
            "fullscreen-action": "trigger_event",
            "sharing-action": "trigger_event"
        ]
        
        let controller = DMPlayerViewController(parameters: parameters, allowPiP: false)
        controller.delegate = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        play()
        toggleFullScreen()
    }
    
    private func setupPlayerViewController() {
        addChild(playerViewController)
        
        let view = playerViewController.view!
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        isPlayerFullscreen = size.width > size.height
        playerViewController.toggleFullscreen()
    }
    
    private func play() {
        playerViewController.load(videoId: self.videoId)
    }
    
    private func closePlayer() {
        playerViewController.pause()
        playerViewController.removeFromParent()
        playerViewController.view!.removeFromSuperview()
    }    
}

// MARK: - Daily Motion Player SDK Delegate
extension DmPlayerController: DMPlayerViewControllerDelegate {
    
    func player(_ player: DMPlayerViewController, didReceiveEvent event: PlayerEvent) {
        switch event {
        case .namedEvent(let name, _) where name == "fullscreen_toggle_requested":
            if(isPlayerFullscreen == false) {
                toggleFullScreen()
            }
            else {
                toggleFullScreen()
                closePlayer()
                self.navigationController?.popViewController(animated: true)
            }
        default:
            break
        }
    }
    
    fileprivate func toggleFullScreen() {
        isPlayerFullscreen = !isPlayerFullscreen
        updateDeviceOrientation()
    }
    
    private func updateDeviceOrientation() {
        let orientation: UIDeviceOrientation = isPlayerFullscreen ? .landscapeLeft : .portrait
        UIDevice.current.setValue(orientation.rawValue, forKey: #keyPath(UIDevice.orientation))
    }
    
    func player(_ player: DMPlayerViewController, openUrl url: URL) {
        let controller = SFSafariViewController(url: url)
        present(controller, animated: true, completion: nil)
    }
    
    func playerDidInitialize(_ player: DMPlayerViewController) {
    }
    
    func player(_ player: DMPlayerViewController, didFailToInitializeWithError error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
}
