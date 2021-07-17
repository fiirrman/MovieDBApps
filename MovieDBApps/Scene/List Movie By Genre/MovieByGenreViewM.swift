//
//  MovieByGenreViewM.swift
//  MovieDBApps
//
//  Created by Firman Aminuddin on 7/17/21.
//

import UIKit
import RxSwift

class MovieByGenreViewM {
    private let movieService : MovieServiceDelegate
    
    // Direct return movieService
    init(movieService : MovieServiceDelegate = MovieService()) {
        self.movieService = movieService
    }
    
    func fetchMovieListByGenreModels(query : String) -> Observable<[MovieByGenreModel]>{
        movieService.fetchMovieListByGenre(query: query).map { $0.map { MovieByGenreModel(movie: $0)
        }}
    }
}
