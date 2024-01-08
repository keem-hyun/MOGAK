//
//  UserNetwork.swift
//  MOGAK
//
//  Created by 김라영 on 2023/12/20.
//

import Foundation
import Alamofire
import SwiftyJSON
import Kingfisher
import UIKit

class UserNetwork {
    static let shared = UserNetwork()
    //MARK: - 닉네임 검증
    func nicknameVerify(_ nickname: String, completionHandler: @escaping(Result<String, Error>) -> Void) {
        let nicknameRequest = NicknameChangeRequest(nickname: nickname)
        AF.request(UserRouter.nicknameVerify(nickname: nicknameRequest))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: NicknameVerify.self) { (response: DataResponse<NicknameVerify, AFError>) in
                switch response.result {
                case .success(let nicknameVerify):
                    if nicknameVerify.code == "success" {
                        return completionHandler(.success(""))
                    } else {
                        return completionHandler(.success(nicknameVerify.message))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
    }
    
    //MARK: - 유저 계정 생성
    func userJoin(_ userData: UserInfoData, _ profileImg: UIImage?, completionHandler: @escaping(Result<Bool, Error>) -> Void) {
        let url = "https://mogak.shop:8080/api/users/join"
        let userId = UserDefaults.standard.integer(forKey: "userId")
        let header: HTTPHeaders = [
                    "Accept" : "application/json",
                    "Content-Type" : "multipart/form-data"
                ]

        let parameterArr: [String : Any] = ["nickname" : userData.nickname,
                                          "job" : userData.job,
                                          "address" : userData.address,
                                           "email" : "rlafkdud1228@icloud.com",
                                           "userId" : userId]
        
        AF.upload(multipartFormData: { multipartFormData in
            let jsonString = JSON(parameterArr).rawString() ?? ""
            let jsonData = jsonString.data(using: String.Encoding.utf8)!
            
            multipartFormData.append(jsonData, withName: "request", mimeType: "application/json")
            
//            for (key, value) in parameters {
//                if key == "request" {
//                    let dataAlamoDic = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) //이렇게 했더니 json으로 파싱이 잘 안됨
//                    multipartFormData.append("\(dataAlamoDic)".data(using: .utf8)!, withName: key as String, mimeType: "application/json")
//                }
//            }
            
            if let profileImg = profileImg {
                if let image = profileImg.jpegData(compressionQuality: 1) {
                    multipartFormData.append(image, withName: "multipartFile", fileName: "\(userData.nickname)_\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }
            }
            print(#fileID, #function, #line, "- multipartFormData: \(multipartFormData.contentLength)")
        }, to: url, method: .post, headers: header)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: UserInfoDataResponse.self, completionHandler:  { response in
            switch response.result{
            case .success(let data):
                print("url : \(data.result.nickname)")
                completionHandler(.success(true))
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    //MARK: - 유저 닉네임 변경
    func nicknameChange(_ nickname: String, completionHandler: @escaping((Result<Bool, Error>) -> Void)) {
        let nicknameRequest = NicknameChangeRequest(nickname: nickname)
        AF.request(UserRouter.nicknameChange(nickname: nicknameRequest))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: UserInfoChangeResponse.self) { response in
                switch response.result {
                case .success(let nicknameChange):
                    print(#fileID, #function, #line, "- nickname change: \(nicknameChange)")
                    completionHandler(.success(true))
                case .failure(let error):
                    print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
                    completionHandler(.failure(error))
                }
            }
    }
    
    //MARK: - 유저 직무 변경
    func jobChange(_ job: JobChangeRequest, completionHandler: @escaping((Result<Bool, Error>) -> Void)) {
        AF.request(UserRouter.jobChange(job: job))
            .validate(statusCode: 200..<300)
            
            .responseDecodable(of: UserInfoChangeResponse.self) { response in
                switch response.result {
                case .success(let nicknameChange):
                    print(#fileID, #function, #line, "- nickname change: \(nicknameChange)")
                    completionHandler(.success(true))
                case .failure(let error):
                    print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
                    completionHandler(.failure(error))
                }
            }
    }
    
    //MARK: - 유저 프로필사진 변경
    func userImageChange(_ profileImg: UIImage, completionHandler: @escaping((Result<Bool, Error>) -> Void)) {
        var url = "https://mogak.shop:8080/api/users/profile/image"
        
        let header: HTTPHeaders = [
                    "Accept" : "application/json, application/javascript, text/javascript, text/json",
                    "Content-Type" : "multipart/form-data"
                ]
        let userNickname = RegisterUserInfo.shared.userName
        AF.upload(multipartFormData: { MultipartFormData in
            
            if let image = profileImg.jpegData(compressionQuality: 1) {
                MultipartFormData.append(image, withName: "multipartFile", fileName: "\(String(describing: userNickname)).jpeg", mimeType: "image/jpeg")
            }
            
        }, to: url, method: .put, headers: header, interceptor: CommonLoginManage())
        .validate(statusCode: 200..<300)
        .responseDecodable(of: ChangeSuccessResponse.self, completionHandler:  { response in
            switch response.result{
            case .success(let data):
                print(#fileID, #function, #line, "- data: \(data)")
                if data.code == "success" {
                    completionHandler(.success(true))
                } else {
                    completionHandler(.success(false))
                }
            case .failure(let error):
              print(#fileID, #function, #line, "- profileImg change Error: \(error)")
            }
        })
    }
    
    func getUserData(_ completionHandler: @escaping((Result<Bool, Error>) -> Void)) {
        AF.request(UserRouter.getUserData, interceptor: CommonLoginManage())
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    if response.response?.statusCode == 200 {
                        let decodeData = try? decoder.decode(GetUserDataSuccessResponse.self, from: data)
                        print(#fileID, #function, #line, "- decodeData: \(decodeData)")
                        guard let result = decodeData?.result else { return }
                        RegisterUserInfo.shared.nickName = result.nickname
                        RegisterUserInfo.shared.userJob = result.job
                        if let thumbnailUrl = URL(string: result.imgURL ?? "") {
                            KingfisherManager.shared.retrieveImage(with: thumbnailUrl, completionHandler: { result in
                            switch(result) {
                                case .success(let imageResult):
                                RegisterUserInfo.shared.profileImage = imageResult.image
                                case .failure(let error):
                                    print(#fileID, #function, #line, "- erro: \(error)")
                                }
                            })
                        }
                        completionHandler(.success(true))
                        
                    } else {
                        let decodeData = try? decoder.decode(GetUserDataFailureResponse.self, from: data)
                        completionHandler(.success(false))
                    }
                case .failure(let error):
                    print(#fileID, #function, #line, "- error: \(error)")
                    completionHandler(.failure(error))
                }
                
            }
    }
    
    
}
