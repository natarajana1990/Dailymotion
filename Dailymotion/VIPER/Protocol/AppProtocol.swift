//
//  AppProtocol.swift
//  DailyMotion
//
//  Created by Natarajan on 04/10/20.
//  Copyright © 2020 Natarajan. All rights reserved.
//

import UIKit

protocol ViewProtocol: class {
    
}

protocol RouterProtocol: class {
    func playVideo(videoId: String, fromViewController: ViewProtocol?)
}

protocol PresenterProtocol: class {
    // MARK: Controllers
    func playVideo(videoId: String)

    // MARK: Business Logic
    func downloadImage(url: String?, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void)
    func downloadVideoList(page: Int, completion: @escaping (_ listOfVideos: Videos?, _ error: Error? ) -> Void)
}

protocol InteractorProtocol: class {
    func downloadImage(url: String?, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void)
    func downloadVideoList(page: Int, completion: @escaping (_ listOfVideos: Videos?, _ error: Error? ) -> Void)
}
