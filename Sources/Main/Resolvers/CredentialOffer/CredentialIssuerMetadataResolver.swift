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

public enum CredentialIssuerSource {
  case credentialIssuer(CredentialIssuerId)
}

public actor CredentialIssuerMetadataResolver: ResolverType {
  /// Resolves client metadata asynchronously.
  ///
  /// - Parameters:
  ///   - fetcher: The fetcher object responsible for fetching metadata. Default value is Fetcher<ClientMetaData>().
  ///   - source: The input source for resolving metadata.
  /// - Returns: An asynchronous result containing the resolved metadata or an error of type ResolvingError.
  public func resolve(
    fetcher: Fetcher<CredentialIssuerMetadata> = Fetcher(),
    source: CredentialIssuerSource?
  ) async -> Result<CredentialIssuerMetadata?, CredentialError> {
    switch source {
    case .credentialIssuer(let issuerId):

      let pathComponent1 = ".well-known"
      let pathComponent2 = "openid-credential-issuer"

      let url = issuerId.url.appendingPathComponent(pathComponent1).appendingPathComponent(pathComponent2)

      
      let result = await fetcher.fetch(url: url)
      let metaData = try? result.get()
      if let metaData = metaData {
        return .success(metaData)
      }
      return .failure(.genericError)
    case .none:
      return .failure(.genericError)
    }
    return .failure(.genericError)
  }
}