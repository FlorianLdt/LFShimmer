//
//  LoadingLabelViewModel.swift
//  LFShimmer
//
//  Created by Florian LUDOT on 6/19/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import Foundation

struct LoadingTextViewModel {
    enum State {
        case initialized
        case loading
        case loaded(String?)
    }
    
    let state: State
    
    let isLoading: Bool
    let text: String?
    
    init(state: State) {
        self.state = state
        
        switch state {
        case .initialized:
            self.isLoading = false
            self.text = nil
        case .loading:
            self.isLoading = true
            self.text = nil
        case .loaded(let text):
            self.isLoading = false
            self.text = text
        }
    }
}
