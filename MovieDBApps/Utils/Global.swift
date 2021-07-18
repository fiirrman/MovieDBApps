//
//  Global.swift
//  MovieDBApps
//
//  Created by Firman Aminuddin on 7/16/21.
//

import Foundation
import UIKit

let screenSize = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height
let appDelegate = UIApplication.shared.delegate as! AppDelegate
var loadingBlock = Create.indicator(blocking: true) // LOADING VIEW
let userDefaults = UserDefaults()
let spaceView = screenWidth * 0.05

// MARK: API
let apiKey = "0d062fd54ed6262ae8abb99286795ebf"
let apiKeyForm = "?api_key=0d062fd54ed6262ae8abb99286795ebf&language=en-US"
let url_image = "https://image.tmdb.org/t/p/w500/"
let url_main = "https://api.themoviedb.org/3/"
let url_authSession = url_main + "authentication/guest_session/new?api_key=" + apiKey
let url_deleteSession = url_main + "authentication/session?api_key=" + apiKey
let url_getListGenre = url_main + "genre/movie/list?api_key=" + apiKey + "&language=en-US"
let url_getMovieByGenre = url_main + "discover/movie?api_key=" + apiKey + "&language=en-US" + "&with_genres="
let url_getMovieDetail = url_main + "movie/"
let url_getMovieVideo = url_main + "movie/"

// MARK: KEY
let guestSessionKey = "guestSessionKey"
let genreListKey = "genreListKey"
let movieListKey = "movieListKey"
let detailListKey = "detailListKey"

// MARK: KEY ENTITY
let entityGenre = "CDMovieGenre"
let entityMovieByGenre = "CDMovieByGenre"
let entityMovieDetail = "CDMovieDetail"

let jsonTest = """
{
    "genres": [
        {
            "id": 28,
            "name": "Action"
        },
        {
            "id": 12,
            "name": "Adventure"
        },
        {
            "id": 16,
            "name": "Animation"
        },
        {
            "id": 35,
            "name": "Comedy"
        },
        {
            "id": 80,
            "name": "Crime"
        },
        {
            "id": 99,
            "name": "Documentary"
        },
        {
            "id": 18,
            "name": "Drama"
        },
        {
            "id": 10751,
            "name": "Family"
        },
        {
            "id": 14,
            "name": "Fantasy"
        },
        {
            "id": 36,
            "name": "History"
        },
        {
            "id": 27,
            "name": "Horror"
        },
        {
            "id": 10402,
            "name": "Music"
        },
        {
            "id": 9648,
            "name": "Mystery"
        },
        {
            "id": 10749,
            "name": "Romance"
        },
        {
            "id": 878,
            "name": "Science Fiction"
        },
        {
            "id": 10770,
            "name": "TV Movie"
        },
        {
            "id": 53,
            "name": "Thriller"
        },
        {
            "id": 10752,
            "name": "War"
        },
        {
            "id": 37,
            "name": "Western"
        }
    ]
}
"""

// MARK: EXTENSION
extension UIViewController{
    // DOWNLOAD IMAGE ============
    func downloadImage(_ link: String?, linkwithCompletion completion: @escaping (UIImage?)->()) {
        guard let url = try? link?.asURL() else { // SWIFT 5
            completion(UIImage())
            return
        }
        let imageURL = url
        
        let task = URLSession.shared.dataTask(with: imageURL) { (data, responce, _) in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            }else{
                completion(UIImage.init(named: "image"))
            }
        }
        task.resume()
    }
    
    // NAVIGATE PAGE
    func navigatePage(typePage : UIViewController){
        let newViewController = typePage
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    // CRED SAVE
    func credentialSave(val : String, key : String, type : String){
        if(type == "save"){
            userDefaults.setValue(val, forKey: key)
        }else{
            userDefaults.value(forKey: key)
        }
    }
    
    // SHOW ALERT ===========
    func showErrorAlert(errorMsg : String, isAction : Bool, title : String, typeAlert : String){
        let msg = title
        let ac = UIAlertController(title: msg, message: errorMsg, preferredStyle: .alert)
        if(isAction){
            let stringOK = "OK"
            
            // Create the actions
            let okAction = UIAlertAction(title: stringOK, style: UIAlertAction.Style.default) {
                UIAlertAction in
                if(typeAlert == "alertSessionCreate"){
                    self.toHomePage()
                }else if(typeAlert == "alertLoadMoreMovies"){
                    self.loadMoreMovies()
                }else if(typeAlert == "alertLoadMoreReview"){
                    self.loadMoreReview()
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                if(typeAlert == "alertLoadMoreMovies" || typeAlert == "alertLoadMoreReview"){
//                    spinnerTable.stopAnimating()
                }else{
                    self.noFunction()
                }
                NSLog("Cancel Pressed")
            }
            
            ac.addAction(okAction)
            if(typeAlert != "alertSessionCreate"){
                ac.addAction(cancelAction)
            }
        }else{
            ac.addAction(UIAlertAction(title: "OK", style: .default))
        }
        
        self.present(ac, animated:  true)
    }
    
    func noFunction(){}
    @objc func toHomePage(){}
    @objc func loadMoreMovies(){}
    @objc func loadMoreReview(){}
}

// MARK: STRUCT
struct Create {
    static func indicator(blocking:Bool) -> UIView {
        let indicatorView:UIActivityIndicatorView = UIActivityIndicatorView(style:UIActivityIndicatorView.Style.whiteLarge);
        indicatorView.frame.origin.x = screenWidth/2-indicatorView.frame.size.width/2;
        indicatorView.startAnimating();
        indicatorView.layer.cornerRadius=10.0;
        indicatorView.frame.size.width = indicatorView.frame.size.width*2;
        indicatorView.frame.size.height = indicatorView.frame.size.height*2;
        indicatorView.backgroundColor = UIColor.black.withAlphaComponent(0.7);
        indicatorView.center.x = screenWidth/2;
        indicatorView.center.y = screenHeight/2;
        if(blocking) {
            let view:UIView = UIView(frame:CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight));
            view.backgroundColor=UIColor.clear;
            view.addSubview(indicatorView);
            return view;
        }
        else {
            return indicatorView;
        }
    }
}
