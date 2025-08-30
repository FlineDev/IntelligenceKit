import Foundation
import HandySwift

#if canImport(FoundationNetworking)
   import FoundationNetworking
#endif

/// OpenAI API client for the modern Responses API with GPT-5 support.
/// Provides a clean, type-safe interface for interacting with OpenAI's language models
/// including advanced reasoning capabilities and conversation continuity.
///
/// Example:
/// ```swift
/// let openAI = OpenAI(apiKey: "your-openai-api-key")
/// let response = try await openAI.ask(
///     model: .gpt5Mini(reasoning: .medium),
///     input: "Hello, world!"
/// )
/// ```
public final class OpenAI: Sendable {
   let restClient: RESTClient

   /// Initialize the OpenAI client with your API key.
   ///
   /// Get your API key from the OpenAI Platform at https://platform.openai.com/api-keys
   /// Make sure your key has sufficient credits and access to the models you plan to use.
   ///
   /// Example:
   /// ```swift
   /// let openAI = OpenAI(apiKey: "sk-...")
   ///
   /// // With custom URL session for advanced networking
   /// let customSession = URLSession(configuration: .default)
   /// let openAI = OpenAI(apiKey: "sk-...", urlSession: customSession)
   /// ```
   ///
   /// - Parameters:
   ///   - apiKey: Your OpenAI API key from the OpenAI Platform.
   ///   - urlSession: URLSession to use for requests (default: URLSession.shared).
   public init(apiKey: String, urlSession: URLSession = .shared) {
      self.restClient = RESTClient(
         baseURL: URL(string: "https://api.openai.com/")!,
         baseHeaders: ["Authorization": "Bearer \(apiKey)", "Content-Type": "application/json"],
         jsonDecoder: .snakeCase,
         urlSession: urlSession,
         responsePlugins: [UnicodeCleanupPlugin()],
         baseErrorContext: "OpenAI",
         errorBodyToMessage: { try JSONDecoder.snakeCase.decode(ErrorResponse.self, from: $0).error.message }
      )
   }

   /// Ask the OpenAI model to generate a response using the modern Responses API.
   /// This method provides a unified interface for interacting with all supported OpenAI models,
   /// including the advanced GPT-5 family with reasoning capabilities.
   ///
   /// The Responses API offers better performance, lower costs through caching, and advanced
   /// features like reasoning control and conversation continuity compared to the legacy Chat Completions API.
   ///
   /// Example:
   /// ```swift
   /// let openAI = OpenAI(apiKey: "your-api-key")
   ///
   /// // Simple question with GPT-5-mini
   /// let response = try await openAI.ask(
   ///     model: .gpt5Mini(reasoning: .medium),
   ///     input: "Explain Swift's type system"
   /// )
   /// print(response.outputText)
   ///
   /// // Complex task with detailed instructions
   /// let response = try await openAI.ask(
   ///     model: .gpt5(reasoning: .high),
   ///     input: "Optimize this algorithm for performance",
   ///     instructions: "You are an expert software engineer. Provide detailed explanations.",
   ///     verbosity: .high
   /// )
   ///
   /// // Continue a conversation
   /// let followUp = try await openAI.ask(
   ///     model: .gpt5Mini(reasoning: .low),
   ///     input: "Can you simplify that explanation?",
   ///     previousResponseID: response.id
   /// )
   /// ```
   ///
   /// - Parameters:
   ///   - model: The OpenAI model to use. GPT-5 family models include reasoning configuration.
   ///   - input: The user's message, question, or content to process.
   ///   - instructions: Optional system-level instructions that guide the model's behavior and tone.
   ///   - verbosity: Optional response length preference (low for concise, high for detailed).
   ///   - responseFormat: Optional JSON Schema for structured output instead of plain text.
   ///   - previousResponseID: Optional ID from a previous response to continue the conversation.
   ///   - store: Whether to store the conversation on OpenAI servers for future reference (default: true).
   ///   - serviceTier: Processing priority tier affecting speed and cost (default: auto).
   ///
   /// - Returns: A Response object containing the generated text, token usage, and metadata.
   /// - Throws: OpenAI.Error for API errors, network issues, or invalid requests.
   public func ask(
      model: Model,
      input: String,
      instructions: String? = nil,
      verbosity: TextVerbosity? = nil,

      responseFormat: ResponseFormat? = nil,
      previousResponseID: String? = nil,
      store: Bool? = nil,
      serviceTier: ServiceTier? = nil
   ) async throws(OpenAI.Error) -> Response {
      let reasoningParam = model.reasoning.map { Request.Reasoning(effort: $0) }
      let verbosityParam = verbosity.map { Request.Text(verbosity: $0, format: responseFormat) }

      let request = Request(
         model: model.rawValue,
         input: input,
         instructions: instructions,
         reasoning: reasoningParam,
         text: verbosityParam,

         previousResponseID: previousResponseID,
         store: store,
         serviceTier: serviceTier
      )

      do {
         return try await self.restClient.fetchAndDecode(method: .post, path: "v1/responses", body: .json(request))
      } catch {
         throw .requestError(error)
      }
   }

   /// Generate images using DALL-E models.
   /// - Parameters:
   ///   - request: Image generation request with prompt, model, quality, and style parameters
   /// - Returns: Response containing URLs to generated images
   /// - Throws: OpenAI.Error for various failure cases
   public func createImage(request: ImageRequest) async throws(OpenAI.Error) -> ImageResponse {
      do {
         return try await self.restClient.fetchAndDecode(method: .post, path: "v1/images/generations", body: .json(request))
      } catch {
         throw .requestError(error)
      }
   }
}
