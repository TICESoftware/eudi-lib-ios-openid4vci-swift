/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation
import XCTest

@testable import OpenID4VCI

class NetworkingMock: Networking {
  
  let path: String
  let `extension`: String
  
  init(
    path: String,
    `extension`: String
  ) {
    self.path = path
    self.extension = `extension`
  }
  
  func data(
    from url: URL
  ) async throws -> (Data, URLResponse) {
    let path = Bundle.module.path(forResource: self.path, ofType: self.extension)
    let url = URL(fileURLWithPath: path!)
    let data = try! Data(contentsOf: url)
    let result = Result<Data, Error>.success(data)
    let response = HTTPURLResponse(url: .stub(), statusCode: 200, httpVersion: nil, headerFields: [:])
    return try (result.get(), response!)
  }
}