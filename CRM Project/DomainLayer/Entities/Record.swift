//
//  Record.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 10/02/23.
//

import Foundation
import UIKit

struct Record {
    
    let recordName: String
    let secondaryRecordData: String
    let recordId: String
    var recordImage: UIImage?
    
    init(recordName: String,
         secondaryRecordData: String,
         recordId: String,
         recordImage: UIImage?)
    {
        
        self.recordName = recordName
        self.secondaryRecordData = secondaryRecordData
        self.recordId = recordId
        self.recordImage = recordImage
    }
}
