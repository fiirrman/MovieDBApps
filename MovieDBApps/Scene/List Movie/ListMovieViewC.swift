//
//  ListMovieViewC.swift
//  MovieDBApps
//
//  Created by Firman Aminuddin on 7/16/21.
//

import UIKit
import RxSwift
import RxCocoa

class ListMovieViewC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let disposeBag = DisposeBag()
    var viewModel = ListMovieViewM()
    var responseArr = [ListMovieModel]()
    
    lazy var tableView: UITableView = {
        let table = UITableView.init()
        //        table.translatesAutoresizingMaskIntoConstraints = false
        //        table.backgroundColor = .lightGray
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        //        table.contentInsetAdjustmentBehavior = .never
        table.register(UITableViewCell.self, forCellReuseIdentifier: "MovieGenreTableViewCell")
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
    
    func setupUI(){
        // Setup table
        tableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        view.addSubview(tableView)
        
        navigationController?.navigationBar.isHidden = false
        //        navigationItem.title = "Movie Genre List"
        navigationItem.title = viewModel.title
        view.backgroundColor = .white
        
        //        viewModel.fetchMovieGenreViewModels().observe(on: MainScheduler.instance).bind(to: tableView.rx.items(cellIdentifier: "MovieGenreTableViewCell")) { index, viewModel, cell in
        //            cell.textLabel?.text = viewModel.text
        //            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        //        }.disposed(by: disposeBag)
    }
    
    func callAPI(){
        view.addSubview(loadingBlock)
        viewModel.fetchMovieGenreViewModels().observe(on: MainScheduler.instance).subscribe(onNext: { [self] response in
            responseArr = response
//            viewModel.fetchMovieGenreViewModels().observe(on: MainScheduler.instance).bind(to: tableView.rx.items(cellIdentifier: "MovieGenreTableViewCell")) { index, viewModel, cell in
//                cell.textLabel?.text = viewModel.text
//                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//            }.disposed(by: disposeBag)
            tableView.reloadData()
            loadingBlock.removeFromSuperview()
        }).disposed(by: disposeBag)
    }
}

extension ListMovieViewC{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        responseArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieGenreTableViewCell", for: indexPath)
        cell.textLabel?.text = responseArr[indexPath.row].text
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewMovie = MovieByGenreViewC()
        viewMovie.idGenre = responseArr[indexPath.row].id
        viewMovie.titleGenre = responseArr[indexPath.row].text
        self.navigatePage(typePage: viewMovie)
    }
}
