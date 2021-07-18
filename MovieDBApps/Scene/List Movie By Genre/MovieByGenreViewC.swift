//
//  MovieByGenreViewC.swift
//  MovieDBApps
//
//  Created by Firman Aminuddin on 7/17/21.
//

import UIKit
import RxSwift

class MovieByGenreViewC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let disposeBag = DisposeBag()
    var viewModel = MovieByGenreViewM()
    var arrResponse = [MovieByGenreModel]()
    var refresh = UIRefreshControl()
    
    var titleGenre = ""
    var idGenre = Int()
    
    lazy var tableView: UITableView = {
        let table = UITableView.init()
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.register(MovieGenreTableViewCell.self, forCellReuseIdentifier: MovieGenreTableViewCell.id)
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        if #available(iOS 10.0, *) {
            table.refreshControl = refresh
        } else {
            table.addSubview(refresh)
        }
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        callAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupUI(){
        // Setup table
        tableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        view.addSubview(tableView)
    
        navigationItem.title = "Genre : \(titleGenre)"
        view.backgroundColor = .white
    }
    
    func callAPI(){
        view.addSubview(loadingBlock)
        viewModel.fetchMovieListByGenreModels(query:"\(idGenre)&page=1").observe(on: MainScheduler.instance).subscribe(onNext: { [self] response in
            if(response.count > 0){
                arrResponse = response
                saveData()
                tableView.reloadData()
            }else{
                showErrorAlert(errorMsg: "Cannot retrieve data, please check your connection", isAction: false, title: "", typeAlert: "")
                loadData()
            }
            loadingBlock.removeFromSuperview()
        }).disposed(by: disposeBag)
    }
    
    @objc func refreshData(){
        callAPI()
        refresh.endRefreshing()
    }
    
    // MARK: CORE DATA PROCESS
    func saveData(){
        CoreDataModel.saveMovieListByGenre(entityName: entityMovieByGenre, arrGenre: arrResponse)
    }
    
    func loadData(){
        let predict = NSPredicate(format: "id == \(idGenre)")
        if(CoreDataModel.loadDataWithQueryAndEntityName(vc: UIViewController(), entityName: entityMovieByGenre, predicate: predict)){
            if(CoreDataModel.object.count > 0){
                arrResponse = []
                for i in 0 ..< CoreDataModel.object.count{
                    let objCore = CoreDataModel.object[i]
                    let id = objCore.value(forKey: "id") as! Int
                    let movieTitle = objCore.value(forKey: "movieTitle") ?? ""
                    let movieReleaseDate = objCore.value(forKey: "movieReleaseDate") ?? ""
                    let imageURL = objCore.value(forKey: "imageURL") ?? ""
                    arrResponse.append(MovieByGenreModel(movie: MovieListResults(id: id, original_title: movieTitle as! String, poster_path: "", backdrop_path: imageURL as! String, release_date: movieReleaseDate as! String)))
                }

                tableView.reloadData()
                print("count \(arrResponse.count)")
            }
        }
    }
}

extension MovieByGenreViewC{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieGenreTableViewCell.id, for: indexPath) as! MovieGenreTableViewCell
        
        cell.labelTitle.text = arrResponse[indexPath.row].movieTitle ?? "-"
        if let release = arrResponse[indexPath.row].movieReleaseDate{
            cell.labelDesc.text = "Release Date : " + release
        }else{
            cell.labelDesc.text = "Release Date : -"
        }
        
        if let url = arrResponse[indexPath.row].imageURL{
            downloadImage(url_image + url) { image in
                if let image = image {
                    DispatchQueue.main.async {
                        cell.imageMain.image = image
                    }
                }
            }
        }else{
            cell.imageMain.image = UIImage.init(named: "noImage")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewMovie = DetailMovieViewC()
        viewMovie.idMovie = arrResponse[indexPath.row].id
        self.navigatePage(typePage: viewMovie)
    }
}
