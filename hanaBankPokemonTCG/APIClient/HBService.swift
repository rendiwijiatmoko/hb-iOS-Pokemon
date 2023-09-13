//
//  HBService.swift
//  hanaBankPokemonTCG
//
//  Created by Rendi Wijiatmoko on 13/09/23.
//

import Foundation

/// Primary API Service object to get Pokemon data
final class HBService {
    /// shared singleton instance
    static let shared = HBService()
    
    
    /// Privatized constructor
    private init() {}
    
    enum ServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Send Pokemon API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: The type of the object we expect to get back
    ///   - completion: callback with data or error
    public func execute<T: Codable>(
        _ request: HBRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ){
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(ServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? ServiceError.failedToGetData))
                return
            }
            
            // Decode response
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - Private
    private func request(from request: HBRequest) -> URLRequest? {
        guard let url = request.url else {return nil}
        var _request = URLRequest(url: url)
        _request.httpMethod = request.httpMethod
        return _request
    }
}
