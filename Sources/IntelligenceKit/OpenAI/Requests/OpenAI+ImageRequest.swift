import Foundation
import HandySwift

extension OpenAI {
   /// Request configuration for GPT-Image 1 generation.
   public struct ImageRequest: Encodable, Sendable {
      /// The model to use for image generation.
      public enum Model: String, Encodable, CaseIterable, Identifiable, Hashable, Sendable, CustomStringConvertible {
         /// GPT-Image 1 model for advanced image generation and manipulation.
         case gptImage1 = "gpt-image-1"

         public var id: Self { self }
         public var description: String {
            switch self {
            case .gptImage1: "GPT-Image 1"
            }
         }
      }

      /// The quality of the generated image.
      public enum Quality: String, Encodable, CaseIterable, Identifiable, Hashable, Sendable, CustomStringConvertible {
         /// Low quality - faster generation, lower cost.
         case low
         /// Medium quality - balanced speed and quality.
         case medium
         /// High quality - best quality, slower generation, higher cost.
         case high

         public var id: Self { self }
         public var description: String {
            switch self {
            case .low: "Low"
            case .medium: "Medium"
            case .high: "High"
            }
         }
      }

      /// The size of the generated image.
      public enum Size: String, Encodable, CaseIterable, Identifiable, Hashable, Sendable, CustomStringConvertible {
         /// Square 1024x1024 format - faster generation.
         case square1024 = "1024x1024"
         /// Portrait 1024x1536 format.
         case portraitH1024 = "1024x1536"
         /// Landscape 1536x1024 format.
         case landscapeH1024 = "1536x1024"

         public var id: Self { self }
         public var description: String {
            switch self {
            case .square1024: "Square (1024×1024)"
            case .portraitH1024: "Portrait (1024×1536)"
            case .landscapeH1024: "Landscape (1536×1024)"
            }
         }
      }

      /// A text description of the desired image(s).
      public let prompt: String

      /// The model to use for image generation.
      public let model: Model

      /// The quality of the image that will be generated.
      public let quality: Quality

      /// The size of the generated image.
      public let size: Size

      /// Base64-encoded image data for image-to-image operations (optional).
      public let image: String?

      /// Base64-encoded mask image data for inpainting operations (optional).
      public let mask: String?

      /// Creates a new image generation request.
      /// - Parameters:
      ///   - prompt: A text description of the desired image(s).
      ///   - model: The model to use for image generation.
      ///   - quality: The quality of the image.
      ///   - size: The size of the generated image.
      ///   - image: Base64-encoded image data for image-to-image operations.
      ///   - mask: Base64-encoded mask image data for inpainting operations.
      public init(prompt: String, model: Model, quality: Quality, size: Size, image: String? = nil, mask: String? = nil) {
         self.prompt = prompt
         self.model = model
         self.quality = quality
         self.size = size
         self.image = image
         self.mask = mask
      }
   }
}
