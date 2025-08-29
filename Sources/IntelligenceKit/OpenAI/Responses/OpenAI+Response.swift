import Foundation
import HandySwift

extension OpenAI {
   /// Response from the OpenAI Responses API containing the generated content and metadata.
   /// This structure provides access to the generated text, token usage information,
   /// and additional response details from the API.
   ///
   /// Example:
   /// ```swift
   /// let response = try await openAI.ask(
   ///     model: .gpt5Mini(reasoning: .medium),
   ///     input: "Hello, world!"
   /// )
   /// 
   /// // Get the generated text
   /// print(response.outputText)
   /// 
   /// // Check token usage for cost calculation
   /// print("Used \(response.usage.totalTokens) tokens")
   /// print("Cost: $\((response.usage.totalTokens * model.inputUSDPerMillionTokens) / 1_000_000)")
   /// ```
   public struct Response: AutoConforming {
      
      /// Token usage information for the API request.
      /// Contains detailed breakdown of input, output, and total token consumption
      /// which is essential for cost tracking and optimization.
      public struct Usage: AutoConforming {
         public let inputTokens: Int
         public let outputTokens: Int
         public let totalTokens: Int

         /// Converts the usage data to a TokenUsage object for compatibility with other APIs.
         /// 
         /// Example:
         /// ```swift
         /// let tokenUsage = response.usage.tokenUsage
         /// // Use with other IntelligenceKit components
         /// ```
         public var tokenUsage: TokenUsage {
            TokenUsage(inputTokens: self.inputTokens, outputTokens: self.outputTokens, totalTokens: self.totalTokens)
         }
      }

      /// Individual output item from the response, which can contain different types of content.
      /// The Responses API can return multiple output items including the main message
      /// and reasoning traces (for GPT-5 models with reasoning enabled).
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

      /// Unique identifier for this response, useful for conversation continuity.
      /// Pass this ID as previousResponseID in subsequent requests to maintain context.
      public let id: String
      
      /// Object type identifier from the API (typically "response").
      public let object: String
      
      /// Token usage information for cost calculation and monitoring.
      public let usage: Usage
      
      /// Array of output items containing the response content and any reasoning traces.
      public let output: [OutputItem]

      /// Convenience property to get the main response text directly.
      /// Extracts the text from the first message-type output item, which is typically
      /// what you want to display to users.
      ///
      /// Example:
      /// ```swift
      /// let response = try await openAI.ask(model: .gpt5Mini(reasoning: .medium), input: "Hello!")
      /// print(response.outputText) // "Hello! How can I help you today?"
      /// ```
      ///
      /// - Returns: The generated text, or empty string if no message content is found.
      public var outputText: String {
         self.output.first { $0.type == .message }?.content?.first?.text ?? ""
      }
   }
}

extension OpenAI.Response {
   /// Extract the main text message from the response with error handling.
   /// Unlike the outputText property, this method throws an error if no message content is found,
   /// making it safer for cases where you expect a response.
   ///
   /// Example:
   /// ```swift
   /// let response = try await openAI.ask(model: .gpt5Mini(reasoning: .medium), input: "Hello!")
   /// let message = try response.textMessage()
   /// print(message) // Guaranteed to have content or throw an error
   /// ```
   ///
   /// - Returns: The text content from the main message output item.
   /// - Throws: OpenAI.Error.emptyResponse if no message content is found.
   public func textMessage() throws(OpenAI.Error) -> String {
      guard let outputItem = self.output.first(where: { $0.type == .message }) else { throw .emptyResponse }
      guard let content = outputItem.content?.first else { throw .emptyResponse }
      return content.text
   }

   /// Decode the response text as JSON into a specified type.
   /// Useful when using responseFormat with JSON Schema to get structured data from the model.
   ///
   /// Example:
   /// ```swift
   /// struct Person: Codable {
   ///     let name: String
   ///     let age: Int
   /// }
   /// 
   /// let response = try await openAI.ask(
   ///     model: .gpt5Mini(reasoning: .medium),
   ///     input: "Generate a person",
   ///     responseFormat: .jsonSchema(schema: personSchema)
   /// )
   /// let person = try response.jsonMessage(decodedTo: Person.self)
   /// print("Name: \(person.name), Age: \(person.age)")
   /// ```
   ///
   /// - Parameter decodedTo: The type to decode the JSON response into.
   /// - Returns: The decoded object of the specified type.
   /// - Throws: OpenAI.Error.emptyResponse if no content, or jsonSchemaDecodingError if JSON parsing fails.
   public func jsonMessage<T: Decodable>(decodedTo: T.Type) throws(OpenAI.Error) -> T {
      let textMessage = try self.textMessage()
      do {
         return try JSONDecoder().decode(T.self, from: Data(textMessage.utf8))
      } catch {
         throw .jsonSchemaDecodingError(error)
      }
   }
}
