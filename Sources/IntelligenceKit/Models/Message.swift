import Foundation
import HandySwift

public struct Message: AutoConforming {
   public enum Role: String, AutoConforming {
      case system
      case user
      case assistant
   }

   public let role: Role
   public let content: String

   public init(role: Role, content: String) {
      self.role = role
      self.content = content
   }
}
