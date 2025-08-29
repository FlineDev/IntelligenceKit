import Foundation
import HandySwift

extension OpenAI {
   public enum Model: Sendable, Equatable {
      // Legacy models (for comparison and migration)
      case gpt41
      case gpt41Mini
      case o3
      case o4Mini

      // GPT-5 family (with reasoning support)
      case gpt5(reasoning: ReasoningEffort)
      case gpt5Mini(reasoning: ReasoningEffort)
      case gpt5Nano(reasoning: ReasoningEffort)

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

      public var reasoning: ReasoningEffort? {
         switch self {
         case .gpt41, .gpt41Mini, .o3, .o4Mini:
            return nil
         case .gpt5(let reasoning), .gpt5Mini(let reasoning), .gpt5Nano(let reasoning):
            return reasoning
         }
      }

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

      /// Input pricing in USD per million tokens.
      /// Last updated: August 2025 (Standard tier)
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

      /// Output pricing in USD per million tokens.
      /// Last updated: August 2025 (Standard tier)
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

      /// A display name that includes reasoning effort for GPT-5 models
      public var displayName: String {
         switch self {
         case .gpt41, .gpt41Mini, .o3, .o4Mini:
            return self.rawValue
         case .gpt5(let reasoning), .gpt5Mini(let reasoning), .gpt5Nano(let reasoning):
            return "\(self.rawValue) (\(reasoning.rawValue))"
         }
      }

      /// Whether the model supports the `temperature` parameter in the Responses API
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
