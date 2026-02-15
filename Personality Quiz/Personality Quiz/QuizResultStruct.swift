//
//  QuizHistoryRecordStruct.swift
//  Personality Quiz
//
//  Created by JAGamer on 2/8/26.
//
import Foundation

struct QuizResult: Codable {
    let quizType: String
    let result: String
    let date: Date
}
