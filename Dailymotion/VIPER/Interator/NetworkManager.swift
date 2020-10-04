//
//  NetworkManager.swift
//  DailyMotion
//
//  Created by Natarajan on 04/10/20.
//  Copyright © 2020 Natarajan. All rights reserved.
//

import UIKit

enum NetworkError: Error {
    case noNetwork
    case jsonParsingError
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noNetwork:
            return NSLocalizedString("Device not connected with internet", comment: "No Network")
        case .jsonParsingError:
            return NSLocalizedString("Invalid input parameter", comment: "Invalid JSON")
        }
    }
}


class NetworkManager: InteractorProtocol {
    weak var presenter: PresenterProtocol?
    private let imageCache = NSCache<NSString, UIImage>()
    private let videoApiURL = "https://api.dailymotion.com/videos?fields=id,title,thumbnail_240_url"
    
    func downloadImage(url: String?, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        guard let tmpStrURL = url, let tmpURL = URL(string: tmpStrURL) else {
            return
        }
        
        if let cachedImage = imageCache.object(forKey: tmpURL.absoluteString as NSString) {
            completion(cachedImage, nil)
        } else {
            download(url: tmpURL, completion: { (data, error) in
                if let imgData = data, let image = UIImage(data: imgData) {
                    self.imageCache.setObject(image, forKey: tmpURL.absoluteString as NSString)
                    completion(image, nil)
                }
                else {
                    completion(nil, error)
                }
            })
        }
    }
    
    func downloadVideoList(page: Int, completion: @escaping (_ listOfVideos: Videos?, _ error: Error? ) -> Void) {
        let videoListApi = URL(string: videoApiURL+"&page=\(page)")
        download(url: videoListApi!, completion: { (data, error) in
            
            do {
                if(error == nil && data != nil) {
                    let videos = try JSONDecoder().decode(Videos.self, from: data!)
                    completion(videos, nil)
                }
                else {
                    completion(nil, error)
                }
                
            } catch {
                completion(nil, NetworkError.jsonParsingError)
            }
        })
    }
    
    func download(url: URL, completion: @escaping (_ data: Data?, _ error: Error? ) -> Void) {
        if hasNetworkReachability() == false {
            completion(nil, NetworkError.noNetwork)
            return
        }

        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            DispatchQueue.main.async() {    // execute on main thread
                completion(data, error)
            }
        }).resume()
    }
    
    private func hasNetworkReachability() -> Bool {
        let networkRechable = try? Reachability()
        try? networkRechable?.startNotifier()

        var currentStatus = false
        switch (networkRechable?.connection)
        {
        case .wifi?:
            currentStatus = true
            break
        case .cellular?:
            currentStatus = true
            break
        default:
            break
        }
        
        networkRechable?.stopNotifier()
        return currentStatus;
    }

}
