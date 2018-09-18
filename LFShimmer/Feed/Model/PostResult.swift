//
//  PostResult.swift
//  LFShimmer
//
//  Created by Florian LUDOT on 6/21/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import Foundation

enum ErrorDescription: String {
    case NoContent = "NoContent"
    case NetworkError = "NetworkError"
    case ServerError = "ServerError"
}

struct PostResult {
    let posts: [Post]?
    let code: Int?
    let error: ErrorDescription?
    
    init(dict : [String : AnyObject]) {
        
        self.code = dict["code"] as? Int ?? nil
        
        if let postsDict = dict["posts"] as? [AnyObject] {
            var posts = [Post]()
            for post in postsDict {
                let post = Post(dict: post as! [String : AnyObject])
                posts.append(post)
            }
            self.posts = posts
        } else {
            posts = nil
        }
        
        guard let code = self.code else {
            self.error = .ServerError
            return
        }
        
        switch code {
        case 200:
            error = nil
        case 204:
            error = .NoContent
        default:
            error = .ServerError
        }
        
    }
    
    init(error: ErrorDescription) {
        self.error = error
        self.code = nil
        self.posts = nil
    }
}
