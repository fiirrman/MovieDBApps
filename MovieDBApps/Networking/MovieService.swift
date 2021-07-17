//
//  MovieService.swift
//  MovieDBApps
//
//  Created by Firman Aminuddin on 7/17/21.
//

import Foundation
import RxSwift
import Alamofire

protocol MovieServiceDelegate {
    func fetchGenreMovieList() -> Observable<[ArrGenreList]>
    func fetchMovieListByGenre(query : String) -> Observable<[MovieListResults]>
}

class MovieService : MovieServiceDelegate{
    func getSession() -> Observable<GuestSessionResponse> {
        return Observable.create { observer -> Disposable in
            AF.request(url_authSession, method: .post, encoding: JSONEncoding.default, headers: nil)
                .responseJSON { response in
                    print("REQUEST API: \(String(describing: response.request))")
                    print("RESULT API: \(response.result)")
                    if response.error == nil {
                        guard let data = response.data else { return }
                        do {
                            let dataResponse = try JSONDecoder().decode(GuestSessionResponse.self, from: data)
                            observer.onNext(dataResponse)
                        } catch {
                            if let result = response.value {
                                let JSON = result as! NSDictionary
                                let msg = JSON["status_message"] as! String
                                let code = JSON["status_code"] as! Int
                                observer.onError(NSError(domain: "Error Code : \(code), Description : \(msg)", code: -1, userInfo: nil))
                            }else{
                                observer.onError(error)
                            }
                        }
                    } else {
                        observer.onError(response.error?.localizedDescription as! Error)
                    }
                }

            return Disposables.create {}
        }
    }
    
    func fetchGenreMovieList() -> Observable<[ArrGenreList]> {
        return Observable.create { observer -> Disposable in
            AF.request(url_getListGenre, method: .get, encoding: JSONEncoding.default, headers: nil)
                .responseJSON { response in
                    print("REQUEST API: \(String(describing: response.request))")
                    print("RESULT API: \(response.result)")
                    if response.error == nil {
                        guard let data = response.data else { return }
                        do {
                            let decoder = JSONDecoder()
                            let dataResponse = try decoder.decode(GenreList.self, from: data)
                            observer.onNext(dataResponse.genres)
                        } catch {
                            if let result = response.value {
                                let JSON = result as! NSDictionary
                                let msg = JSON["status_message"] as! String
                                let code = JSON["status_code"] as! Int
                                observer.onError(NSError(domain: "Error Code : \(code), Description : \(msg)", code: -1, userInfo: nil))
                            }else{
                                observer.onError(error)
                            }
                        }
                    } else {
                        observer.onError(response.error?.localizedDescription as! Error)
                    }
            }
            
            return Disposables.create {}
        }
    }
    
    func fetchMovieListByGenre(query : String) -> Observable<[MovieListResults]> {
        return Observable.create { observer -> Disposable in
            AF.request(url_getMovieByGenre + query, method: .get, encoding: JSONEncoding.default, headers: nil)
                .responseJSON { response in
                    print("REQUEST API: \(String(describing: response.request))")
                    print("RESULT API: \(response.result)")
                    if response.error == nil {
                        guard let data = response.data else { return }
                        do {
                            let decoder = JSONDecoder()
                            let dataResponse = try decoder.decode(MovieListResponse.self, from: data)
                            observer.onNext(dataResponse.results)
                        } catch {
                            print(error.localizedDescription)
                            observer.onError(error)
                        }
                    } else {
                        observer.onError(response.error?.localizedDescription as! Error)
                    }
            }
            
            return Disposables.create {}
        }
    }
}
