import Foundation
import HandySwift

extension OpenAI {
   /// OpenAI language models with their specific capabilities and configurations.
   /// Includes both legacy models for migration and the modern GPT-5 family with advanced reasoning.
   ///
   /// The GPT-5 family supports different reasoning effort levels, allowing you to balance
   /// response quality with speed and cost based on your use case.
   ///
   /// Example:
   /// ```swift
   /// // Use GPT-5 with high reasoning for complex problems
   /// let model = OpenAI.Model.gpt5(reasoning: .high)
   ///
   /// // Use GPT-5-mini with minimal reasoning for simple tasks
   /// let fastModel = OpenAI.Model.gpt5Mini(reasoning: .minimal)
   /// ```
   public enum Model: Sendable, Equatable {

      // MARK: - Legacy Models
      case gpt41
      case gpt41Mini
      case o3
      case o4Mini

      // MARK: - GPT-5 Family (Advanced Reasoning)
      case gpt5(reasoning: ReasoningEffort)
      case gpt5Mini(reasoning: ReasoningEffort)
      case gpt5Nano(reasoning: ReasoningEffort)

      /// The OpenAI API model identifier string used in requests.
      /// This is the actual model name that gets sent to the OpenAI API.
      ///
      /// Example:
      /// ```swift
      /// let model = OpenAI.Model.gpt5Mini(reasoning: .medium)
      /// print(model.rawValue) // "gpt-5-mini"
      /// ```
      ///
      /// - Returns: The API model identifier string.
      public var rawValue: String {
         switch self {
         case .gpt41: "gpt-4.1"
         case .gpt41Mini: "gpt-4.1-mini"
         case .o3: "o3"
         case .o4Mini: "o4-mini"
         case .gpt5: "gpt-5"
         case .gpt5Mini: "gpt-5-mini"
         case .gpt5Nano: "gpt-5-nano"
         }
      }

      /// The reasoning effort level configured for this model, if applicable.
      /// Legacy models (GPT-4.1, o3, o4-mini) don't support reasoning configuration and return nil.
      /// GPT-5 family models return the configured reasoning effort level.
      ///
      /// Example:
      /// ```swift
      /// let gpt5Model = OpenAI.Model.gpt5(reasoning: .high)
      /// print(gpt5Model.reasoning) // Optional(.high)
      ///
      /// let legacyModel = OpenAI.Model.gpt41
      /// print(legacyModel.reasoning) // nil
      /// ```
      ///
      /// - Returns: The reasoning effort level, or nil for legacy models.
      public var reasoning: ReasoningEffort? {
         switch self {
         case .gpt41, .gpt41Mini, .o3, .o4Mini:
            return nil
         case .gpt5(let reasoning), .gpt5Mini(let reasoning), .gpt5Nano(let reasoning):
            return reasoning
         }
      }

      /// The maximum number of tokens this model can process in a single request.
      /// This includes both input and output tokens combined. Use this to ensure your
      /// requests don't exceed the model's capacity.
      ///
      /// Example:
      /// ```swift
      /// let model = OpenAI.Model.gpt5(reasoning: .medium)
      /// print(model.contextWindowTokens) // 400_000
      ///
      /// // Check if your input fits
      /// if myInputTokenCount < model.contextWindowTokens {
      ///     // Safe to proceed
      /// }
      /// ```
      ///
      /// - Returns: Maximum context window size in tokens.
      public var contextWindowTokens: Int {
         switch self {
         case .gpt41: 1_047_576
         case .gpt41Mini: 1_047_576
         case .o3: 200_000
         case .o4Mini: 200_000
         case .gpt5: 400_000
         case .gpt5Mini: 400_000
         case .gpt5Nano: 400_000
         }
      }

      /// The maximum number of tokens this model can generate in a single response.
      /// This is separate from the context window and represents the upper limit
      /// for generated content length.
      ///
      /// Example:
      /// ```swift
      /// let model = OpenAI.Model.gpt5Mini(reasoning: .low)
      /// print(model.maxOutputTokens) // 128_000
      ///
      /// // You can expect responses up to this many tokens
      /// ```
      ///
      /// - Returns: Maximum output tokens per response.
      public var maxOutputTokens: Int {
         switch self {
         case .gpt41: 32_768
         case .gpt41Mini: 32_768
         case .o3: 100_000
         case .o4Mini: 100_000
         case .gpt5: 128_000
         case .gpt5Mini: 128_000
         case .gpt5Nano: 128_000
         }
      }

      /// Cost in USD per million input tokens (text you send to the model).
      /// Use this to calculate costs for your requests and optimize usage.
      /// Pricing is for standard tier and may vary with different service tiers.
      ///
      /// Example:
      /// ```swift
      /// let model = OpenAI.Model.gpt5Mini(reasoning: .medium)
      /// let inputTokens = 1000
      /// let cost = (Double(inputTokens) / 1_000_000) * model.inputUSDPerMillionTokens
      /// print("Input cost: $\(cost)") // Input cost: $0.00025
      /// ```
      ///
      /// - Returns: Cost per million input tokens in USD.
      /// - Note: Pricing last updated August 2025 for standard tier.
      public var inputUSDPerMillionTokens: Double {
         switch self {
         case .gpt41: 2.00
         case .gpt41Mini: 0.40
         case .o3: 2.00
         case .o4Mini: 1.10
         case .gpt5: 1.25
         case .gpt5Mini: 0.25
         case .gpt5Nano: 0.05
         }
      }

      /// Cost in USD per million output tokens (text the model generates).
      /// Output tokens are typically more expensive than input tokens.
      /// Use this to calculate the total cost of responses and budget accordingly.
      ///
      /// Example:
      /// ```swift
      /// let model = OpenAI.Model.gpt5(reasoning: .high)
      /// let outputTokens = 500
      /// let cost = (Double(outputTokens) / 1_000_000) * model.outputUSDPerMillionTokens
      /// print("Output cost: $\(cost)") // Output cost: $0.005
      /// ```
      ///
      /// - Returns: Cost per million output tokens in USD.
      /// - Note: Pricing last updated August 2025 for standard tier.
      public var outputUSDPerMillionTokens: Double {
         switch self {
         case .gpt41: 8.00
         case .gpt41Mini: 1.60
         case .o3: 8.00
         case .o4Mini: 4.40
         case .gpt5: 10.00
         case .gpt5Mini: 2.00
         case .gpt5Nano: 0.40
         }
      }

      /// A user-friendly display name that includes reasoning effort for GPT-5 models.
      /// Legacy models show their basic name, while GPT-5 models include the reasoning level
      /// to help users understand the configuration being used.
      ///
      /// Example:
      /// ```swift
      /// let gpt5 = OpenAI.Model.gpt5(reasoning: .high)
      /// print(gpt5.displayName) // "gpt-5 (high)"
      ///
      /// let legacy = OpenAI.Model.gpt41
      /// print(legacy.displayName) // "gpt-4.1"
      /// ```
      ///
      /// - Returns: User-friendly model name with reasoning level if applicable.
      public var displayName: String {
         switch self {
         case .gpt41, .gpt41Mini, .o3, .o4Mini:
            return self.rawValue
         case .gpt5(let reasoning), .gpt5Mini(let reasoning), .gpt5Nano(let reasoning):
            return "\(self.rawValue) (\(reasoning.rawValue))"
         }
      }

      /// Whether the model supports the `temperature` parameter in the Responses API.
      /// Legacy models support temperature control for randomness, while GPT-5 family
      /// models use their reasoning system for response variation instead.
      ///
      /// Example:
      /// ```swift
      /// let legacy = OpenAI.Model.gpt41
      /// print(legacy.supportsTemperature) // true
      ///
      /// let gpt5 = OpenAI.Model.gpt5(reasoning: .medium)
      /// print(gpt5.supportsTemperature) // false
      /// ```
      ///
      /// - Returns: True if the model supports temperature parameter, false otherwise.
      var supportsTemperature: Bool {
         switch self {
         case .gpt5, .gpt5Mini, .gpt5Nano:
            return false
         case .gpt41, .gpt41Mini, .o3, .o4Mini:
            return true
         }
      }
   }
}
