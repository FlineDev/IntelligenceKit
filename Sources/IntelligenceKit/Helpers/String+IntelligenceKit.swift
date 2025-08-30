import Foundation

extension String {
   #if canImport(CryptoKit)
      // On Apple platforms, use the modern localization API
      static func localized(key: StaticString, defaultValue: String.LocalizationValue) -> String {
         String(
            localized: key,
            defaultValue: defaultValue
         )
      }
   #else
      // On non-Apple platforms, just return the default value (the English translation)
      static func localized(key: StaticString, defaultValue: String) -> String {
         defaultValue
      }
   #endif
}
