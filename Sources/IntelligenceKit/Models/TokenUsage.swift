import Foundation

/// Token usage information for API requests, useful for cost tracking and optimization.
/// This structure provides a standardized way to represent token consumption across
/// different AI services and models within the IntelligenceKit ecosystem.
///
/// Example:
/// ```swift
/// let usage = TokenUsage(inputTokens: 100, outputTokens: 50, totalTokens: 150)
/// 
/// // Calculate costs using model pricing
/// let model = OpenAI.Model.gpt5Mini(reasoning: .medium)
/// let inputCost = Double(usage.inputTokens) / 1_000_000 * model.inputUSDPerMillionTokens
/// let outputCost = Double(usage.outputTokens) / 1_000_000 * model.outputUSDPerMillionTokens
/// let totalCost = inputCost + outputCost
/// ```
public struct TokenUsage: Codable {
   public let inputTokens: Int
   public let outputTokens: Int
   public let totalTokens: Int
   
   /// Initialize a new TokenUsage instance.
   ///
   /// - Parameters:
   ///   - inputTokens: Number of input tokens consumed.
   ///   - outputTokens: Number of output tokens generated.
   ///   - totalTokens: Total tokens used (should equal inputTokens + outputTokens).
   public init(inputTokens: Int, outputTokens: Int, totalTokens: Int) {
      self.inputTokens = inputTokens
      self.outputTokens = outputTokens
      self.totalTokens = totalTokens
   }
}
