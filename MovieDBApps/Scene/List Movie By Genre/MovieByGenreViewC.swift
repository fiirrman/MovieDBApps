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
    
    func setupUI(){
        // Setup table
        tableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        view.addSubview(tableView)
    
        navigationItem.title = "Genre : \(titleGenre)"
        view.backgroundColor = .white
//        viewModel.fetchMovieListByGenreModels(query: "\(idGenre)").observe(on: MainScheduler.instance).bind(to: tableView.rx.items(cellIdentifier: "MovieListByGenreTableViewCell")) { index, viewModel, cell in
//            cell.textLabel?.text = viewModel.movieTitle
//            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//
//            cell.detailTextLabel?.text = "Release Date : \(viewModel.movieReleaseDate)"
//
//            self.downloadImage(url_image + viewModel.imageURL) { image in
//                if let image = image {
//                    DispatchQueue.main.async {
//                        cell.imageView?.image = image
//                    }
//                }else{
//                    cell.imageView!.image = UIImage.init(named: "noImage")
//                }
//            }
//        }.disposed(by: disposeBag)
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
        
//        cell.labelTitle.text = arrResponse[indexPath.row].movieTitle.capitalized
//        cell.labelDesc.text = "Release Date : \(arrResponse[indexPath.row].movieReleaseDate)"
//        self.downloadImage(url_image + arrResponse[indexPath.row].imageURL) { image in
//            if let image = image {
//                DispatchQueue.main.async {
//                    cell.imageMain.image = image
////                    cell.reloadInputViews()
//                }
//            }else{
//                cell.imageMain.image = UIImage.init(named: "noImage")
//            }
//        }
        
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
    
}
