//
//  Post.swift
//  FacebookShimmer
//
//  Created by Florian LUDOT on 6/19/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import Foundation

struct Post {
    let id: String?
    let avatar: String?
    let title: String?
    let subtitle: String?
    let content: String?
    
    init(dict: [String : AnyObject]) {
        id = dict["id"] as? String
        avatar = dict["avatar"] as? String
        title = dict["title"] as? String
        subtitle = dict["subtitle"] as? String
        content = dict["content"] as? String
    }
}
