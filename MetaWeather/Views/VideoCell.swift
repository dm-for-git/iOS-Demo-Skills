//
//  VideoViewController.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/13/21.
//

import UIKit

class VideoCell: UICollectionViewCell {
    
    var videoThumbnail: (imgUrl: String?, videoUrl: String?) {
        didSet {
            imgThumbnail.load(strUrl: videoThumbnail.imgUrl ?? "")
        }
    }
    
    
    @IBOutlet weak var imgThumbnail: ImageViewLoader!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Custom UI here
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
    }

}
