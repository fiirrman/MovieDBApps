//
//  DetailMovieViewC.swift
//  MovieDBApps
//
//  Created by Firman Aminuddin on 7/17/21.
//

import UIKit
import RxSwift

class DetailMovieViewC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let disposeBag = DisposeBag()
    var viewModel = DetailMovieViewM()
    var objDetail : DetailMovieModel?
    var arrGenre = [MovieListDetailGenres]()
    var idMovie = Int()
    var stringJoinGenre = ""
    
    lazy var tableView: UITableView = {
        let table = UITableView.init()
        table.delegate = self
        table.dataSource = self
//        table.style = .subtitle
        table.tableFooterView = UIView()
        table.allowsSelection = false
        table.register(PosterViewCell.self, forCellReuseIdentifier: PosterViewCell.id)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "CellDetail")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        callAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func  setupUI(){
        // Setup table
        tableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        view.addSubview(tableView)
    
//        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Movie Detail"
        view.backgroundColor = .white
    }
    
    func callAPI(){
        view.addSubview(loadingBlock)
        viewModel.fetchDetailMovie(query: "\(idMovie)" + apiKeyForm).observe(on: MainScheduler.instance).subscribe(onNext: { [self] response in
            objDetail = response
            arrGenre = response.arrGenre
            tableView.reloadData()
            loadingBlock.removeFromSuperview()
        }).disposed(by: disposeBag)
    }
}

extension DetailMovieViewC{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return screenHeight * 0.4
        }else{
            return UITableView.automaticDimension
//            return screenHeight * 0.2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: PosterViewCell.id, for: indexPath) as! PosterViewCell
            if let posterUrl = self.objDetail?.poster_path{
                downloadImage(url_image + posterUrl) { image in
                    if let image = image {
                        DispatchQueue.main.async {
                            cell.imageBase.image = image
                        }
                    }
                }
            }else{
                cell.imageBase.image = UIImage.init(named: "noImage")
            }
            return cell
        }else if indexPath.row == 1{
            let cell = UITableViewCell(style: .subtitle,
                        reuseIdentifier: "CellDetail")
            cell.textLabel?.text = objDetail?.original_title
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = objDetail?.overview
            cell.detailTextLabel?.numberOfLines = 0
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellDetail", for: indexPath)
            
            if arrGenre.count > 0{
                for i in 0 ..< arrGenre.count{
                    if(i + 1 == arrGenre.count){
                        stringJoinGenre = stringJoinGenre + (arrGenre[i].name)
                    }else{
                        stringJoinGenre = stringJoinGenre + (arrGenre[i].name) + ", "
                    }
                }
            }

            cell.textLabel?.text = "Genre : " + stringJoinGenre
            
            return cell
        }
        
        return UITableViewCell()
    }
    
}
