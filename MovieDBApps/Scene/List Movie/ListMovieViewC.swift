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
    var refresh = UIRefreshControl()
    
    lazy var tableView: UITableView = {
        let table = UITableView.init()
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "MovieGenreTableViewCell")
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
    
    func setupUI(){
        // Setup table
        tableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        view.addSubview(tableView)
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = viewModel.title
        view.backgroundColor = .white
    }
    
    func callAPI(){
        view.addSubview(loadingBlock)
        viewModel.fetchMovieGenreViewModels().observe(on: MainScheduler.instance).subscribe(onNext: { [self] response in
            if(response.count > 0){
                responseArr = response
                saveData()
                tableView.reloadData()
            }else{
                print("error")
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
        CoreDataModel.saveEntityGenre(entityName: entityGenre, arrGenre: responseArr)
    }
    
    func loadData(){
        if(CoreDataModel.loadContext(vc: UIViewController(), entityName: entityGenre)){
            if(CoreDataModel.object.count > 0){
                responseArr = []
                for i in 0 ..< CoreDataModel.object.count{
                    let objCore = CoreDataModel.object[i]
                    let id = objCore.value(forKey: "id") as! Int
                    let name = objCore.value(forKey: "name") as! String
                    responseArr.append(ListMovieModel(movie: ArrGenreList(id: id, name: name)))
                }
                
                tableView.reloadData()
                print("count \(responseArr.count)")
            }
        }
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
