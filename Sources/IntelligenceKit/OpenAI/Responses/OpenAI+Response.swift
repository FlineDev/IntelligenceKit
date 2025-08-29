import Foundation
import HandySwift

extension OpenAI {
   public struct Response: AutoConforming {
      public struct Usage: AutoConforming {
         public let inputTokens: Int
         public let outputTokens: Int
         public let totalTokens: Int

         public var tokenUsage: TokenUsage {
            TokenUsage(inputTokens: self.inputTokens, outputTokens: self.outputTokens, totalTokens: self.totalTokens)
         }
      }

      public struct OutputItem: AutoConforming {
         public enum `Type`: String, AutoConforming {
            case message
            case reasoning
         }

         public struct Content: AutoConforming {
            public enum ContentType: String, AutoConforming {
               case outputText = "output_text"
            }

            public let type: ContentType
            public let text: String
         }

         public let id: String
         public let type: Type
         public let role: String?
         public let content: [Content]?
      }

      public let id: String
      public let object: String
      public let usage: Usage
      public let output: [OutputItem]

      /// Convenience property to get the output text directly
      public var outputText: String {
         self.output.first { $0.type == .message }?.content?.first?.text ?? ""
      }
   }
}

extension OpenAI.Response {
   public func textMessage() throws(OpenAI.Error) -> String {
      guard let outputItem = self.output.first(where: { $0.type == .message }) else { throw .emptyResponse }
      guard let content = outputItem.content?.first else { throw .emptyResponse }
      return content.text
   }

   public func jsonMessage<T: Decodable>(decodedTo: T.Type) throws(OpenAI.Error) -> T {
      let textMessage = try self.textMessage()
      do {
         return try JSONDecoder().decode(T.self, from: Data(textMessage.utf8))
      } catch {
         throw .jsonSchemaDecodingError(error)
      }
   }
}
