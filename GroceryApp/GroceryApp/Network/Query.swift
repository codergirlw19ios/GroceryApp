//
//  Query.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 5/1/19.
//

import Foundation

protocol Query {
    // if a query is added to a baseURL, this variable provides it
    var urlString: String { get }
}
