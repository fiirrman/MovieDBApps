//
//  GetSessionViewC.swift
//  MovieDBApps
//
//  Created by Firman Aminuddin on 7/17/21.
//

import UIKit
import RxSwift

class GetSessionViewC: UIViewController {
    
    let movieService = MovieService()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        
        setupUI()
//        callAPI()
    }
    
    func setupUI(){
        navigationController?.navigationBar.isHidden = true
        
        let widthBtn = screenWidth * 0.4
        let heightBtn = widthBtn * 0.3
        let btnSession = UIButton.init(frame: CGRect(x: screenWidth / 2 - (widthBtn / 2), y: screenHeight / 2 - (heightBtn / 2), width: widthBtn, height: heightBtn))
        btnSession.setTitle("Generate Session", for: .normal)
        btnSession.titleLabel?.adjustsFontSizeToFitWidth = true
        btnSession.titleLabel?.textColor = .white
        btnSession.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
        btnSession.backgroundColor = .red
        btnSession.layer.cornerRadius = heightBtn * 0.3
        btnSession.addTarget(self, action: #selector(callAPI), for: .touchUpInside)
        view.addSubview(btnSession)
    }
    
    // MARK: API REQUEST
    @objc func callAPI(){
        view.addSubview(loadingBlock)
        movieService.getSession().subscribe(onNext: { sessionResponse in
            self.showErrorAlert(errorMsg: "Success! Your token has created, token expires at : \(sessionResponse.expires_at))", isAction: true, title: "", typeAlert: "alertSessionCreate")

//            // SAVE CRED
            self.credentialSave(val: sessionResponse.guest_session_id, key: guestSessionKey, type: "save")

            loadingBlock.removeFromSuperview()
        }).disposed(by: disposeBag)
    }
    
    // MARK: CALLBACK
    override func toHomePage() {
        // SET AS NAV CONTROLLER
        let nc = UINavigationController(rootViewController: ListMovieViewC())
        appDelegate.window?.rootViewController = nc
        appDelegate.window?.makeKeyAndVisible()
    }
}
