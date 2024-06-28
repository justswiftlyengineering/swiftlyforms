//
//  File.swift
//  
//
//  Created by Kembene Nkem on 15/06/2024.
//

import Foundation

extension SFs {
  /// Identifies the type for field a particular form element is going to encapsulate
  public struct FieldStateType: Hashable, RawRepresentable {
    
    private static var registeredFieldNames: [String:FieldStateType] = [:]
    
    /// defines a `generic` field type
    public static let generic = FieldStateType(typeName: "generic")
    /// The field type name
    public let typeName: String
    
    public var rawValue: String { typeName }
    
    /// Creates a new FieldType with the spacified name
    public init(typeName: String) {
      assert(FieldStateType.registeredFieldNames[typeName] == nil, "A FieldStateType with name \(typeName) is already registered")
      self.typeName = typeName
      FieldStateType.registeredFieldNames[typeName] = self
      
    }
    
    public init?(rawValue: String) {
      guard let value = FieldStateType.registeredFieldNames[rawValue] else {
        return nil
      }
      self = value
    }
  }
  
  public struct FieldType: Hashable, RawRepresentable {
    
    private static var registeredFieldNames: [String:FieldType] = [:]
    
    /// defines a `generic` field type
    public static let generic = FieldType(typeName: "generic")
    /// The field type name
    public let typeName: String
    
    public var rawValue: String { typeName }
    
    /// Creates a new FieldType with the spacified name
    public init(typeName: String) {
      assert(FieldType.registeredFieldNames[typeName] == nil, "A FieldType with name \(typeName) is already registered")
      self.typeName = typeName
      FieldType.registeredFieldNames[typeName] = self
      
    }
    
    public init?(rawValue: String) {
      guard let value = FieldType.registeredFieldNames[rawValue] else {
        return nil
      }
      self = value
    }
  }
}
