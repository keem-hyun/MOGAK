//
//  JogakModel.swift
//  MOGAK
//
//  Created by 안세훈 on 1/20/24.
//

import Foundation

//MARK: - 조각 일일 조회
struct JogakDailyCheck: Codable {
    let time, status, code, message: String
    let result: result
}
struct result: Codable {
    let size: Int
    let dailyJogaks: [DailyJogak]
}
struct DailyJogak: Codable {
    let dailyJogakID: Int
    let mogakTitle, category, title: String
    let isRoutine, isAchievement: Bool

    enum CodingKeys: String, CodingKey {
        case dailyJogakID = "dailyJogakId"
        case mogakTitle, category, title, isRoutine, isAchievement
    }
}

//MARK: - 조각 조회

struct ScheduleJogakDetailResponse: Codable {
    let time, status, code, message: String?
    let result: [ScheduleJogakDetail]?
}

struct ScheduleJogakDetail: Codable {
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
//MARK: - 일일 조각 시작
struct JogakAddRoutine: Codable {
    let time, status, code, message: String
    let result: [JogakRoutineStart]?
}

struct JogakRoutineStart: Codable {
    let jogakID, dailyJogakID: Int
    let title, mogakTitle, category: String
    let isRoutine: Bool
    let days: [String]?
    let isAchievement: Bool
    let achievements: Int

    enum CodingKeys: String, CodingKey {
        case jogakID = "jogakId"
        case dailyJogakID = "dailyJogakId"
        case title, mogakTitle, category, isRoutine, days, isAchievement, achievements
    }
}
//MARK: - 조각 실패
struct JogakFail: Codable {
    let time: String
    let status: Int
    let code, message: String
}

//MARK: - 조각 성공
struct JogakSuccess: Codable {
    let time: String
    let status: Int
    let code, message: String
}

