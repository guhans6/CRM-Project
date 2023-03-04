//
//  RecordsNetworkService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class RecordsNetworkService {
    
    let networService = NetworkService()
    
    func addRecord(module: String, recordData: [String: Any?], isAUpdate: Bool, recordId: String?) {
        
        let urlRequestString = "crm/v3/\(module)"
        
        
        var data = recordData
        var httpMethod = HTTPMethod.POST
        
        
        // MARK: DIFFERENT METHOD FOR UPDATE ONLY UPDATED RECORDS SHOULD BE SENT TO SERVER
        if isAUpdate {
            guard let recordId = recordId else { print("recordId Invalid"); return }
            
            data["id"] = recordId
            httpMethod =  HTTPMethod.PUT
        }
        
        let parameters = ["data": [data]]
        print(parameters)
        
        networService.performNetworkCall(url: urlRequestString, method: httpMethod, urlComponents: nil, parameters: parameters, headers: nil) { resultData in
//            print(resultData)
        } failure: { error in
            print(error)
        }
    }
    
    func getRecords(module: String, id: String?, completion: @escaping ([Record]) -> Void) -> Void {
        
        var urlRequestString = "crm/v3/\(module)"
        
        
        if let id = id {
            urlRequestString.append("/")
            urlRequestString.append(id)
        } else {
            urlRequestString.append("?fields=Name,Email")
        }
        
        networService.performNetworkCall(url: urlRequestString, method: HTTPMethod.GET, urlComponents: nil, parameters: nil, headers: nil) { data in
            
//            print(data)
            
            let recordsResult = data["data"] as! [Any]
            
            
            var recordsArray = [Record]()
            
            recordsResult.forEach { record in
            
            let record = record as! [String: Any]
            let secondaryData = record["Email"] as? String ?? record["Owner"] as? String ?? ""
            
            let recordName = record["Name"] as! String
            let recordId = record["id"] as! String
            recordsArray.append(Record(recordName: recordName, secondaryRecordData: secondaryData, recordId: recordId, owner: nil ,createdTime: nil, modifiedBy: nil, modifiedTime: nil ))
        }
//            print(recordsResult)
            completion(recordsArray)
            self.saveAllRecordsInDatabase(records: recordsArray)
        } failure: { error in
            print(error)
        }
    }
    
    func getIndividualRecord(module: String, id: String?,
                                     completion: @escaping ([(String, Any)]) -> Void) -> Void {
        
        var urlRequestString = "crm/v3/\(module)"
        
        guard let id = id else {
            print("Id not present to fetch record.")
            return
        }
        
        urlRequestString.append("/")
        urlRequestString.append(id)
        
        networService.performNetworkCall(url: urlRequestString, method: HTTPMethod.GET, urlComponents: nil, parameters: nil, headers: nil) { data in
            
            
            // MARK: REPETION CHECK ABOVE FUNCTIONS
            let recordsResult = data["data"] as! [Any]
            let record = recordsResult[0] as! [String: Any]
            
            
            let sortedKeys = record.keys.sorted()
            let this = record.filter { key, value in
                !key.contains("$")
            }
            
            let that = this.sorted { ke, val in
                if ke.key > val.key {
                    return true
                }
                return false
            }
            
            that.forEach { pair in
                print(pair.key , pair.value)
            }
//            for key in sortedKeys {
//
//                if !key.starts(with: "$") {
//                    let value = record[key]
//                    print(key, value  ?? "a")
//                }
//
//            }
            
            
            
            var recordInfo = [(String, Any)]()
            // This should be in usecase layer
            
            record.forEach { key, value in
                
                if !key.starts(with: "$") {
                    if let recordDictionary = value as? [String: Any] {
                        
                        let name = recordDictionary["name"] as! String
                        let id = recordDictionary["id"] as! String
                        
//                        print(name, id)
                        
                        recordInfo.append((key, [id, name]))
                    }
//                    else if key == name || key == owner {
//
//                        recordInfo.append(("\(module) \(key)", value as! String))
//                    }
                    else if let value = value as? Bool {
                        
                        recordInfo.append((key, value == true ? "true" : "false"))
                    } else if let recordArray = value as? [String] {
                        
                        recordInfo.append((key, recordArray.joined(separator: ",")))
                    } else if let doubleValue = value as? Double {
                        
                        recordInfo.append((key, doubleValue))
                    } else if let intValue = value as? Int {
                        
                        recordInfo.append((key, String(intValue)))
                    } else {
                        
                        let date = self.convert(date: value  as? String ?? "")
                        
                        recordInfo.append((key, date))
                    }
                }
            }
            
            completion(recordInfo)
        } failure: { error in
            print(error.localizedDescription)
        }
    }
    
    private func convert(date: String) -> String {
        
        
        
        let regex = #"^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2]\d|3[0-1])$"# // your regex pattern
        
        if let _ = date.range(of: regex, options: .regularExpression) {
            
            //            print("Valid date string")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let date = dateFormatter.date(from: date) {
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let formattedDate = dateFormatter.string(from: date)
                
                return formattedDate
            } else {
                // the string is invalid
                print("Invalid date string")
            }
        }
        return date
    }
    
    func deleteRecords(module: String, ids: [String], completion: @escaping ([Any]) -> Void) -> Void {
        var urlRequestString = "crm/v3/\(module)?ids="
        
        ids.forEach { id in
//            urlRequestString = urlRequestString + id + ","
            urlRequestString.append(id)
            urlRequestString.append(",")
        }
        
        networService.performNetworkCall(url: urlRequestString, method: HTTPMethod.DELETE, urlComponents: nil, parameters: nil, headers: nil) { data in
            
            // MARK: SHOULD DO SOMETHING ABOUT SUCCESSFUL DELETION
            let recordsResult = data["data"] as! [Any]
            recordsResult.forEach { record in
                let data = record as! [String: Any]
                print(data["status"] as! String)
            }
        } failure: { error in
            print(error)
        }
    }
    
    func saveAllRecordsInDatabase(records: [Record]) {
        
        let tableName = "Records"
        let recordId = "record_id"
        let recordName = "record_name"
        let secondaryData = "secondary_data"
        
        
        let sqliteText = " TEXT"
//        let idColumn = "Module_id"
        let columns = [
            recordId.appending(" INTEGER PRIMARY KEY"),
            recordName.appending(sqliteText),
            secondaryData.appending(sqliteText)
            
        ]
        
        if Database.shared.createTable(tableName: tableName, columns: columns) {
            print("Records Table Created Successfully")
        } else {
            print("Failed Records")
        }
        
        for record in records {
            var recordDictionary = [String: Any]()
            
            recordDictionary[recordId] = record.recordId
            recordDictionary[recordName] = record.recordName
            recordDictionary[secondaryData] = record.secondaryRecordData
            
            if Database.shared.insert(tableName: "Records", values: recordDictionary) {
                print("Records added to db")
            } else {
                print("errr inseting records")
            }
        }
    }
}
