//
//  ListMovieViewM.swift
//  MovieDBApps
//
//  Created by Firman Aminuddin on 7/16/21.
//

import Foundation
import RxSwift

class ListMovieViewM{
    let title = "Movie Genre List"
    
    private let movieService : MovieServiceDelegate
    
    // Direct return movieService
    init(movieService : MovieServiceDelegate = MovieService()) {
        self.movieService = movieService
    }
    
    func fetchMovieGenreViewModels() -> Observable<[ListMovieModel]>{
        movieService.fetchGenreMovieList().map { $0.map {
            ListMovieModel(movie: $0)
        } }
    }
}
