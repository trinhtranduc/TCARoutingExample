import Foundation

extension Formatter{
    static let customDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withFractionalSeconds, .withColonSeparatorInTimeZone]
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy{
    static var iso8601WithFractionalSeconds = custom { decoder in
        let dateStr = try decoder.singleValueContainer().decode(String.self)
        let customIsoFormatter = Formatter.customDateFormatter
        print (customIsoFormatter.string(from: Date()))
        if let date = customIsoFormatter.date(from: dateStr) {
            return date
        }
        throw DecodingError.dataCorrupted(
            DecodingError.Context(codingPath: decoder.codingPath,
                                  debugDescription: "Invalid date"))
    }
}
