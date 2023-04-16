//
//  ImageDownloadController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 15/04/23.
//

import Foundation
import UIKit

class ImageDownloadController {
    
    private let imageDownlaodNetworkService = ImageDownloadNetworkService()
    private let imageDownlaodManager = ImageDownloadManager()
    
    func downloadImage(for id: String,module: String, completion: @escaping (UIImage?) -> Void) {
        
        DispatchQueue.global().async { [weak self] in

            self?.imageDownlaodManager.getImage(module: module, id: id, completion: { image in
                
                DispatchQueue.main.async {
                    
                    completion(image)
                }
            })
            
//            self?.imageDownlaodNetworkService.downloadImage(module: module, id: id) { image in
//                
//                DispatchQueue.main.async {
//                    
//                    completion(image)
//                }
//            }
        }
    }
}
