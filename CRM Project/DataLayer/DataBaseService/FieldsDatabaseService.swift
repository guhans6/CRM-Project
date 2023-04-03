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
    private let fieldIdColumn = "field_id"
    private let customFieldColumn = "custom_field"
    private let displayLabelColumn = "display_label"
    private let apiNameColumn = "api_name"
    private let jsonTypeColumn = "json_type"
    private let fieldLabelColumn = "field_label"
    private let lookupColumn = "lookup"
    private let dataTypeColumn = "data_type"
    private let isSystemMandatoryColumn = "system_mandatory"
    private let moduleApiNameColumn = "moduleApiName"
    
    private let pickListValueTableName = "PickListValue"
    private let displayValueColumn = "display_value"
    private let actualValueColumn = "actual_value"
    private let pickListIdColumn = "picklist_id"

    private let lookupTableName = "Lookup"
    private let lookupIdColumn = "lookup_id"
    private let lookupApiNameColumn = "lookupApiName"
    
    private let database = Database.shared
    
    func createFieldsTable() {
        
        let lookupTableColumns = [
            lookupIdColumn.appending("\(DatabaseService.text) PRIMARY KEY"),
            lookupApiNameColumn.appending(DatabaseService.text),
        ]
        
        if database.createTable(tableName: lookupTableName, columns: lookupTableColumns) == false {
            print(Database.shared.errorMsg)
        }
        
        let fieldsTableColumns = [
            
            fieldIdColumn.appending("\(DatabaseService.text) \(DatabaseService.primaryKey)"),
            displayLabelColumn.appending(DatabaseService.text),
            fieldLabelColumn.appending(DatabaseService.text),
            apiNameColumn.appending(DatabaseService.text),
            jsonTypeColumn.appending(DatabaseService.text),
            customFieldColumn.appending(DatabaseService.integer),
            dataTypeColumn.appending(DatabaseService.text),
            isSystemMandatoryColumn.appending(DatabaseService.integer),
            lookupIdColumn.appending(DatabaseService.text),
            moduleApiNameColumn.appending(DatabaseService.text),
            "FOREIGN KEY(\(lookupIdColumn)) REFERENCES \(lookupTableName)(\(lookupIdColumn))"
        ]
        
        if database.createTable(tableName: fieldTableName, columns: fieldsTableColumns) == false {
            print(Database.shared.errorMsg)
        }
        
        let pickListTableColumns = [
            
            pickListIdColumn.appending("\(DatabaseService.text)\(DatabaseService.primaryKey)"),
            fieldIdColumn.appending(DatabaseService.text),
            displayValueColumn.appending(DatabaseService.text),
            actualValueColumn.appending(DatabaseService.text),
            "FOREIGN KEY(\(fieldIdColumn)) REFERENCES Field(\(fieldIdColumn))"
        ]
        
        if database.createTable(tableName: pickListValueTableName, columns: pickListTableColumns) == false {
            print(pickListTableColumns)
            print(Database.shared.errorMsg)
        }
    }
    
    func saveFieldToDataBase(field: Field, module: String) {
        
        var fieldDictionary  = [String: Any]()
        
        fieldDictionary[fieldIdColumn] = field.id
        fieldDictionary[displayLabelColumn] = field.displayLabel
        fieldDictionary[fieldLabelColumn] = field.fieldLabel
        fieldDictionary[apiNameColumn] = field.apiName
        fieldDictionary[jsonTypeColumn] = field.jsonType
        fieldDictionary[customFieldColumn] = field.customField
        fieldDictionary[dataTypeColumn] = field.dataType
        fieldDictionary[isSystemMandatoryColumn] = field.isSystemMandatory
        fieldDictionary[lookupIdColumn] = field.lookup.module?.id
        fieldDictionary[moduleApiNameColumn] = module
        
        
        if database.insert(tableName: fieldTableName, values: fieldDictionary) == false {
            print(Database.shared.errorMsg)
        }
        
        field.pickListValues.forEach { pickListValue in
            
            var pickListDictionary = [String: Any]()
            pickListDictionary[pickListIdColumn] = pickListValue.id
            pickListDictionary[displayValueColumn] = pickListValue.displayValue
            pickListDictionary[actualValueColumn] = pickListValue.actualValue
            pickListDictionary[fieldIdColumn] = field.id
            
            if database.insert(tableName: pickListValueTableName, values: pickListDictionary) == false {
                print(Database.shared.errorMsg)
            }
        }
        
        var lookupDictionary = [String: Any]()
        
        lookupDictionary[lookupIdColumn] = field.lookup.module?.id
        lookupDictionary[lookupApiNameColumn] = field.lookup.module?.apiName
        
        if database.insert(tableName: lookupTableName, values: lookupDictionary) == false {
//            print(Database.shared.errorMsg)
        }
    }
    
    func getFieldMetadata(module: String, completion: @escaping ([Field]) -> Void) -> Void {
        
        let whereClause = "\(moduleApiNameColumn) = '\(module)'"
        let joins = "LEFT JOIN Lookup on Field.lookup_id = Lookup.lookup_id"
        var fields = [Field]()
        
        database.select(tableName: fieldTableName, whereClause: whereClause, joins: joins) { [weak self] data in
            
            data?.forEach{ datum in
                
                guard let field = self?.convertField(datum: datum) else {
                    return
                }
                
                fields.append(field)
            }
            completion(fields)
        }
    }
    
    private func convertField(datum: [String: Any]) -> Field? {
        
        var fieldModule: FieldModule? = nil
        var pickListValues = [PickListValue]()
        
        guard let fieldIdString = datum[fieldIdColumn] as? String,
              let displayLabel = datum[displayLabelColumn] as? String,
              let fieldLabel = datum[fieldLabelColumn] as? String,
              let apiName = datum[apiNameColumn] as? String,
              let jsonType = datum[jsonTypeColumn] as? String,
              let customField = datum[customFieldColumn] as? Int,
              let dataType = datum[dataTypeColumn] as? String,
              let systemMandatory = datum[isSystemMandatoryColumn] as? Int else {
            
            print("Field Parsing Error")
            return nil
        }
        
        
        if dataType == "lookup" {
            
            guard let lookupId = datum[lookupIdColumn] as? String,
                  let lookupName = datum[lookupApiNameColumn] as? String else {
                
                print("lookup parse error")
                return nil
            }
            fieldModule = FieldModule(id: lookupId, apiName: lookupName)
            
        } else if dataType == "picklist" {
            
            let whereClause = "\(fieldIdColumn) = \(fieldIdString)"
            
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
                          customField: isCustom, displayLabel: displayLabel,
                          multiModuleLookup: lookup, multiselectlookup: lookup,
                          apiName: apiName, jsonType: jsonType,
                          fieldLabel: fieldLabel, lookup: lookup,
                          dataType: dataType, isSystemMandatory: isMandatory)
        
        return field
        
    }
    
    private func convertPickList(value: [String: Any]) -> PickListValue? {
        
        guard let id = value[pickListIdColumn] as? String,
              let displayValue = value[displayValueColumn] as? String,
              let actualValue = value[actualValueColumn] as? String else {
            
            print("Picklist conversion error")
            return nil
        }
        
        return PickListValue(displayValue: displayValue, id: id, actualValue: actualValue)
    }
    
    
}
