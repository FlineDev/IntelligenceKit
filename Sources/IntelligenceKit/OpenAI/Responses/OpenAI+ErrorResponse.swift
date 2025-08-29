import Foundation
import HandySwift

extension OpenAI {
   struct ErrorResponse: AutoConforming {
      struct Error: AutoConforming {
         let message: String
      }

      let error: Error
   }
}
