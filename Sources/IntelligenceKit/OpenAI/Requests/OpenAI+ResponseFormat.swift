import Foundation
import HandySwift

extension OpenAI {
   public struct ResponseFormat: Encodable, Sendable {
      private enum CodingKeys: String, CodingKey { case type, name, description, schema, strict }

      /// Required: Must be "json_schema" for structured outputs
      public let type = "json_schema"
      /// Required: A name for the schema
      public let name: String
      /// Optional: Description for the schema
      public let description: String?
      /// Required: Whether output must strictly adhere to schema
      public let strict: Bool
      /// Required: The JSON schema definition
      public let schema: JSONSchema

      public init(name: String, description: String?, strict: Bool = true, schema: JSONSchema) {
         self.name = name
         self.description = description
         self.strict = strict
         self.schema = schema
      }
   }
}
