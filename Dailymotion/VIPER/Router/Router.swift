//
//  Router.swift
//  DailyMotion
//
//  Created by Natarajan on 04/10/20.
//  Copyright © 2020 Natarajan. All rights reserved.
//

import UIKit

class Router: RouterProtocol {
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    class func getController(_ controllerName: String) -> UIViewController? {
        let navController = mainStoryboard.instantiateViewController(withIdentifier: controllerName)
        return navController;
    }
    
    class func initializeViperToVideoListController(videoListController: DmVideoListController) {
        let presenter = Presenter()
        let interactor = Interactor()
        let wireFrame = Router()

        videoListController.presenter = presenter
        presenter.view = videoListController
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
    }
    
    func playVideo(videoId: String, fromViewController: ViewProtocol?) {
        if let playerController = Router.getController("VideoPlayerController") as? DmPlayerController {
            let presenter = Presenter()
            let interactor = Interactor()
            let wireFrame = Router()

            playerController.videoId = videoId
            playerController.presenter = presenter
            presenter.view = playerController
            presenter.wireFrame = wireFrame
            presenter.interactor = interactor
            interactor.presenter = presenter

            if let sourceController = fromViewController as? UIViewController {
                sourceController.navigationController?.pushViewController(playerController, animated: true)
            }
        }
    }
}
