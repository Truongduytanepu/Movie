//
//  APIError.swift
//  Moffy
//
//  Created by Trương Duy Tân on 27/02/2024.
//

import Foundation

enum APIError: Error {
  case invalidRequest
  case invalidResponse
  case jsonEncodingError
  case jsonDecodingError
  case notInternet
}
