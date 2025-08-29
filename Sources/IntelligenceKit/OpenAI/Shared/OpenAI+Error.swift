import ErrorKit
import Foundation
import HandySwift

extension OpenAI {
   public enum Error: Throwable {
      case emptyResponse
      case contentFilterApplied
      case maxLengthExceeded
      case unexpectedMessageRole
      case jsonSchemaDecodingError(Swift.Error)
      case requestError(RESTClient.APIError)

      public var userFriendlyMessage: String {
         switch self {
         case .emptyResponse:
            String.localized(
               key: "OpenAI.Error.emptyResponse",
               defaultValue: "OpenAI returned an empty response"
            )
         case .contentFilterApplied:
            String.localized(
               key: "OpenAI.Error.contentFilterApplied",
               defaultValue: "Content was filtered by OpenAI's safety system"
            )
         case .maxLengthExceeded:
            String.localized(
               key: "OpenAI.Error.maxLengthExceeded",
               defaultValue: "Response exceeded maximum length limit"
            )
         case .unexpectedMessageRole:
            String.localized(
               key: "OpenAI.Error.unexpectedMessageRole",
               defaultValue: "Received unexpected message role in response"
            )
         case .jsonSchemaDecodingError(let error):
            String.localized(
               key: "OpenAI.Error.jsonSchemaDecodingError",
               defaultValue: "Failed to decode structured response: \(error.localizedDescription)"
            )
         case .requestError(let error):
            String.localized(
               key: "OpenAI.Error.requestError", 
               defaultValue: "Network request failed: \(error.errorDescription ?? "Unknown error")"
            )
         }
      }
   }
}
