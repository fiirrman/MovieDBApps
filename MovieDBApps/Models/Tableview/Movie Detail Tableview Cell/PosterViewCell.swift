//
//  PosterViewCell.swift
//  MovieDBApps
//
//  Created by Firman Aminuddin on 7/17/21.
//

import UIKit

class PosterViewCell: UITableViewCell {
    
    static let id = "PosterViewCell"
    
    let imageBase = UIImageView()
    
    override func layoutSubviews() {
        imageBase.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.frame.height)
        imageBase.contentMode = .scaleAspectFit
        self.addSubview(imageBase)
    }
}
