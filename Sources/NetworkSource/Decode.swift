// swiftlint:disable:this file_name
//
//  Decode.swift
//  BuoyLocal
//
//  Created by Tom Clark on 2019-10-06.
//

import Foundation
import Combine

var dateDecoder: DateFormatter = { () -> DateFormatter in
  let dateFormatter = DateFormatter()
  dateFormatter.locale = Locale(identifier: "en_US_POSIX")
  dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

  return dateFormatter
}()

func decode<T: Decodable>(_ data: Data, response: URLResponse) -> AnyPublisher<T, ClassifiedError> {
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .formatted(dateDecoder)
  return Just(data)
    .decode(type: T.self, decoder: decoder)
    .mapError { error in
      .parsing(description: error.localizedDescription)
    }
    .eraseToAnyPublisher()
}

struct ApiErrors: Decodable {
  let errors: [ApiStatusError]
}

struct ApiMessageError: Decodable {
  let error: String
}

struct ApiMessageError2: Decodable {
  let message: String
}

struct ApiMessageError3: Decodable {
  let text: String
}

struct ApiStatusError: Decodable, Identifiable {
  var id: String {
    title
  }

  let status: String
  let title: String
  let code: String

  enum CodingKeys: String, CodingKey {
    case status
    case title
    case code
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    if let intCode = try? container.decode(Int.self, forKey: .code) {
      self.code = "\(intCode)"
    } else {
      self.code = try container.decode(String.self, forKey: .code)
    }

    if let intStatus = try? container.decode(Int.self, forKey: .status) {
      self.status = "\(intStatus)"
    } else {
      self.status = try container.decode(String.self, forKey: .status)
    }

    self.title = try container.decode(String.self, forKey: .title)
  }

  init(status: String, title: String, code: String) {
    self.status = status
    self.title = title
    self.code = code
  }
}

func decodeErrorsWithStatus(_ status: Int, Data data: Data) -> ApiErrors? {
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .iso8601

  if let error = try? decoder.decode(ApiMessageError.self, from: data) {
    return ApiErrors(errors: [ApiStatusError(status: "", title: error.error, code: "")])
  }

  if let error = try? decoder.decode(ApiMessageError2.self, from: data) {
    return ApiErrors(errors: [ApiStatusError(status: "", title: error.message, code: "")])
  }
    
  if let error = try? decoder.decode([ApiMessageError3].self, from: data) {
    return ApiErrors(errors: [ApiStatusError(status: "", title: error.first?.text ?? "", code: "")])
  }

  if let errors = try? decoder.decode([ApiStatusError].self, from: data) {
    return ApiErrors(errors: errors)
  }

  if let errors = try? decoder.decode(ApiErrors.self, from: data) {
    return errors
  }

  let statusError = ApiStatusError(status: "\(status)", title: String(data: data, encoding: .utf8) ?? "", code: "")
  return ApiErrors(errors: [statusError])
}
