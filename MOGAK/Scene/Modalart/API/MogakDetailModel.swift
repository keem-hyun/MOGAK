//
//  MogakDetailModel.swift
//  MOGAK
//
//  Created by 김라영 on 2023/12/22.
//

import Foundation

struct JogakDetailResponse: Codable {
    let time, status, code, message: String?
    let result: [JogakDetail]?
}

// MARK: - Result
struct JogakDetail: Codable {
    let jogakID: Int
    let mogakTitle, category, title: String
    let isRoutine: Bool
    let days: [String]?
    let startDate, endDate: String?

    enum CodingKeys: String, CodingKey {
        case jogakID = "jogakId"
        case mogakTitle, category, title, isRoutine, startDate, endDate, days
    }
}

struct MogakDeleteResponse: Codable {
    let time, status, code, message: String?
    let result: String?
}
