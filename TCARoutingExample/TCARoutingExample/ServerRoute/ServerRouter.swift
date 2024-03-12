import Foundation
import URLRouting
import Tagged

public enum AccessTokenTag {}
public typealias AccessToken = Tagged<AccessTokenTag, UUID>


public struct ServerRouter: ParserPrinter{
    let date: () -> Date
    let decoder: JSONDecoder
    let encoder: JSONEncoder

    public init(date: @escaping () -> Date, decoder: JSONDecoder, encoder: JSONEncoder) {
        self.date = date
        self.decoder = decoder
        self.encoder = encoder
    }
    
    public var body: some Router<ServerRoute>{
        OneOf {
            Route(.case(ServerRoute.api)){
                Parse(.memberwise(ServerRoute.Api.init(token:route:))){
                    Headers {
                      Field("Authorization") { Parse(.string)}
                    }
                    self.apiRouter
                        .baseRequestData( .init(headers: ["Content-Type" : ["application/json"]]))
                }
            }
            
            Route(.case(ServerRoute.authenticate)){
                Method.post
                Path{
                    "accounts"
                }
                Body(.json(ServerRoute.AuthenticateRequest.self, decoder: self.decoder, encoder: self.encoder))
                    .baseRequestData(.init(headers: ["Content-Type": ["application/json"]]))
            }
            
        }
        .eraseToAnyParserPrinter()
    }
    
    @ParserBuilder<URLRequestData>
    var apiRouter: AnyParserPrinter<URLRequestData, ServerRoute.Api.Route>{
        OneOf{
            Route(.case(ServerRoute.Api.Route.history)){
                Path {
                    "scans"
                }
                Query{
                    Field("pageNo") { Digits() }
                    Field("elementPerPage") { Digits() }
                }
            }
            
            Route(.case(ServerRoute.Api.Route.historyDetail(id:))){
                Path {
                    "scans"
                }
                Query{
                    Field("id") { Digits() }
                }
            }
        }
        .eraseToAnyParserPrinter()
    }
    
    public func parse(_ input: inout URLRequestData) throws -> ServerRoute {
      try self.body.parse(&input)
    }
    
    public func print(_ output: ServerRoute, into input: inout URLRequestData) throws {
      try self.body.print(output, into: &input)
    }
}
