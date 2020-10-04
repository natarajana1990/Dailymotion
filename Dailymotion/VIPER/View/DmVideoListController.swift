//
//  ImageListController.swift
//  DailyMotion
//
//  Created by Natarajan on 04/10/20.
//  Copyright © 2020 Natarajan. All rights reserved.
//

import UIKit

@IBDesignable class VideoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
}

@IBDesignable class DmVideoListController: UICollectionViewController, ViewProtocol {
    var presenter: PresenterProtocol?
    private var footerView: UICollectionReusableView? = nil
    private var videos: Videos? = nil
    private var isDownloading: Bool = false
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private let video_cell_reuse_identifier = "VIDEO_CELL_REUSE_IDENTIFIER"
    private let video_cell_header_reuse_identifier = "VIDEO_CELL_HEADER_REUSE_IDENTIFIER"
    private let video_cell_footer_reuse_identifier = "VIDEO_CELL_FOOTER_REUSE_IDENTIFIER"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        Router.initializeViperToVideoListController(videoListController: self)
        downloadVideos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    fileprivate func downloadVideos() {
        isDownloading = true
        let pageIndex = (videos?.page ?? 0) + 1
        presenter?.downloadVideoList(page: pageIndex, completion: { [weak self] (videos, error) in
            
            let loader = self?.footerView?.viewWithTag(100) as? UIActivityIndicatorView
            loader?.stopAnimating()

            self?.isDownloading = false

            if(error != nil) {
                self?.showErrorPopup(errorMsg: error?.localizedDescription)
                return
            }
            
            self?.appendVideos(videos)
            self?.collectionView.reloadData()
        })
    }
    
    private func appendVideos(_ videos: Videos?) {
        guard let tmpVideos = videos else {
            return
        }

        if(self.videos == nil) {
            self.videos = tmpVideos
        }
        else if(videos != nil) {
            self.videos?.page = tmpVideos.page
            self.videos?.has_more = tmpVideos.has_more
            if(tmpVideos.list != nil) {
                self.videos?.list?.append(contentsOf: tmpVideos.list!)
            }
        }
    }
    
    private func showErrorPopup(errorMsg: String?) {
        let alertController = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
    }
}

// MARK: - UIScrollView Methods
extension DmVideoListController {
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        guard let tmpVideos = videos else {
            return
        }

        if tmpVideos.has_more == true && isDownloading == false {
            let loader = self.footerView?.viewWithTag(100) as? UIActivityIndicatorView
            loader?.startAnimating()
            downloadVideos()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension DmVideoListController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videos?.list?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: video_cell_reuse_identifier, for: indexPath) as! VideoCell
        cell.backgroundColor = .black

        let tmpVideoInfo = videos?.list?[indexPath.row]
        cell.imageView.image = nil
        cell.titleView.text = tmpVideoInfo?.title
        cell.activityIndicator.startAnimating()

        presenter?.downloadImage(url: tmpVideoInfo?.thumbnail_240_url, completion: { (image, error) in
            cell.activityIndicator.stopAnimating()
            cell.imageView.image = image
        })
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tmpVideoInfo = videos?.list?[indexPath.row]
        guard let tmpVideoId = tmpVideoInfo?.id else {
            return
        }
        presenter?.playVideo(videoId: tmpVideoId)
    }
}

// MARK: - Collection View Flow Layout Delegate
extension DmVideoListController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.safeAreaLayoutGuide.layoutFrame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: video_cell_footer_reuse_identifier, for: indexPath as IndexPath)
            footerView = aFooterView;
            return aFooterView
        }
        else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: video_cell_header_reuse_identifier, for: indexPath as IndexPath)
            return headerView
        }
    }
}
