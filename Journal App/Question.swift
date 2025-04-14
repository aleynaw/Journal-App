//
//  Question.swift
//  Journal App
//
//  Created by Aleyna Warner on 2024-10-17.
//

import Foundation

struct Question {
    let text: String                // The text of the question
    let type: QuestionType          // The type of the question (text or yes/no)
    let options: [String]?          // Options for multiple choice questions
    let images: [String]?
    let sliderRange: ClosedRange<Double>?
    let sliderStep: Double?
    let yesNextIndex: Int?          // Optional index for the next question if the answer is "Yes"
    let noNextIndex: Int?           // Optional index for the next question if the answer is "No"
    let intenseNextIndex: Int?
    let mildNextIndex : Int?
    let allowsMultipleSelection: Bool
    let subQuestions: [String]?
    let followUpTextPrompt: String?
    let endLoop: Bool               // Indicates if this question should end the loop

    // Initializer
    init(
        text: String,
        type: QuestionType,
        options: [String]? = nil,
        images: [String]? = nil,
        sliderRange: ClosedRange<Double>? = nil,
        sliderStep: Double? = 1.0,
        yesNextIndex: Int? = nil,
        noNextIndex: Int? = nil,
        intenseNextIndex: Int? = nil,
        mildNextIndex: Int? = nil,
        allowsMultipleSelection: Bool = false,
        subQuestions: [String]? = nil,
        followUpTextPrompt: String? = nil,
        endLoop: Bool = false) {
            
            self.text = text
            self.type = type
            self.options = options
            self.images = images
            self.sliderRange = sliderRange
            self.sliderStep = sliderStep
            self.yesNextIndex = yesNextIndex
            self.noNextIndex = noNextIndex
            self.intenseNextIndex = intenseNextIndex
            self.mildNextIndex = mildNextIndex
            self.allowsMultipleSelection = allowsMultipleSelection
            self.subQuestions = subQuestions
            self.followUpTextPrompt = followUpTextPrompt
            self.endLoop = endLoop
    }
}
