//
//  MovieByGenreModel.swift
//  MovieDBApps
//
//  Created by Firman Aminuddin on 7/17/21.
//

import Foundation

struct MovieByGenreModel{
    private let movie : MovieListResults
    
    var imageURL : String?{
        return movie.backdrop_path
    }
    
    var movieTitle : String?{
        return movie.original_title
    }
    
    var movieReleaseDate : String?{
        return movie.release_date
    }
    
    init(movie : MovieListResults) {
        self.movie = movie
    }
}
