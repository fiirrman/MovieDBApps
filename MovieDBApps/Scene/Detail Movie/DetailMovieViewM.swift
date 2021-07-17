//
//  DetailMovieViewM.swift
//  MovieDBApps
//
//  Created by Firman Aminuddin on 7/17/21.
//

import UIKit
import RxSwift

class DetailMovieViewM {
    private let movieService : MovieServiceDelegate
    
    // Direct return movieService
    init(movieService : MovieServiceDelegate = MovieService()) {
        self.movieService = movieService
    }
    
    func fetchDetailMovie(query : String) -> Observable<DetailMovieModel>{
        movieService.fetchMovieDetail(query: query).map {
            DetailMovieModel(movie: $0)
        }
    }
}
