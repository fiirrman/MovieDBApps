//
//  File.swift
//  MovieDBApps
//
//  Created by Firman Aminuddin on 7/17/21.
//

import Foundation

// MARK: GUEST SESSION RESPONSE
struct GuestSessionResponse : Codable{
    let success : Bool
    let guest_session_id : String
    let expires_at : String
}

// MARK: MOVIE BY GENRE
struct GenreList : Codable{
    let genres : [ArrGenreList]
}

struct ArrGenreList : Codable{
    let id : Int
    let name : String
}

// MARK: RESPONSE STATUS
struct ResponseStatus : Codable{
    let status_code : String
    let status_message : String
    let success : Int
}

// MARK: MOVIE LIST RESPONSE
struct MovieListResponse : Codable {
    let page : Int
    let results : [MovieListResults]
}

struct MovieListResults : Codable{
    let id : Int
    let original_title : String!
    let poster_path : String!
    let backdrop_path : String!
    let release_date : String!
}

// MARK : MOVIE DETAIL RESPONSE
struct MovieListDetailResponse : Codable{
    let genres : [MovieListDetailGenres]
    let original_title : String
    let overview : String
    let poster_path : String
    let release_date : String
}

struct MovieListDetailGenres : Codable{
    let id : Int
    let name : String
}



