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
    
        navigationItem.title = "Movie Detail"
        view.backgroundColor = .white
    }
    
    func callAPI(){
        view.addSubview(loadingBlock)
        viewModel.fetchDetailMovie(query: "\(idMovie)" + apiKeyForm).observe(on: MainScheduler.instance).subscribe(onNext: { [self] response in
            objDetail = response
            arrGenre = response.arrGenre
            saveData()
            tableView.reloadData()
            loadingBlock.removeFromSuperview()
        }, onCompleted: { [self] in
            loadData()
            self.showErrorAlert(errorMsg: "Cannot retrieve data, please check your connection", isAction: false, title: "", typeAlert: "")
            loadingBlock.removeFromSuperview()
        }).disposed(by: disposeBag)
    }
    
    // MARK: CORE DATA PROCESS
    func saveData(){
        CoreDataModel.saveMovieDetail(entityName: entityMovieDetail, detailModel: objDetail!, id : idMovie)
    }
    
    func loadData(){
        let predict = NSPredicate(format: "id == \(idMovie)")
        if(CoreDataModel.loadDataWithQueryAndEntityName(vc: UIViewController(), entityName: entityMovieDetail, predicate: predict)){
            if(CoreDataModel.object.count > 0){
                let objCore = CoreDataModel.object[0]
                
                let original_title = objCore.value(forKey: "original_title") ?? ""
                let overview = objCore.value(forKey: "overview") ?? ""
                let poster_path = objCore.value(forKey: "poster_path") ?? ""
                let release_date = objCore.value(forKey: "release_date") ?? ""
                stringJoinGenre = objCore.value(forKey: "genres") as! String
                
                let test = DetailMovieModel(movie: MovieListDetailResponse(genres: [], original_title: original_title as! String, overview: overview as! String, poster_path: poster_path as! String, release_date: release_date as! String))
                objDetail = test
                
                tableView.reloadData()
            }
        }
    }
}

extension DetailMovieViewC{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return screenHeight * 0.4
        }else{
            return UITableView.automaticDimension
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
    }
    
}
