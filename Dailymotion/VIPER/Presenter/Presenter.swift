//
//  Presenter.swift
//  DailyMotion
//
//  Created by Natarajan on 04/10/20.
//  Copyright © 2020 Natarajan. All rights reserved.
//

import UIKit

class Presenter: PresenterProtocol {
    weak var view: ViewProtocol?
    var interactor: InteractorProtocol?
    var wireFrame: RouterProtocol?
    
// MARK: Controllers
    func playVideo(videoId:String) {
        wireFrame?.playVideo(videoId: videoId, fromViewController: view)
    }
 
// MARK: Business Logic
    func downloadImage(url: String?, completion: @escaping (UIImage?, Error?) -> Void) {
        interactor?.downloadImage(url: url, completion: { image, error in
            completion(image, error)
        })
    }

    func downloadVideoList(page: Int, completion: @escaping (_ listOfVideos: Videos?, _ error: Error? ) -> Void) {
        interactor?.downloadVideoList(page: page, completion: { listOfVideos, error in
            completion(listOfVideos, error)
        })
    }
}

