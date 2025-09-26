import Foundation
import HandySwift

extension OpenAI {
   /// Request configuration for GPT-Image 1 image generation and editing.
   public struct ImageRequest: Encodable, Sendable {
      /// The model to use for image generation.
      public enum Model: Encodable, Identifiable, Hashable, Sendable, CustomStringConvertible {
         /// GPT-Image 1 model for advanced image generation and editing with transparent background support.
         case gptImage1(size: Size, quality: Quality, background: Background)

         public var id: String {
            switch self {
            case .gptImage1: "gpt-image-1"
            }
         }

         public var description: String {
            switch self {
            case .gptImage1: "GPT-Image 1"
            }
         }

         // Custom encoding to handle the model name and associated values
         public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .gptImage1:
               try container.encode("gpt-image-1")
            }
         }
      }

      /// Image sizes supported by GPT-Image 1.
      public enum Size: String, Encodable, CaseIterable, Identifiable, Hashable, Sendable, CustomStringConvertible {
         case square1024 = "1024x1024"  // Square format, ideal for icons and logos
         case landscape1024x1536 = "1024x1536"  // Landscape format
         case portrait1536x1024 = "1536x1024"  // Portrait format
         case auto = "auto"  // Let the model choose the best size

         public var id: Self { self }
         public var description: String {
            switch self {
            case .square1024: "1024×1024 (Square)"
            case .landscape1024x1536: "1024×1536 (Landscape)"
            case .portrait1536x1024: "1536×1024 (Portrait)"
            case .auto: "Auto (Model chooses)"
            }
         }
      }

      /// The quality of the generated image. Supported for GPT-Image 1.
      public enum Quality: String, Encodable, CaseIterable, Identifiable, Hashable, Sendable, CustomStringConvertible {
         /// High quality image generation with finer details.
         case high
         /// Medium quality image generation (balanced speed and quality).
         case medium
         /// Low quality image generation (faster generation).
         case low
         /// Automatic quality selection by the model.
         case auto

         public var id: Self { self }
         public var description: String {
            switch self {
            case .high: "High"
            case .medium: "Medium"
            case .low: "Low"
            case .auto: "Auto"
            }
         }
      }

      /// The background type for the generated image. Supported for GPT-Image 1.
      public enum Background: String, Encodable, CaseIterable, Identifiable, Hashable, Sendable, CustomStringConvertible {
         /// Transparent background (requires PNG or WebP format).
         case transparent
         /// Opaque background with solid color or content.
         case opaque
         /// Automatic background selection by the model.
         case auto

         public var id: Self { self }
         public var description: String {
            switch self {
            case .transparent: "Transparent"
            case .opaque: "Opaque"
            case .auto: "Auto"
            }
         }
      }

      /// A text description of the desired image. Maximum 4000 characters for GPT-Image 1.
      public let prompt: String

      /// The model to use for image generation.
      public let model: Model

      /// Optional image data for edit operations (base64 encoded PNG).
      public let image: String?

      /// Optional mask for edit operations (base64 encoded PNG with transparent areas indicating regions to edit).
      public let mask: String?

      /// Creates a new image generation request.
      /// - Parameters:
      ///   - prompt: A text description of the desired image. Maximum 4000 characters for GPT-Image 1.
      ///   - model: The model to use for image generation with all model-specific parameters embedded.
      ///   - image: Optional base64 encoded image data for edit operations.
      ///   - mask: Optional base64 encoded mask for targeted edits.
      public init(prompt: String, model: Model, image: String? = nil, mask: String? = nil) {
         self.prompt = prompt
         self.model = model
         self.image = image
         self.mask = mask
      }

      // Custom encoding to handle model-specific parameters
      public func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(self.prompt, forKey: .prompt)
         try container.encode(self.model, forKey: .model)

         // Encode optional image data
         if let image = image {
            try container.encode(image, forKey: .image)
         }
         if let mask = mask {
            try container.encode(mask, forKey: .mask)
         }

         // Encode model-specific parameters
         switch self.model {
         case let .gptImage1(size, quality, background):
            try container.encode(size, forKey: .size)
            try container.encode(quality, forKey: .quality)
            try container.encode(background, forKey: .background)
         }
      }

      private enum CodingKeys: String, CodingKey {
         case prompt
         case model
         case size
         case quality
         case background
         case image
         case mask
      }
   }
}
