import Foundation
import HandySwift

public final class OpenAI: Sendable {
   let restClient: RESTClient

   public init(apiKey: String, urlSession: URLSession = .shared) {
      self.restClient = RESTClient(
         baseURL: URL(string: "https://api.openai.com/")!,
         baseHeaders: ["Authorization": "Bearer \(apiKey)", "Content-Type": "application/json"],
         jsonDecoder: .snakeCase,
         urlSession: urlSession,
         baseErrorContext: "OpenAI",
         errorBodyToMessage: { try JSONDecoder.snakeCase.decode(ErrorResponse.self, from: $0).error.message }
      )
   }

   /// Ask the model to generate a response.
   /// - Parameters:
   ///   - model: OpenAI model to use (includes reasoning level for GPT-5 family)
   ///   - input: User's message or question content
   ///   - instructions: System-level behavior instructions (equivalent to system messages)
   ///   - verbosity: Response length and detail level (low/medium/high)

   ///   - responseFormat: Optional JSON Schema for structured output
   ///   - previousResponseID: ID from previous response to continue conversation
   ///   - store: Whether to store conversation on OpenAI servers (default: true)
   ///   - serviceTier: Processing tier (auto/default/flex/priority, default: auto)
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
