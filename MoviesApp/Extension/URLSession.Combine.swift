//
//  URLSession.Combine.swift
//  GitHubSearch
//
//  Created by Nurboldy on 6/11/19.
//  Copyright © 2019 Nurboldy. All rights reserved.
//

import Combine
import Foundation

import Combine
import Foundation

extension URLSession: CombineCompatible {}

extension CombineExtension where Base == URLSession {
    
    func send(request: URLRequest) -> AnyPublisher<Data, URLSessionError> {
        
        AnyPublisher<Data, URLSessionError> { [base] subscriber in
            
            let task = base.dataTask(with: request) { data, response, error in
                
                guard let response = response as? HTTPURLResponse else {
                    subscriber.receive(completion: .failure(.invalidResponse))
                    return
                }
                
                guard 200..<300 ~= response.statusCode else {
                    let sessionError: URLSessionError
                    if let data = data {
                        sessionError = .serverErrorMessage(statusCode: response.statusCode,
                                                           data: data)
                    } else {
                        sessionError = .serverError(statusCode: response.statusCode,
                                                    error: error)
                    }
                    subscriber.receive(completion: .failure(sessionError))
                    return
                }
                
                guard let data = data else {
                    subscriber.receive(completion: .failure(.noData))
                    return
                }
                
                if let error = error {
                    subscriber.receive(completion: .failure(.unknown(error)))
                } else {
                    _ = subscriber.receive(data)
                    subscriber.receive(completion: .finished)
                }
            }
            
            subscriber.receive(subscription: AnySubscription { task.cancel() })
            task.resume()
        }
    }
}

enum URLSessionError: Error {
    case invalidResponse
    case noData
    case serverErrorMessage(statusCode: Int, data: Data)
    case serverError(statusCode: Int, error: Error?)
    case unknown(Error)
}
