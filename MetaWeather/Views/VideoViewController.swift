//
//  VideoViewController.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/13/21.
//

import UIKit
import AVKit
import SwiftMessages

class VideoViewController: UICollectionViewController {
    private let cellIdentifier = String(describing: VideoCell.self)
    private let footerIdentifier = String(describing: VideoFooterView.self)
    
    private lazy var viewModel: VideoViewModel = {
        return VideoViewModel()
    }()
    
    private var refreshVC: UIRefreshControl?
    
    private var footerView: VideoFooterView?
    
    private var playerViewController: AVPlayerViewController?
    
    private lazy var messageView = {
        return MessageView.viewFromNib(layout: .cardView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingView.shared.startLoadingVia(parentView: view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkSubscriber),
                                               name: .networkStatus, object: nil)
        
        playerViewController = AVPlayerViewController()
        playerViewController?.delegate = self
        
        // Setup pull to refresh
        refreshVC = UIRefreshControl()
        refreshVC?.tintColor = .cyan
        refreshVC?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        collectionView.refreshControl = refreshVC
        
        
        // Calculate cell layout
        let cellWidth = view.frame.size.width/2 - 16
        let cellHeight = cellWidth * 0.75
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = .zero
            layout.footerReferenceSize = CGSize(width: self.collectionView.frame.size.width, height: 55)
            layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        }
        
        // Register for reusable cell
        collectionView.register(UINib(nibName: cellIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: cellIdentifier)
        // Register footer cell
        collectionView.register(UINib(nibName: footerIdentifier, bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: footerIdentifier)
        
        viewModel.fetchMoreData { [weak self] isSuccess in
            DispatchQueue.main.async {
                if isSuccess {
                    self?.collectionView.reloadData()
                } else {
                    self?.showMessageBaseOn(type: .error, message: String.stringByKey(key: .msgCantLoadData))
                }
                
            }
            LoadingView.shared.stopLoading()
        }
        
    }
    
    // MARK: Data Loading
    @objc private func refreshData(_ sender: Any) {
        refreshVC?.beginRefreshing()
        viewModel.fetchMoreData { [weak self] isSuccess in
            DispatchQueue.main.async {
                if isSuccess {
                    self?.viewModel.isLoadingData = false
                    self?.collectionView.reloadData()
                } else {
                    self?.showMessageBaseOn(type: .error, message: String.stringByKey(key: .msgCantLoadData))
                }
                self?.refreshVC?.endRefreshing()
            }
        }
    }
    
    private func loadMoreData() {
        LoadingView.shared.startLoadingVia(parentView: view)
        viewModel.isLoadingData = true
        viewModel.fetchMoreData { [weak self] isSuccess in
            DispatchQueue.main.async {
                if isSuccess {
                    self?.collectionView.reloadItems(at: [IndexPath(item: self?.viewModel.lastPreviousIndex ?? 0, section: 0)])
                    self?.viewModel.isLoadingData = false
                } else {
                    self?.showMessageBaseOn(type: .error, message: String.stringByKey(key: .msgCantLoadData))
                }
            }
            LoadingView.shared.stopLoading()
        }
    }
    
    // MARK: Utils
    private func showDialog(mess: String, title: String) {
        DispatchQueue.main.async {[unowned self] in
            let alertVC = UIAlertController(title: title, message: mess, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            show(alertVC, sender: nil)
        }
    }
    
    @objc private func networkSubscriber(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Bool] {
            for (key, value) in data {
                if key == "isLost" && value == true {
                    showMessageBaseOn(type: .error, message: String.stringByKey(key: .msgInternetLost))
                }
            }
        }
    }
    
}

// MARK: CollectionView DataSource & Delegate
extension VideoViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.arrThumbnails.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
                as? VideoCell else { return UICollectionViewCell() }
        cell.videoThumbnail = viewModel.arrThumbnails[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if AVPictureInPictureController.isPictureInPictureSupported() {
            guard let videoUrl = viewModel.arrThumbnails[indexPath.item].videoUrl else { return }
            viewModel.currentVideoUrl = videoUrl
            playVideoVia(playerController: playerViewController!)
        } else {
            showDialog(mess: String.stringByKey(key: .errCantPlayInPiP), title: String.stringByKey(key: .dialogTitleError))
        }
    }
    
    // Load more data when user scroll to the end of the screen
    override func collectionView(_ collectionView: UICollectionView, willDisplay
                                 cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.arrThumbnails.count - 1 && !viewModel.isLoadingData {
            viewModel.lastPreviousIndex = viewModel.arrThumbnails.count - 2
            loadMoreData()
        }
    }
    
}


// MARK: CollectionView Layout
extension VideoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let standardSize = CGSize(width: collectionView.frame.size.width, height: 55)
        if viewModel.isLoadingData {
            self.footerView?.frame.size = standardSize
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.footerView?.frame.size = .zero
            }
        }
        return footerView?.frame.size ?? standardSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind
                                 kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            guard let reusableFooterView = collectionView.dequeueReusableSupplementaryView(ofKind:
                                                                                            kind, withReuseIdentifier: footerIdentifier, for: indexPath)
                    as? VideoFooterView else {
                        return UICollectionReusableView()
                    }
            footerView = reusableFooterView
            return footerView!
        }
        return UICollectionReusableView()
    }
    // Animate the indicator of the footer
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView
                                 view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter && viewModel.isLoadingData {
            footerView?.indicatorView.startAnimating()
        }
    }
    // Stop animation of the indicator of the footer
    override func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView
                                 view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            footerView?.indicatorView.stopAnimating()
        }
    }
    
}

// MARK: Video Player

extension VideoViewController: AVPlayerViewControllerDelegate {
    
    func playerViewController(_ playerViewController: AVPlayerViewController,
                              restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        viewModel.currentVideoUrl = ""
        playVideoVia(playerController: playerViewController)
        completionHandler(true)
    }
    
    
    private func playVideoVia(playerController: AVPlayerViewController) {
        playerController.dismiss(animated: false, completion: nil)
        
        if viewModel.currentVideoUrl == "" {
            present(playerController, animated: false, completion: nil)
        } else {
            guard let url = URL(string: viewModel.currentVideoUrl) else {
                showMessageBaseOn(type: .info, message: String.stringByKey(key: .msgCantPlayVideo))
                return
            }
            
            let player = AVPlayer(url: url)
            player.play()
            
            playerController.player = player
            
            present(playerController, animated: false, completion: nil)
        }
    }
}
