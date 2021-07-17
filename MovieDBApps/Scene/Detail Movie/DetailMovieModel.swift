//
//  DetailMovieModel.swift
//  MovieDBApps
//
//  Created by Firman Aminuddin on 7/17/21.
//

struct DetailMovieModel {
    private let movie : MovieListDetailResponse
    
    var poster_path : String {
        movie.poster_path
    }
    
    var original_title : String {
        movie.original_title
    }
    
    var overview : String {
        movie.overview
    }
    
    var arrGenre : [MovieListDetailGenres]{
        movie.genres
    }
    
    init(movie : MovieListDetailResponse) {
        self.movie = movie
    }
}
