import Foundation

public struct TokenUsage: Codable {
   public let inputTokens: Int
   public let outputTokens: Int
   public let totalTokens: Int
   
   public init(inputTokens: Int, outputTokens: Int, totalTokens: Int) {
      self.inputTokens = inputTokens
      self.outputTokens = outputTokens
      self.totalTokens = totalTokens
   }
}
