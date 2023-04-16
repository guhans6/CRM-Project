//
//  ImageDownloadManager.swift
//  CRM C
//
//  Created by guhan-pt6208 on 16/04/23.
//

import Foundation
import UIKit

class ImageDownloadManager {
    
    private let imageDownloadNetworkService = ImageDownloadNetworkService()
    private let recordsDatabaseService = RecordsDatabaseService()
    
    func getImage(module: String, id: String, completion: @escaping (UIImage?) -> Void) -> Void {
        
        recordsDatabaseService.getRecordImage(module: module, id: id) { imageData in
            
            completion(UIImage(data: imageData))
        }
        
        imageDownloadNetworkService.downloadImage(module: module, id: id) { image in
            completion(image)
        }
    }
}
