//
//  ListMovieModel.swift
//  MovieDBApps
//
//  Created by Firman Aminuddin on 7/17/21.
//

import Foundation

struct ListMovieModel {
    private let movie : ArrGenreList
    
    var text : String{
        return movie.name
    }
    
    var id : Int{
        return movie.id
    }
    
    init(movie : ArrGenreList) {
        self.movie = movie
    }
}
