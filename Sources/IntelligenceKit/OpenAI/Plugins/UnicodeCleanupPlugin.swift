import Foundation
import HandySwift

#if canImport(FoundationNetworking)
   import FoundationNetworking
#endif

extension OpenAI {
   /// Response plugin that cleans up NULL characters from OpenAI API responses.
   ///
   /// This addresses a known issue where the OpenAI Responses API sometimes returns NULL characters
   /// in place of Unicode characters, particularly affecting non-English languages with accented characters.
   /// The plugin automatically removes these NULL characters from response data before JSON parsing.
   ///
   /// Note: This plugin is automatically included in the OpenAI client and requires no setup.
   struct UnicodeCleanupPlugin: RESTClient.ResponsePlugin {
      /// Removes NULL characters from the response data to fix Unicode encoding issues.
      /// - Parameters:
      ///   - response: The HTTP response (unused but required by protocol)
      ///   - data: The response data to clean up – NULL characters will be removed
      func apply(to response: inout HTTPURLResponse, data: inout Data) throws {
         // Convert data to string, remove NULL characters, then back to data
         if let string = String(data: data, encoding: .utf8), string.contains("\u{0000}") {
            let cleanedString = string.replacing("\u{0000}", with: "")
            if let cleanedData = cleanedString.data(using: .utf8) {
               data = cleanedData
            }
         }
      }
   }
}
