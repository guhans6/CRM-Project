//
//  ImageDownloadNetworkService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 15/04/23.
//

import Foundation
import UIKit

class ImageDownloadNetworkService {
    
    private let recordNetworkService = RecordsNetworkService()
    
    func downloadImage(module: String, id: String, completion: @escaping (UIImage?) -> Void) -> Void {
        
        recordNetworkService.getRecordImage(module: module, id: id) { image in
            completion(image)
        }
    }
}
