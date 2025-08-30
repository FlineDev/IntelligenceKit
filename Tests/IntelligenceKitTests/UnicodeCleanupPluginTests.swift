import Foundation
import Testing

@testable import IntelligenceKit

#if canImport(FoundationNetworking)
   import FoundationNetworking
#endif

enum UnicodeCleanupPluginTests {
   @Test static func pluginRemovesNullCharactersFromResponse() throws {
      let plugin = OpenAI.UnicodeCleanupPlugin()

      // Create test data with actual NULL characters (not escaped strings)
      let corruptedJson = """
         {
            "translations": [
               {"text": "Couleur d\u{0000}\u{0000}\u{0000}arrière-plan"},
               {"text": "Moyennes mensuelles de temp\u{0000}e9rature"}
            ]
         }
         """

      var data = corruptedJson.data(using: .utf8)!
      var response = HTTPURLResponse()

      // Verify we actually have NULL characters in the original data
      #expect(corruptedJson.contains("\u{0000}"))

      // Apply the plugin
      try plugin.apply(to: &response, data: &data)

      // Verify NULL characters are removed
      let cleanedString = String(data: data, encoding: .utf8)!
      let expectedJson = """
         {
            "translations": [
               {"text": "Couleur darrière-plan"},
               {"text": "Moyennes mensuelles de tempe9rature"}
            ]
         }
         """

      #expect(cleanedString == expectedJson)
      #expect(!cleanedString.contains("\u{0000}"))
   }

   @Test static func pluginLeavesCleanDataUnchanged() throws {
      let plugin = OpenAI.UnicodeCleanupPlugin()

      // Create test data without NULL characters
      let cleanJson = """
         {
            "translations": [
               {"text": "Couleur d'arrière-plan"},
               {"text": "Moyennes mensuelles de température"}
            ]
         }
         """

      let originalData = cleanJson.data(using: .utf8)!
      var data = originalData
      var response = HTTPURLResponse()

      // Apply the plugin
      try plugin.apply(to: &response, data: &data)

      // Verify data is unchanged
      #expect(data == originalData)
   }
}
