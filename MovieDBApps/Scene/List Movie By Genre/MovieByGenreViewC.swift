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
    
    var titleGenre = ""
    var idGenre = Int()
    
    lazy var tableView: UITableView = {
        let table = UITableView.init()
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.register(MovieGenreTableViewCell.self, forCellReuseIdentifier: MovieGenreTableViewCell.id)
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
    
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Genre : \(titleGenre)"
        view.backgroundColor = .white
    }
    
    func callAPI(){
        view.addSubview(loadingBlock)
        viewModel.fetchMovieListByGenreModels(query:"\(idGenre)&page=1").observe(on: MainScheduler.instance).subscribe(onNext: { [self] response in
            arrResponse = response
            tableView.reloadData()
            loadingBlock.removeFromSuperview()
        }).disposed(by: disposeBag)
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
