//
//  RepositoryListViewModel.swift
//  GitHubSearch
//
//  Created by Nurboldy on 6/11/19.
//  Copyright © 2019 Nurboldy. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

final class RepositoryListViewModel: BindableObject {
    typealias SearchRepositories = (String) -> AnyPublisher<Result<[Repository], ErrorResponse>, Never>
    
    let didChange: AnyPublisher<RepositoryListViewModel, Never>
    private let _didChange = PassthroughSubject<RepositoryListViewModel, Never>()
    
    private let _searchWithQuery = PassthroughSubject<String, Never>()
    private var cancellables: [AnyCancellable] = []
    
    private(set) var repositories: [Repository] = [] {
        didSet {
            _didChange.send(self)
        }
    }
    private(set) var errorMessage: String? {
        didSet {
            _didChange.send(self)
        }
    }
    var text: String = ""
    
    init<S: Scheduler>(searchRepositories: @escaping SearchRepositories = RepositoryAPI.search,
                       mainScheduler: S) {
        
        self.didChange = _didChange.eraseToAnyPublisher()
        
        let response = _searchWithQuery
            .filter { !$0.isEmpty }
            .debounce(for: .milliseconds(300), scheduler: mainScheduler)
            .flatMapLatest { query -> AnyPublisher<([Repository], String?), Never> in
                searchRepositories(query)
                    .map { result -> ([Repository], String?) in
                        switch result {
                        case let .success(repositories):
                            return (repositories, nil)
                        case let .failure(response):
                            return ([], response.message)
                        }
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: mainScheduler)
            .share()
        
        cancellables += [
            response
                .map { $0.0 }
                .assign(to: \.repositories, on: self),
            response
                .map { $0.1 }
                .assign(to: \.errorMessage, on: self)
        ]
    }
    
    func search() {
        _searchWithQuery.send(text)
    }
}
