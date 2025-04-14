//
//  QuestionResponse.swift
//  Journal App
//
//  Created by Aleyna Warner on 2024-10-17.
//

import Foundation

// Enum for question type, conforming to Codable for JSON serialization
enum QuestionType: String, Codable {
    case statement
    case text
    case yesNo
    case option
    case slider
    case imageOptions
    case timeSelect
    case multiQ
    case multiText
    case conditionalText
    case endLoop
}

// Struct to represent a question and its response, conforming to Codable
struct QuestionResponse: Codable {
    let question: String
    let type: QuestionType
    let answer: String
    let slider: Double?
    let imageIndex: Int?       // New property for image options
    let timeSelect: Date?
    
    enum CodingKeys: String, CodingKey {
        case question
        case answer
        case type
        case slider
        case imageIndex
        case timeSelect
    }
}
