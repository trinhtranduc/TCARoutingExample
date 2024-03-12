import Foundation
import SwiftUI
import ComposableArchitecture

struct ScanItem: Identifiable, Codable, Equatable, Sendable{
    var id : Int
    var scanNo: String
    var dataTaken: Date?
    var isFromTeam: Bool = false
    
    init(id: Int, scanNo: String, dataTaken: Date) {
        self.id = id
        self.scanNo = scanNo
        self.dataTaken = dataTaken
    }
    
    enum CodingKeys: String, CodingKey{
        case status
        case scanNo = "scanNo"
        case id
        case dataTaken = "initiatedAt"
        case isFromTeam
    }
    
    init(from decoder:Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        scanNo = try values.decode(String.self, forKey: .scanNo)
        dataTaken = try values.decode(Date.self, forKey: .dataTaken)
        isFromTeam = try values.decodeIfPresent(Bool.self, forKey: .isFromTeam) ?? false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(dataTaken, forKey: .dataTaken)
        try container.encodeIfPresent(scanNo, forKey: .scanNo)
        try container.encodeIfPresent(isFromTeam, forKey: .isFromTeam)
    }
    
    static func dummy() -> ScanItem{
        return ScanItem(id: 1, scanNo: "123", dataTaken:  Date())
    }
}

struct ScanItemResponse: Codable,@unchecked Sendable{
    var transactionId: String? = nil
    var httpStatus: String? = nil
    var resultCode: Int? = nil
    var resultMsg: String? = ""
    var resourceId: Int? = nil
    var resourceURL: String? = nil
    var data: ScanItemData?

    enum CodingKeys: String, CodingKey{
        case transactionId
        case httpStatus
        case resultCode
        case resultMsg
        case resourceId
        case resourceURL
        case data
    }
    
    init(data: ScanItemData){
        self.data = data
    }
    
    init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactionId = try values.decodeIfPresent(String.self, forKey: .transactionId)
        httpStatus = try values.decodeIfPresent(String.self, forKey: .httpStatus)
        resultCode = try values.decodeIfPresent(Int.self, forKey: .resultCode)
        resultMsg = try values.decode(String.self, forKey: .resultMsg)
        resourceId = try values.decodeIfPresent(Int.self, forKey: .resourceId)
        resourceURL = try values.decodeIfPresent(String.self, forKey: .resourceURL)

        data = try values.decodeIfPresent(ScanItemData.self, forKey: .data)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(transactionId, forKey: .transactionId)
        try container.encodeIfPresent(httpStatus, forKey: .httpStatus)
        try container.encodeIfPresent(resultCode, forKey: .resultCode)
        try container.encodeIfPresent(resultMsg, forKey: .resultMsg)
        try container.encodeIfPresent(resourceId, forKey: .resourceId)
        try container.encodeIfPresent(resourceURL, forKey: .resourceURL)
        try container.encodeIfPresent(data, forKey: .data)
    }
}


struct ScanItemData: Codable, Equatable{
    var pageNo: Int = 0
    var elementPerPage: Int = 0
    var totalElements: Int = 0
    var totalPages: Int = 0
    var items: [ScanItem]?
    
    init(items: [ScanItem]?){
        self.items = items
    }
    
    enum CodingKeys: String, CodingKey{
        case pageNo
        case elementPerPage
        case totalElements
        case totalPages
        case items = "elementList"
    }
    
    init(from decoder:Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pageNo = try values.decodeIfPresent(Int.self, forKey: .pageNo) ?? 0
        elementPerPage = try values.decodeIfPresent(Int.self, forKey: .elementPerPage) ?? 0
        totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages) ?? 0
        items = try values.decode([ScanItem].self, forKey: .items)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(pageNo, forKey: .pageNo)
        try container.encodeIfPresent(elementPerPage, forKey: .elementPerPage)
        try container.encodeIfPresent(totalPages, forKey: .totalPages)
        try container.encodeIfPresent(totalElements, forKey: .totalElements)
        try container.encodeIfPresent(items, forKey: .items)
    }
}
