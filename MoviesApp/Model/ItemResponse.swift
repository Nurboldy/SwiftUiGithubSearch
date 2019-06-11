//
//  ItemResponse.swift
//  GitHubSearch
//
//  Created by Nurboldy on 6/11/19.
//  Copyright © 2019 Nurboldy. All rights reserved.
//

import Foundation

struct ItemResponse<T: Decodable>: Decodable {
    let items: [T]
}
