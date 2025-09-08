import Foundation
import HandySwift

extension OpenAI {
   /// Request configuration for DALL⋅E image generation.
   public struct ImageRequest: Encodable, Sendable {
      /// The model to use for image generation.
      public enum Model: Encodable, Identifiable, Hashable, Sendable, CustomStringConvertible {
         /// DALL⋅E 2 model for image generation.
         case dallE2(size: DallE2Size)
         /// DALL⋅E 3 model for image generation with improved quality and understanding.
         case dallE3(size: DallE3Size, quality: Quality, style: Style)

         public var id: String {
            switch self {
            case .dallE2: "dall-e-2"
            case .dallE3: "dall-e-3"
            }
         }

         public var description: String {
            switch self {
            case .dallE2: "DALL⋅E 2"
            case .dallE3: "DALL⋅E 3"
            }
         }

         // Custom encoding to handle the model name and associated values
         public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .dallE2:
               try container.encode("dall-e-2")
            case .dallE3:
               try container.encode("dall-e-3")
            }
         }
      }

      /// Image sizes supported by DALL⋅E 2.
      public enum DallE2Size: String, Encodable, CaseIterable, Identifiable, Hashable, Sendable, CustomStringConvertible {
         case square256 = "256x256"
         case square512 = "512x512"
         case square1024 = "1024x1024"

         public var id: Self { self }
         public var description: String { self.rawValue }
      }

      /// Image sizes supported by DALL⋅E 3.
      public enum DallE3Size: String, Encodable, CaseIterable, Identifiable, Hashable, Sendable, CustomStringConvertible {
         case square1024 = "1024x1024"
         case landscape7x4H1024 = "1792x1024"  // 7:4 aspect ratio, 1024px height
         case portrait4x7W1024 = "1024x1792"  // 4:7 aspect ratio, 1024px width

         public var id: Self { self }
         public var description: String { self.rawValue }
      }

      /// The quality of the generated image. Only supported for DALL⋅E 3.
      public enum Quality: String, Encodable, CaseIterable, Identifiable, Hashable, Sendable, CustomStringConvertible {
         /// High-definition quality with finer details and greater consistency across the image.
         case hd
         /// Standard quality image generation.
         case standard

         public var id: Self { self }
         public var description: String {
            switch self {
            case .hd: "HD"
            case .standard: "Standard"
            }
         }
      }

      /// The style of the generated images. Only supported for DALL⋅E 3.
      public enum Style: String, Encodable, CaseIterable, Identifiable, Hashable, Sendable, CustomStringConvertible {
         /// Vivid style causes the model to lean towards generating hyper-real and dramatic images.
         case vivid
         /// Natural style causes the model to produce more natural, less hyper-real looking images.
         case natural

         public var id: Self { self }
         public var description: String { self.rawValue.firstUppercased }
      }

      /// A text description of the desired image(s). The maximum length is 1000 characters for DALL⋅E 2 and 4000 characters for DALL⋅E 3.
      public let prompt: String

      /// The model to use for image generation.
      public let model: Model

      /// Creates a new image generation request.
      /// - Parameters:
      ///   - prompt: A text description of the desired image(s). Maximum 1000 characters for DALL⋅E 2 and 4000 for DALL⋅E 3.
      ///   - model: The model to use for image generation with all model-specific parameters embedded.
      public init(prompt: String, model: Model) {
         self.prompt = prompt
         self.model = model
      }

      // Custom encoding to handle model-specific parameters
      public func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(self.prompt, forKey: .prompt)
         try container.encode(self.model, forKey: .model)

         // Encode model-specific parameters
         switch self.model {
         case let .dallE2(size):
            try container.encode(size, forKey: .size)

         case let .dallE3(size, quality, style):
            try container.encode(size, forKey: .size)
            try container.encode(quality, forKey: .quality)
            try container.encode(style, forKey: .style)
         }
      }

      private enum CodingKeys: String, CodingKey {
         case prompt
         case model
         case size
         case quality
         case style
      }
   }
}
