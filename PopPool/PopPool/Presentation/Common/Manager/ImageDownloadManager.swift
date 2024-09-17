//
//  ImageDownloadManager.swift
//  PopPool
//
//  Created by Porori on 9/17/24.
//

import UIKit
import RxSwift

final class ImageDownloadManager {
    
    static let shared = ImageDownloadManager()
    private init() {}
    
    func parseImage(from link: String?, completed: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let link = link else { return }
        let endpoint = link + "media/?size=l"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.decodeError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("오류가 발생했습니다.", error.localizedDescription)
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.decodeError))
                return
            }
            
            guard let data = data else {
                completed(.failure(.urlResponse))
                return
            }
            
            do {
                let image = UIImage(data: data)
                completed(.success(image!))
            } catch {
                completed(.failure(.emptyData))
            }
        }
        task.resume()
    }
}
