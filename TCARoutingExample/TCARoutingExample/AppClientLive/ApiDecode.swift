import Foundation
import Combine

let jsonDecoder : JSONDecoder = {
    let jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = .iso8601WithFractionalSeconds
    return jsonDecoder
}()

let jsonEncoder = JSONEncoder()

public func apiDecode<A: Decodable>(_ type: A.Type, from data: Data) throws -> A{
    do {
        return try jsonDecoder.decode(A.self, from: data)
    } catch let decodingError{
        let apiError : Error

        if let error = decodingError as? DecodingError {
            var errorToReport = error.localizedDescription
            switch error {
            case .dataCorrupted(let context):
                let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                errorToReport = "\(context.debugDescription) - (\(details))"
            case .keyNotFound(let key, let context):
                let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                errorToReport = "\(context.debugDescription) (key: \(key), \(details))"
            case .typeMismatch(let type, let context), .valueNotFound(let type, let context):
                let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                errorToReport = "\(context.debugDescription) (type: \(type), \(details))"
            @unknown default:
                break
            }
            print (errorToReport)
            
            apiError = error
            
        }  else {
            do {
                apiError = try jsonDecoder.decode(ApiError.self, from: data)
            } catch{
                throw decodingError
            }
        }
        throw apiError
    }
}
