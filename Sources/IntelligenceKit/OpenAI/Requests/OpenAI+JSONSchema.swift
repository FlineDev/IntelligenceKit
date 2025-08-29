import Foundation
import HandySwift

extension OpenAI {
   public final class JSONSchema: Encodable, Sendable {
      // MARK: - Nested Types
      public enum SchemaType: String, AutoConforming {
         case object
         case array
         case string
         case number
         case integer
         case boolean
      }

      private enum CodingKeys: String, CodingKey {
         case type, properties, items, description, required, additionalProperties, anyOf
         case enumCases = "enum"
      }

      // MARK: - Properties
      public let type: SchemaType
      public let properties: [String: JSONSchema]?
      public let items: JSONSchema?
      public let description: String?
      public let required: [String]
      public let additionalProperties: Bool = false
      public let anyOf: [JSONSchema]?
      public let enumCases: [String]?

      // MARK: - Initialization
      public init(
         type: SchemaType,
         properties: [String: JSONSchema]? = nil,
         items: JSONSchema? = nil,
         description: String?,
         anyOf: [JSONSchema]? = nil,
         enumCases: [String]? = nil
      ) {
         self.type = type
         self.properties = properties
         self.items = items
         self.description = description
         self.required = properties != nil ? Array(properties!.keys) : []
         self.anyOf = anyOf
         self.enumCases = enumCases
      }
   }
}

// MARK: - Factory Methods
extension OpenAI.JSONSchema {
   public static func object(properties: [String: OpenAI.JSONSchema], description: String? = nil) -> Self {
      Self(type: .object, properties: properties, description: description)
   }

   public static func array(items: OpenAI.JSONSchema, description: String) -> Self {
      Self(type: .array, items: items, description: description)
   }

   public static func string(description: String) -> Self {
      Self(type: .string, description: description)
   }

   public static func enumCases(_ enumCases: [String], description: String? = nil) -> Self {
      Self(type: .string, description: description, enumCases: enumCases)
   }

   public static func number(description: String) -> Self {
      Self(type: .number, description: description)
   }

   public static func integer(description: String) -> Self {
      Self(type: .integer, description: description)
   }

   public static func boolean(description: String) -> Self {
      Self(type: .boolean, description: description)
   }
}
