//
//  CommonLoginManage.swift
//  MOGAK
//
//  Created by 김라영 on 2023/12/11.
//

import Foundation
import Alamofire

class CommonLoginManage: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print(#fileID, #function, #line, "- adapt함수")
        var urlRequest = urlRequest
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
        print(#fileID, #function, #line, "- adapt accessToken: \(accessToken)")
        urlRequest.headers.add(.authorization(bearerToken: accessToken))
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let requestToken = UserDefaults.standard.string(forKey: "refreshToken") else { return }
        print(#fileID, #function, #line, "- refreshToken check: \(requestToken)")
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        AF.request(LoginRouter.getNewAccessToken(refreshToken: requestToken))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Tokens.self) { (response: DataResponse<Tokens, AFError> ) in
                switch response.result {
                case .failure(let error):
                    print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
                    completion(.doNotRetry)
                case .success(let data):
                    UserDefaults.standard.set(data.accessToken, forKey: "accessToken")
                    UserDefaults.standard.set(data.refreshToken, forKey: "refreshToken")
                    completion(.retry)
                }
                
            }
            
    }
}
