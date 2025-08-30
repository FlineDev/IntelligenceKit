import Foundation
import HandySwift

extension OpenAI {
   /// Reasoning effort levels for GPT-5 family models.
   /// Controls how much computational effort the model puts into reasoning through problems,
   /// affecting both response quality and processing time/cost.
   ///
   /// Higher reasoning levels produce more thoughtful, accurate responses but take longer
   /// and cost more. Choose the level based on your task complexity and requirements.
   ///
   /// Example:
   /// ```swift
   /// // Quick responses for simple tasks
   /// let fastModel = OpenAI.Model.gpt5Mini(reasoning: .minimal)
   ///
   /// // Balanced approach for most use cases
   /// let balancedModel = OpenAI.Model.gpt5Mini(reasoning: .medium)
   ///
   /// // Deep reasoning for complex problems
   /// let thoughtfulModel = OpenAI.Model.gpt5(reasoning: .high)
   /// ```
   public enum ReasoningEffort: String, Encodable, Sendable {
      case minimal, low, medium, high
   }

   /// Text verbosity levels controlling response length and detail.
   /// Guides the model to produce responses of different lengths and depths of explanation,
   /// helping you get the right amount of detail for your use case.
   ///
   /// This is particularly useful for adapting responses to different contexts like
   /// quick summaries, detailed explanations, or comprehensive analyses.
   ///
   /// Example:
   /// ```swift
   /// // Concise response for quick answers
   /// let response = try await openAI.ask(
   ///     model: .gpt5Mini(reasoning: .medium),
   ///     input: "Explain machine learning",
   ///     verbosity: .low
   /// )
   ///
   /// // Detailed explanation with examples
   /// let response = try await openAI.ask(
   ///     model: .gpt5(reasoning: .medium),
   ///     input: "Explain machine learning",
   ///     verbosity: .high
   /// )
   /// ```
   public enum TextVerbosity: String, Encodable, Sendable {
      case low, medium, high
   }

   /// Service tier options controlling request processing priority and characteristics.
   /// Different tiers offer trade-offs between speed, cost, and availability based on your needs.
   /// Most users can use 'auto' to let OpenAI choose the best tier for each request.
   ///
   /// Example:
   /// ```swift
   /// // Let OpenAI choose the best tier (recommended)
   /// let response = try await openAI.ask(
   ///     model: .gpt5Mini(reasoning: .medium),
   ///     input: "Process this quickly",
   ///     serviceTier: .auto
   /// )
   ///
   /// // High priority for time-sensitive requests
   /// let urgentResponse = try await openAI.ask(
   ///     model: .gpt5(reasoning: .low),
   ///     input: "Urgent analysis needed",
   ///     serviceTier: .priority
   /// )
   /// ```
   public enum ServiceTier: String, Encodable, Sendable {
      case auto
      case `default`
      case flex  // Variable processing times, potentially lower costs
      case priority  // Fastest processing, higher costs
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
