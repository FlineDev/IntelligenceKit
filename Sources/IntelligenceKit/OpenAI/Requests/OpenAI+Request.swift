import Foundation
import HandySwift

extension OpenAI {
   public enum ReasoningEffort: String, Encodable, Sendable {
      case minimal, low, medium, high
   }

   public enum TextVerbosity: String, Encodable, Sendable {
      case low, medium, high
   }

   public enum ServiceTier: String, Encodable, Sendable {
      case auto, `default`, flex, priority
   }

   struct Request: Encodable, Sendable {
      private enum CodingKeys: String, CodingKey {
         case model, input, instructions, reasoning, text
         case previousResponseID = "previous_response_id"
         case store
         case serviceTier = "service_tier"
      }

      struct Reasoning: Encodable, Sendable {
         let effort: ReasoningEffort
      }

      struct Text: Encodable, Sendable {
         let verbosity: TextVerbosity?
         let format: ResponseFormat?
      }

      let model: String
      let input: String
      let instructions: String?
      let reasoning: Reasoning?
      let text: Text?

      let previousResponseID: String?
      let store: Bool?
      let serviceTier: ServiceTier?
   }
}
