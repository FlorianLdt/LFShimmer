//
//  FeedPostListViewModel.swift
//  LFShimmer
//
//  Created by Florian LUDOT on 6/19/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import Foundation


enum DataMode {
    case data
    case noContent
    case noNetwork
    case serverError
}

protocol UITableViewUpdateDelegate {
    func didViewModelStateChanged(state: FeedPostListViewModel.State)
}

class FeedPostListViewModel {
    
    let tableViewUpdateDelegate: UITableViewUpdateDelegate
    
    enum State {
        case loading
        case loaded([FeedPostViewModel])
        case empty
        case error(ErrorDescription)
        
        var feedPostViewModels: [FeedPostViewModel] {
            switch self {
//            case .paging(let posts, _):
//                return recordings
            case .loaded(let posts):
                return posts
            default:
                return []
            }
        }
    }
    
    var state: State = .loading {
        didSet {
            DispatchQueue.main.async {
                self.tableViewUpdateDelegate.didViewModelStateChanged(state: self.state)
            }
            
        }
    }
    
    init(state: State, tableViewUpdateDelegate: UITableViewUpdateDelegate) {
        self.state = state
        self.tableViewUpdateDelegate = tableViewUpdateDelegate
    }
        
    var numberOfCells: Int {
        return state.feedPostViewModels.count
    }
    
    func getCommentViewModel( at indexPath: IndexPath) -> FeedPostViewModel {
        return state.feedPostViewModels[indexPath.row]
    }
    
    func getFeedPost(withStatus status: DataMode) {
        state = .loading
        let backgroundQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
        backgroundQueue.async(execute: {
            sleep(2)
        
            let result = self.fetchDataFor(status)
            
            guard let posts = result.posts else {
                self.state = .error(result.error ?? .ServerError)
                return
            }
            
            self.processFetchedPosts(posts: posts)
            
        })
    }
    
    private func fetchDataFor(_ status: DataMode) -> PostResult {
        
        func fireErrorResult(_ error: ErrorDescription) -> PostResult {
            return PostResult(error: error)
        }
        
        switch status {
        case .data:
            guard let path = Bundle.main.path(forResource: "posts", ofType: "json") else { return fireErrorResult(.ServerError) }
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                guard let JSON = jsonResult as? Dictionary<String, AnyObject> else {
                    return fireErrorResult(.ServerError)
                }
                
                return PostResult(dict: JSON)
            } catch {
                return fireErrorResult(.NoContent)
            }
        case .noContent:
            return fireErrorResult(.NoContent)
        case .noNetwork:
            return fireErrorResult(.NetworkError)
        case .serverError:
            return fireErrorResult(.ServerError)
        }
        
        
    
    }
    
    private func createFeedPostViewModel( post: Post) -> FeedPostViewModel {
        return FeedPostViewModel(id: post.id, avatar: post.avatar, title: post.title, subtitle: post.subtitle, content: post.content)
    }
    
    private func processFetchedPosts( posts: [Post]) {
        var _feedPostViewModels = [FeedPostViewModel]()
        for post in posts {
            _feedPostViewModels.append( createFeedPostViewModel(post: post))
        }
        self.state = .loaded(_feedPostViewModels)
    }
    
}
