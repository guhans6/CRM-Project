//
//  FieldsDatabaseService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 10/03/23.
//

import Foundation

class FieldsDatabaseService {
    
    private let id = "id"
    
    private let fieldTableName = "Field"
    private let pickListValues = "pick_list_values"
    private let fieldId = "field_id"
    private let customField = "custom_field"
    private let displayLabel = "display_label"
    private let apiName = "api_name"
    private let jsonType = "json_type"
    private let fieldLabel = "field_label"
    private let lookup = "lookup"
    private let dataType = "data_type"
    private let isSystemMandatory = "system_mandatory"
    private let moduleApiName = "moduleApiName"
    
    private let pickListValueTableName = "PickListValue"
    private let displayValue = "display_value"
    private let actualValue = "actual_value"
    private let pickListId = "picklist_id"

    private let lookupTableName = "Lookup"
    private let lookupId = "lookup_id"
    private let lookupApiName = "lookupApiName"
//    private let lookupDisplayLabel = "lookupDisplayLabel"
    
    let database = Database.shared
    
    func createFieldsTable() {
        
        let lookupTableColumns = [
            lookupId.appending("\(DatabaseService.sqliteText) PRIMARY KEY"),
            lookupApiName.appending(DatabaseService.sqliteText),
        ]
        
        if !database.createTable(tableName: lookupTableName, columns: lookupTableColumns) {
            print(Database.shared.errorMsg)
        }
        
        let fieldsTableColumns = [
            
            fieldId.appending("\(DatabaseService.sqliteText) \(DatabaseService.primaryKey)"),
            displayLabel.appending(DatabaseService.sqliteText),
            apiName.appending(DatabaseService.sqliteText),
            jsonType.appending(DatabaseService.sqliteText),
            customField.appending(DatabaseService.sqliteInt),
            dataType.appending(DatabaseService.sqliteText),
            isSystemMandatory.appending(DatabaseService.sqliteInt),
            lookupId.appending(DatabaseService.sqliteText),
            moduleApiName.appending(DatabaseService.sqliteText),
            "FOREIGN KEY(\(lookupId)) REFERENCES \(lookupTableName)(\(lookupId))"
        ]
        
        if !database.createTable(tableName: fieldTableName, columns: fieldsTableColumns) {
            print(Database.shared.errorMsg)
        }
        
        let pickListTableColumns = [
            
            pickListId.appending("\(DatabaseService.sqliteText) \(DatabaseService.primaryKey)"),
            fieldId.appending(DatabaseService.sqliteText),
            displayValue.appending(DatabaseService.sqliteText),
            actualValue.appending(DatabaseService.sqliteText),
            "FOREIGN KEY(\(fieldId)) REFERENCES Fields(\(fieldId))"
        ]
        
        if !database.createTable(tableName: pickListValueTableName, columns: pickListTableColumns) {
            print(Database.shared.errorMsg)
        }
    }
    
    func saveFieldToDataBase(field: Field, module: String) {
        
        var fieldDictionary  = [String: Any]()
        
        fieldDictionary[fieldId] = field.id
        fieldDictionary[displayLabel] = field.displayLabel
        fieldDictionary[apiName] = field.apiName
        fieldDictionary[jsonType] = field.jsonType
        fieldDictionary[customField] = field.customField
        fieldDictionary[dataType] = field.dataType
        fieldDictionary[isSystemMandatory] = field.isSystemMandatory
        fieldDictionary[lookupId] = field.lookup.module?.id
        fieldDictionary[moduleApiName] = module
        
        if database.insert(tableName: fieldTableName, values: fieldDictionary) == false {
            print(Database.shared.errorMsg)
        }
        
        field.pickListValues.forEach { pickListValue in
            
            var pickListDictionary = [String: Any]()
            pickListDictionary[pickListId] = pickListValue.id
            pickListDictionary[displayValue] = pickListValue.displayValue
            pickListDictionary[actualValue] = pickListValue.actualValue
            pickListDictionary[fieldId] = field.id
            
            if !database.insert(tableName: pickListValueTableName, values: pickListDictionary) == false {
                print(Database.shared.errorMsg)
            }
        }
        
        var lookupDictionary = [String: Any]()
        
        lookupDictionary[lookupId] = field.lookup.module?.id
        lookupDictionary[lookupApiName] = field.lookup.module?.apiName
        
        if !database.insert(tableName: lookupTableName, values: lookupDictionary) {
            print(Database.shared.errorMsg)
        }
    }
    
    func getFieldMetadata(module: String, completion: @escaping ([Field]) -> Void) -> Void {
        
        let whereClause = "\(moduleApiName) = '\(module)'"
        let joins = "LEFT JOIN Lookup on Field.lookup_id = Lookup.lookup_id"
        var fields = [Field]()
        
        database.select(tableName: fieldTableName, whereClause: whereClause, joins: joins) { [weak self] data in
            
            data?.forEach({ datum in
                
                guard let field = self?.convertField(datum: datum) else {
                    return
                }
                
                fields.append(field)
            })
            completion(fields)
        }
    }
    
    private func convertField(datum: [String: Any]) -> Field? {
        
        var fieldModule: FieldModule? = nil
        var pickListValues = [PickListValue]()
        
        guard let fieldIdString = datum[fieldId] as? String,
              let displayLabel = datum[displayLabel] as? String,
              let apiName = datum[apiName] as? String,
              let jsonType = datum[jsonType] as? String,
              let customField = datum[customField] as? Int,
              let dataType = datum[dataType] as? String,
              let systemMandatory = datum[isSystemMandatory] as? Int else {
            
            print("Field Parsing Error")
            return nil
        }
        
        var fieldDisplayLabel = displayLabel
        
        if displayLabel == "CustomModule Name" {
            
            fieldDisplayLabel = "Name"
        }
        
        if dataType == "lookup" {
            
            guard let lookupId = datum[lookupId] as? String,
                  let lookupName = datum[lookupApiName] as? String else {
                
                print("lookup parse error")
                return nil
            }
            fieldModule = FieldModule(id: lookupId, apiName: lookupName)
            
        } else if dataType == "picklist" {
            
            let whereClause = "\(fieldId) = \(fieldIdString)"
            
            database.select(tableName: pickListValueTableName,
                            whereClause: whereClause) { [weak self] result in
                
                result?.forEach({ pickLisValue in
                    
                    if let value = self?.convertPickList(value: pickLisValue) {
                        pickListValues.append(value)
                    }
                })
            }
        }
        
        let isCustom = customField == 1 ? true : false
        let lookup = Lookup(module: fieldModule)
        let isMandatory = systemMandatory == 1 ? true : false
        
        let field = Field(id: fieldIdString, pickListValues: pickListValues,
                          customField: isCustom, displayLabel: fieldDisplayLabel,
                          multiModuleLookup: lookup, multiselectlookup: lookup,
                          apiName: apiName, jsonType: jsonType,
                          fieldLabel: fieldLabel, lookup: lookup,
                          dataType: dataType, isSystemMandatory: isMandatory)
        
        return field
        
    }
    
    private func convertPickList(value: [String: Any]) -> PickListValue? {
        
        guard let id = value[pickListId] as? String,
              let displayValue = value[displayValue] as? String,
              let actualValue = value[actualValue] as? String else {
            
            print("Picklist conversion error")
            return nil
        }
        
        return PickListValue(displayValue: displayValue, id: id, actualValue: actualValue)
    }
    
    
}
