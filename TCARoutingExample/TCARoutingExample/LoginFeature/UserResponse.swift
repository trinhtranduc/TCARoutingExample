import Foundation

public struct BaseTransactionResponse: Codable, Hashable, Sendable{
    var transactionId: String?
    var httpStatus: String?
    var resultCode: Int?
    var resultMsg: String = ""
    var resourceId: Int?
    var resourceURL: String?
    
    enum CodingKeys: String, CodingKey{
        case transactionId
        case httpStatus
        case resultCode
        case resultMsg
        case resourceId
        case resourceURL
    }
    
    public init(){}
    
    public init(from decoder:Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactionId = try values.decodeIfPresent(String.self, forKey: .transactionId)
        httpStatus = try values.decodeIfPresent(String.self, forKey: .httpStatus)
        resultCode = try values.decodeIfPresent(Int.self, forKey: .resultCode)
        resultMsg = try values.decode(String.self, forKey: .resultMsg)
        resourceId = try values.decodeIfPresent(Int.self, forKey: .resourceId)
        resourceURL = try values.decodeIfPresent(String.self, forKey: .resourceURL)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(transactionId, forKey: .transactionId)
        try container.encodeIfPresent(httpStatus, forKey: .httpStatus)
        try container.encodeIfPresent(resultCode, forKey: .resultCode)
        try container.encodeIfPresent(resultMsg, forKey: .resultMsg)
        try container.encodeIfPresent(resourceId, forKey: .resourceId)
        try container.encodeIfPresent(resourceURL, forKey: .resourceURL)
    }
}

public struct UserResponse: Codable, Hashable, Sendable{
    var transactionId: String?
    var httpStatus: String?
    var resultCode: Int?
    var resultMsg: String = ""
    var resourceId: Int?
    var resourceURL: String?
    var user: User?
    
    enum CodingKeys: String, CodingKey{
        case transactionId
        case httpStatus
        case resultCode
        case resultMsg
        case resourceId
        case resourceURL
        case user = "data"
    }
    
    init(){}
    
    public init(from decoder:Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactionId = try values.decodeIfPresent(String.self, forKey: .transactionId)
        httpStatus = try values.decodeIfPresent(String.self, forKey: .httpStatus)
        resultCode = try values.decodeIfPresent(Int.self, forKey: .resultCode)
        resultMsg = try values.decode(String.self, forKey: .resultMsg)
        resourceId = try values.decodeIfPresent(Int.self, forKey: .resourceId)
        resourceURL = try values.decodeIfPresent(String.self, forKey: .resourceURL)

        user = try values.decodeIfPresent(User.self, forKey: .user)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(transactionId, forKey: .transactionId)
        try container.encodeIfPresent(httpStatus, forKey: .httpStatus)
        try container.encodeIfPresent(resultCode, forKey: .resultCode)
        try container.encodeIfPresent(resultMsg, forKey: .resultMsg)
        try container.encodeIfPresent(resourceId, forKey: .resourceId)
        try container.encodeIfPresent(resourceURL, forKey: .resourceURL)
        try container.encodeIfPresent(user, forKey: .user)
    }
}

public struct User: Codable, Hashable, Sendable{
    var email: String?
    var jwt: String
    var id: Int
    var profilePicUrl: String? = nil
    var mobileNumber: String? = nil
    var fullName: String? = nil
    var userName: String? = nil
    var team: Team?
    
    enum CodingKeys: String, CodingKey{
        case jwt
        case email
        case fullName
        case id
        case profilePicUrl
        case mobileNumber
        case userName
        case team = "teamDetail"
    }
    
    public init(from decoder:Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        jwt = try values.decode(String.self, forKey: .jwt)
        email = try values.decode(String.self, forKey: .email)
        id = try values.decode(Int.self, forKey: .id)
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        profilePicUrl = try values.decodeIfPresent(String.self, forKey: .profilePicUrl)
        mobileNumber = try values.decodeIfPresent(String.self, forKey: .mobileNumber)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        team = try values.decodeIfPresent(Team.self, forKey: .team)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(jwt, forKey: .jwt)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(profilePicUrl, forKey: .profilePicUrl)
        try container.encodeIfPresent(mobileNumber, forKey: .mobileNumber)
        try container.encodeIfPresent(fullName, forKey: .fullName)
        try container.encodeIfPresent(userName, forKey: .userName)
        try container.encodeIfPresent(team, forKey: .team)
    }
}


public struct Team: Codable, Hashable, Sendable{
    var id: Int
    var name: String
    var teamOwnerId: Int
    var teamOwnerEmail: String
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case teamOwnerId
        case teamOwnerEmail
    }
    
    public init(from decoder:Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        teamOwnerId = try values.decode(Int.self, forKey: .teamOwnerId)
        teamOwnerEmail = try values.decode(String.self, forKey: .teamOwnerEmail)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(teamOwnerId, forKey: .teamOwnerId)
        try container.encodeIfPresent(teamOwnerEmail, forKey: .teamOwnerEmail)
    }
    
}


