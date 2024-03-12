import Foundation

public struct ApiError: Codable, Error, Equatable, LocalizedError{
    public let message: String

    public init( error: Error) {
      var string = ""
      self.message = error.localizedDescription
    }
    
    public init( message: String){
        self.message = message
    }

    public var errorDescription: String? {
      self.message
    }
}
