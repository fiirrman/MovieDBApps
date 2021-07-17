//
//  MovieGenreTableViewCell.swift
//  MovieDBApps
//
//  Created by Firman Aminuddin on 7/17/21.
//

import UIKit

class MovieGenreTableViewCell: UITableViewCell {

    static let id = "MovieGenreTableViewCell"
    
    let labelTitle = UILabel()
    let labelDesc = UILabel()
    let imageMain = UIImageView()
    
    override func layoutSubviews() {
        imageMain.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.2, height: self.frame.height)
        self.addSubview(imageMain)
        
        let xOrigin = imageMain.frame.width + spaceView
        labelTitle.frame = CGRect(x: xOrigin, y: 0, width: screenWidth - (xOrigin + 10), height: self.frame.height / 2)
        labelTitle.font = UIFont.boldSystemFont(ofSize: 15)
        labelTitle.numberOfLines = 2
//        labelTitle.adjustsFontSizeToFitWidth = true
        labelTitle.textColor = .black
        self.addSubview(labelTitle)
        
        labelDesc.frame = CGRect(x: xOrigin, y: labelTitle.frame.height, width: labelTitle.frame.width, height: labelTitle.frame.height)
        labelDesc.font = UIFont.systemFont(ofSize: 14)
        labelDesc.adjustsFontSizeToFitWidth = true
        labelDesc.textColor = .black
        self.addSubview(labelDesc)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
