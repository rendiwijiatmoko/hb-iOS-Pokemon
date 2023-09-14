//
//  HBImageLoader.swift
//  hanaBankPokemonTCG
//
//  Created by Rendi Wijiatmoko on 13/09/23.
//

import Foundation

final class HBImageLoader {
    static let shared = HBImageLoader()
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    
    private init(){}
    
    /// Get image content with URL
    /// - Parameters:
    ///   - url: source url
    ///   - completion: callback
    public func downloadImage(_ url: URL, completion: @escaping(Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data))
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}
