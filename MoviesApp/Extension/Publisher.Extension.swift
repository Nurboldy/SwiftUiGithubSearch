//
//  Publisher.Extension.swift
//  MoviesApp
//
//  Created by Nurboldy on 6/11/19.
//  Copyright © 2019 Nurboldy. All rights reserved.
//

import Combine

extension Publisher {
    
    /// - seealso: https://twitter.com/peres/status/1136132104020881408
    func flatMapLatest<T: Publisher>(_ transform: @escaping (Self.Output) -> T) -> Publishers.SwitchToLatest<T, Publishers.Map<Self, T>> where T.Failure == Self.Failure {
        map(transform).switchToLatest()
    }
}

extension Publisher {
    
    static func empty() -> AnyPublisher<Output, Failure> {
        return Publishers.Empty()
            .eraseToAnyPublisher()
    }
    
    static func just(_ output: Output) -> AnyPublisher<Output, Failure> {
        return Publishers.Just(output)
            .catch { _ in AnyPublisher<Output, Failure>.empty() }
            .eraseToAnyPublisher()
    }
}
