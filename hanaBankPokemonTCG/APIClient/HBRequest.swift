//
//  HBRequest.swift
//  hanaBankPokemonTCG
//
//  Created by Rendi Wijiatmoko on 13/09/23.
//

import Foundation

/// Object that represents single API call
final class HBRequest {
    /// API Constant
    private struct Constant {
        static let baseUrl = "https://api.pokemontcg.io/v2"
    }
    
    /// Desired component
    private let endPoint: HBEndpoint
    
    /// Path components for API, if any
    private let pathComponents: [String]
    
    /// Query arguments for API, if any
    private let queryParameters: [URLQueryItem]
    
    /// Constructed url for the api request in string format
    private var urlString: String {
        var string = Constant.baseUrl
        string += "/"
        string += endPoint.rawValue
//        string += "?pageSize=8"
        
        if !pathComponents.isEmpty {
            pathComponents.forEach ({
                string += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else {return nil}
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
        }
        
        return string
    }
    
    /// Computed and constructed API url
    public var url: URL? {
        return URL(string: urlString)
    }
    
    /// Desired HTTP Method
    public let httpMethod = "GET"
    
    // MARK: - Public
    
    /// Consturct request
    /// - Parameters:
    ///   - endPoint: Target endpoint
    ///   - pathComponents: Collections of path components
    ///   - queryParameters: Collections of query paramaters
    public init(endPoint: HBEndpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endPoint = endPoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constant.baseUrl) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constant.baseUrl+"/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0]
                if let hBEndpoint = HBEndpoint(rawValue: endpointString) {
                    self.init(endPoint: hBEndpoint)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty {
                let endpointString = components[0]
                let queryItemString = components[1]
                
                let queryItems: [URLQueryItem] = queryItemString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    
                    let parts = $0.components(separatedBy: "=")
                    
                    return URLQueryItem(name: parts[0], value: parts[1])
                })
                
                if let hBEndpoint = HBEndpoint(rawValue: endpointString) {
                    self.init(endPoint: hBEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }
        
        return nil
    }
}


extension HBRequest {
    static let listCardRequest = HBRequest(endPoint: .cards)
}
