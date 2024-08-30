//
//  BuoyError.swift
//  BuoyLocal
//
//  Created by Tom Clark on 2019-10-06.
//

import Foundation
import Combine

enum ClassifiedError: Error {
  case parsing(description: String)
  case network(description: String)
  case apiError(error: ApiErrors)

  // For Fake API
  case missingFakeFile(description: String)
  case somethingWentWrong(description: String)

  var apiError: ApiErrors? {
    switch self {
    case .apiError(let error):
      return error
    default:
      return nil
    }
  }
}

extension Publisher {
  
  func mapClassError() -> AnyPublisher<Output, ClassifiedError> {
    self.mapError { error -> ClassifiedError in
      if let errorResponse = error as? ErrorResponse {
        switch errorResponse {
        case .error(let status, let data, let error):
          guard let data = data, let decodedError = decodeErrorsWithStatus(status, Data: data) else {
            return ClassifiedError.network(description: error.localizedDescription)
          }
          return ClassifiedError.apiError(error: decodedError)
        }
      }
      return ClassifiedError.network(description: error.localizedDescription)
    }
    .eraseToAnyPublisher()
  }
}
