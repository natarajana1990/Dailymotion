//
//  Interactor.swift
//  DailyMotion
//
//  Created by Natarajan on 04/10/20.
//  Copyright © 2020 Natarajan. All rights reserved.
//

import UIKit

class Interactor: InteractorProtocol {
    weak var presenter: PresenterProtocol?
    private lazy var networkManager: NetworkManager = {
        return NetworkManager()
    }()

    func downloadImage(url: String?, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        self.networkManager.downloadImage(url: url) { (image, error) in
            completion(image, error)
        }
    }
    
    func downloadVideoList(page: Int, completion: @escaping (_ listOfVideos: Videos?, _ error: Error? ) -> Void) {
        self.networkManager.downloadVideoList(page: page) { (listOfVideos, error) in
            completion(listOfVideos, error)
        }
    }
}
