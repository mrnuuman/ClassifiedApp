//
//  ListingAPI.swift
//  ClassifiedApp
//
//  Created by Muhammad Nouman on 30/08/2024.
//

import Foundation
import Combine


open class ListingAPI {
    
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func getList(apiResponseQueue: DispatchQueue = ClassifiedAPIAPI.apiResponseQueue) -> AnyPublisher<[ListingMdl], Error> {
        return Future<[ListingMdl], Error>.init { promisse in
            getListWithRequestBuilder().execute(apiResponseQueue) {  result -> Void in
                switch result {
                case let .success(response):
                    promisse(.success(response.body!.results))
                case let .failure(error):
                    promisse(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    open class func getListWithRequestBuilder() -> RequestBuilder<ListingsResponse> {
        let path = ".us-east-1.amazonaws.com/default/dynamodb-writer"
        let URLString = ClassifiedAPIAPI.basePath + path
        let url = URLComponents(string: URLString)
        let requestBuilder: RequestBuilder<ListingsResponse>.Type = ClassifiedAPIAPI.requestBuilderFactory.getBuilder()
        let parameters: [String:Any]? = nil
        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
}
