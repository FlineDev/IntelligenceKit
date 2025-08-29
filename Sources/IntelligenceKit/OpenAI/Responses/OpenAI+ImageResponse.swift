import Foundation
import HandySwift

extension OpenAI {
   public struct ImageResponse: AutoConforming {
      public struct Image: AutoConforming {
         public let url: URL
      }

      public let data: [Image]
   }
}
