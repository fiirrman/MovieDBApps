//
//  FirstTest.swift
//  MovieDBAppsTests
//
//  Created by Firman Aminuddin on 7/18/21.
//

import Foundation
import XCTest
import RxSwift

@testable import MovieDBApps
class FirstTest : XCTestCase {
    func testFunction(){
        UIViewController.init().downloadImage("", linkwithCompletion: { result in
            // Cannot Nil even with link is empty
//            XCTAssertNil(result)
            XCTAssertNotNil(result)
        })
    }
}
