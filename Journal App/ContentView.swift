//
//  ContentView.swift
//  Journal App
//
//  Created by Aleyna Warner on 2024-10-01.
//

import SwiftUI
import SwiftData
import Foundation
import AppAuth


struct ContentView: View {

    @Environment(\.scenePhase) private var scenePhase
    
    @EnvironmentObject var authManager: AuthManager

    @State private var questions: [Question] = ContentView.initialQuestions()
    @State private var infoMessages: [String] = ContentView.initialInfoMessages()
    
    static func initialQuestions() -> [Question] {
        return [
            Question(text: "Hi there! Let's take a moment and explore what is happening for you right now.", type: .statement),
            Question(text: "Please tell us about your current situation.", type: .multiText, subQuestions: ["Where are you?", "What are you doing?", "Are you alone or with others?"]), // Please tell us about your current situation, where are you, are you alone?
            Question(text: "Are you physically hungry?", type: .yesNo, yesNextIndex: 3, noNextIndex: 3),
            Question(text: "When was the last time you ate (approximately)?", type: .option, options: ["Less than an hour ago", "1-3 hours ago", "More than 3 hours ago"]),
            Question(text: "Are you craving food right now?", type: .yesNo, yesNextIndex: 5, noNextIndex: 17),
            // if yes //
            Question(text: "How do you know that you are craving?", type: .text),
            Question(text: "Are you craving any specific foods?", type: .conditionalText, followUpTextPrompt: "What food(s) are you craving?"),
            Question(text: "How intense is your craving?", type: .slider, sliderRange: 0.0...10.0, sliderStep: 1.0, intenseNextIndex: 8, mildNextIndex: 9),
            Question(text: "What makes your craving feel intense?", type: .text),
            Question(text: "What makes your craving feel mild?", type:.text),
            Question(text: "Does it feel like things are happening for you with a greater speed? Or does it feel like things are slowing down and the moment never passes? Or do you not notice any change at all?", type: .option, options: ["Speeding up", "Slowing down", "No change"]),//time
            Question(text: "Which image below best represents your attentional state?", type: .imageOptions, images: ["Busy Mind", "Calm mind", "Tunnel Vision"]), //attention
            Question(text: "Please describe any emotions that are standing out to you.", type: .text), //emotion
            Question(text: "Are you trying to control the craving?", type: .conditionalText, followUpTextPrompt: "What are you doing to control it?"),
            Question(text: "Do you remember what elicited the craving?", type: .yesNo, yesNextIndex: 15, noNextIndex: 29),//do you remember what elicited the craving (in binge)
            Question(text: "What elicited the craving? (select all that apply, and describe further in text)", type: .multiQ, options: ["Mood", "Hunger", "Social Context", "Other",]),
            Question(text: "Did you... (select all that apply)", type: .multiQ, options: ["See the food", "Smell the food", "Think about the food"]),
            
            //if no//
            Question(text: "Did you have a craving experience recently?", type: .yesNo, yesNextIndex: 18, noNextIndex: 29),
                //if yes//
            Question(text: "How did you know that you were craving?", type: .text),
            Question(text: "Were you craving any specific foods?", type: .text),
            Question(text: "How intense was your craving?", type: .slider, sliderRange: 0.0...10.0, sliderStep: 1.0, intenseNextIndex: 21, mildNextIndex: 22),
            Question(text: "What made your craving feel intense?", type: .text),
            Question(text: "What made your craving feel mild?", type:.text),
            Question(text: "Did it feel like things were happening for you with a greater speed? Or did it feel like things were slowing down and the moment never passed? Or did you not notice any change at all?", type: .option, options: ["Speeding up", "Slowing down", "No change"]),//time
            Question(text: "What was your attention like while you were craving? Choose the image that best represents it.", type: .imageOptions, images: ["Busy Mind", "Calm mind", "Tunnel Vision"]),
            Question(text: "Please describe any emotions that you were experiencing while craving", type: .text),
            Question(text: "Were you trying to control the craving?", type: .conditionalText, followUpTextPrompt: "How did you control the craving?"),
            Question(text: "What elicited the craving? (select all that apply, and describe further in text)", type: .multiQ, options: ["Mood", "Hunger", "Social Context", "Other",]),
            Question(text: "Did you... (select all that apply)", type: .multiQ, options: ["See the food", "Smell the food", "Think about the food"]),
            Question(text: "Thank you for your time! We will check in later.", type: .endLoop, endLoop: true)
            
        ]
    }
    
    static func initialInfoMessages() -> [String] {
        return [
            "", //statement ind0
            "", //current situation ind1
            "", //hungry ind2
            "", //ate ind3
            "", //craving food rn ind4
            // if yes //
            "Please describe how you notice that you are craving", //how do you know ind5
            "", //specific food ind6
            "Please rate the intensity of your craving from Mild to Very Strong", //slider ind7
            "", //more intense ind8
            "", //more mild ind9
            "Sometimes the flow of time may feel accelerated or slowed down without an obvious explanation. Do you notice any change in your experience of time, or does it feel like nothing has changed at all?", //time perception ind10
            "", //attentional state ind11
            "", //emotions that stand out ind12
            "", //trying to control the craving ind13
            "", //remember what elicited the craving ind14
            "", //what elicited the craving ind15
            "", //did you... see, smell, think ind16
            //GO TO END LOOP//
            
            // if no //
            "", //craving experience recently ind17
                 // if yes //
            "Please describe how you noticed that you were craving", //how did you know ind18
            "", //specific foods ind19
            "Please rate the intensity of your craving from Mild to Very Strong", //slider ind20
            "", //more intense ind21
            "", //more mild ind22
            "“Sometimes the flow of time may feel accelerated or slowed without an obvious explanation. Did you notice a change in your experience of time, or did it feel like nothing has changed at all?”", //time perception ind25
            "", //attentional state ind23
            "", //emotional state ind24
            "", //control craving ind26
            "", //what elicited craving ind27
            "", //did you... see, smell, think ind28
            
            // if no //
            "", //thank you for your time ind29
        ]
    }

    
    @State private var firstQuestionAnsweredTime: Date? = nil
    @State private var currentQuestionIndex = 0
    @State private var userInput = ""
    @State private var optionChosen: String? = nil
    @State private var otherText: String = "" // Tracks custom text for "Other"
    @State private var yesNoAnswer: Bool? = nil
    @State private var sliderValue = 10.0
    @State private var showingInfoAlert = false
    @State private var selectedImageIndex: Int? = nil
    @State private var selectedTime = Date() // Track selected time
    @State private var selectedOptions: Set<String> = []
    @State private var nextQuestionSelectedOptions: Set<String> = []
    @State private var currentQuestionTextInput: String = ""
    @State private var followUpTriggered = false //tracks if folllow-up questions should be shown
    @State private var multiTextResponses: [String] = []
    @State private var conditionalTextResponse: String = ""
    @State private var conditionalYesNoAnswer: Bool? = nil


    
    // State to store user responses
    @State private var responses: [QuestionResponse] = []
    
    var body: some View {
        VStack(spacing: 20) {
            // Display the current question
            
            if questions[currentQuestionIndex].type != .endLoop {
                HStack {
                    Text(questions[currentQuestionIndex].text)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.leading)
                        .foregroundColor(ColorPalette.color5)
                    
                    let indicesWithInfoButton: Set<Int> = [7,10,18,20,25]
                    
//                    if followUpTriggered == true {
//                        let indiciesWithInfoButton: Set<Int> = [2,7]
//                    }
                    
                    // Info Button
                    if questions[currentQuestionIndex].type != .statement && indicesWithInfoButton.contains(currentQuestionIndex) {
                        Button(action: {
                            showingInfoAlert = true // Show the info alert when tapped
                        }) {
                            Image(systemName: "info.circle") // Use SF Symbols for the info icon
                                .font(.headline)
                                .foregroundColor(ColorPalette.color4)
                        }
                    }
                    
                }
                .alert(isPresented: $showingInfoAlert) {
                    Alert(title: Text("Info"), message: Text(infoMessages[currentQuestionIndex]), dismissButton: .default(Text("OK")))
                }
            }
            
            
            
            // Switch between text or yes/no answer types
            switch questions[currentQuestionIndex].type {
            case .statement:
                VStack {
                    Text("We invite you to approach your experience with curiosity and without any pressure or judgement. To do this, we will guide you through some questions. There is no right or wrong way to answer.")
                        .font(.subheadline)
                        .italic()
                        .multilineTextAlignment(.center)
                        .foregroundColor(ColorPalette.color3)
                        .padding(.top, 16)
                }
            case .text:
                VStack{
                    // TextField for text input
                    TextField("Type your answer here...", text: $userInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    // Italicized text
                    Text("Please describe your experience without any judgment.")
                        .font(.subheadline)
                        .italic()
                        .multilineTextAlignment(.center)
                        .foregroundColor(ColorPalette.color3)
                        .padding(.top, 16)
                }
                
            case .yesNo:
                // Yes/No buttons
                HStack {
                    Button(action: {
                        yesNoAnswer = true
                    }) {
                        Text("Yes")
                            .padding()
                            .background(yesNoAnswer == true ? ColorPalette.color3 : ColorPalette.color2)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        yesNoAnswer = false
                    }) {
                        Text("No")
                            .padding()
                            .background(yesNoAnswer == false ? ColorPalette.color3 : ColorPalette.color2)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                //todo -- add text to MOOD and SOCIAL CONTEXT and multiple selection w text below "Select all that apply"
                // have separate question section for see food, smell food, think food, or other on same page (can select multiple)
            case .option:
                // Display options as selectable buttons
                VStack {
                    ForEach(questions[currentQuestionIndex].options ?? [], id: \.self) { option in
                        Button(action: {
                            optionChosen = option
                        }) {
                            Text(option)
                                .padding()
                                .background(optionChosen == option ? ColorPalette.color3 : ColorPalette.color2)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    
                    // Show TextField when "Other" is selected
                    if optionChosen == "Other" {
                        TextField("Please specify...", text: $otherText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                    
                }
                
            case .slider:
                if let range = questions[currentQuestionIndex].sliderRange, let step = questions[currentQuestionIndex].sliderStep {
                    VStack {
                        // Slider Label
                        Text("Intensity")
                            .font(.headline)
                            .foregroundColor(ColorPalette.color4)
                        
                        // Slider Configuration
                        Slider(value: $sliderValue,
                               in: Double(range.lowerBound)...Double(range.upperBound),
                               step: Double(step))
                        .accentColor(ColorPalette.color4) // Change the color of the slider itself
                        
                        // Minimum and Maximum Value Labels
                        HStack {
                            Text("Mild")
                                .foregroundColor(ColorPalette.color4)
                            Spacer() // Pushes the labels to the ends of the HStack
                            Text("Very Strong")
                                .foregroundColor(ColorPalette.color4)
                        }
                        .padding(.horizontal) // Add padding to the HStack
                        
                        // Display Current Slider Value
                        let sliderValueInt = Int(sliderValue) // Convert to Int for display
                        Text("Value: \(sliderValueInt)")
                            .foregroundColor(ColorPalette.color4)
                    }
                    .padding() // Padding for the entire VStack
                }
                
            case .imageOptions:
                if let images = questions[currentQuestionIndex].images {
                    VStack {
                        // Combined question text and info button
                        
                        // Display images as selectable buttons
                        HStack {
                            ForEach(images.indices, id: \.self) { index in
                                Button(action: {
                                    optionChosen = images[index] // Set the selected option based on the image
                                    selectedImageIndex = index     // store the index of the selected image
                                }) {
                                    Image(images[index])
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100) // Adjust size as needed
                                        .border(optionChosen == images[index] ? ColorPalette.color4 : Color.clear, width: 2) // Highlight selected image
                                        .padding()
                                }
                            }
                        }
                    }
                }
            case .timeSelect:
                VStack(spacing: 20){
                    DatePicker("Please enter a time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .padding()
                }
            case .multiQ:
                VStack {
                    
                    // Multi-select options for the current question
                    ForEach(questions[currentQuestionIndex].options ?? [], id: \.self) { option in
                        Button(action: {
                            if selectedOptions.contains(option) {
                                selectedOptions.remove(option) // Deselect if already selected
                            } else {
                                selectedOptions.insert(option) // Add to selected options
                            }
                        }) {
                            HStack {
                                Text(option)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                if selectedOptions.contains(option) {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .padding()
                            .background(selectedOptions.contains(option) ? ColorPalette.color3 : ColorPalette.color2)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    
                    // Always show the "Please describe further" TextField for the current question
                    TextField("Please describe further...", text: $currentQuestionTextInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Divider for separation
                    Divider().padding(.vertical)
                    
                    // Next Question
                    Text(questions[currentQuestionIndex + 1].text)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(ColorPalette.color5)
                    
                    // Multi-select options for the next question
                    ForEach(questions[currentQuestionIndex + 1].options ?? [], id: \.self) { option in
                        Button(action: {
                            if nextQuestionSelectedOptions.contains(option) {
                                nextQuestionSelectedOptions.remove(option) // Deselect if already selected
                            } else {
                                nextQuestionSelectedOptions.insert(option) // Add to selected options
                            }
                        }) {
                            HStack {
                                Text(option)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                if nextQuestionSelectedOptions.contains(option) {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .padding()
                            .background(nextQuestionSelectedOptions.contains(option) ? ColorPalette.color3 : ColorPalette.color2)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                
            case .multiText:
                if let subQuestions = questions[currentQuestionIndex].subQuestions {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(subQuestions.indices, id: \.self) { index in
                            VStack(alignment: .leading) {
                                Text(subQuestions[index])
                                    .font(.headline)
                                    .foregroundColor(ColorPalette.color5)
                                
                                TextField("Type your response here...", text: Binding(
                                    get: { multiTextResponses.indices.contains(index) ? multiTextResponses[index] : "" },
                                    set: { newValue in
                                        if multiTextResponses.indices.contains(index) {
                                            multiTextResponses[index] = newValue
                                        } else {
                                            multiTextResponses.append(newValue)
                                        }
                                    }
                                ))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 10)
                            }
                        }
                    }
                    .padding()
                }
            
            case .conditionalText:
                VStack(spacing: 10) {
    
                    HStack {
                        Button(action: {
                            conditionalYesNoAnswer = true
                        }) {
                            Text("Yes")
                                .padding()
                                .background(conditionalYesNoAnswer == true ? ColorPalette.color3 : ColorPalette.color2)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        Button(action: {
                            conditionalYesNoAnswer = false
                            conditionalTextResponse = "" // Clear text input if "No" is selected
                        }) {
                            Text("No")
                                .padding()
                                .background(conditionalYesNoAnswer == false ? ColorPalette.color3 : ColorPalette.color2)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }

                    // Show TextField only if "Yes" is selected
                    if conditionalYesNoAnswer == true, let followUpPrompt = questions[currentQuestionIndex].followUpTextPrompt {
                        Text(followUpPrompt)
                            .font(.subheadline)
                            .foregroundColor(ColorPalette.color4)

                        TextField("Type your response here...", text: $conditionalTextResponse)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                }


                
            case .endLoop: // Ensure you have a case for your end loop question
                Text(questions[currentQuestionIndex].text)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                    .onAppear {
                        saveResponsesToFileAndUpload(authManager: authManager, baseURL: "https://g-4e0411.88cee.8443.data.globus.org")
                    }
                // No additional inputs or buttons here
                
                
                
            }
            
            if questions[currentQuestionIndex].type != .endLoop {
                // "Next" button
                Button(action: {
                    if currentQuestionIndex == 0 && firstQuestionAnsweredTime == nil {
                        firstQuestionAnsweredTime = Date() // Capture current time
                    }
                    saveResponse()
                    nextQuestion()
                }) {
                    Text("Next")
                        .padding()
                        .background(isAnswerValid() ? ColorPalette.color3 : ColorPalette.color2) // Use color3 if valid, else color2
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                // Disable button if answer is not valid
                .disabled(!isAnswerValid())
            }
        }
        .onAppear {
                NotificationCenter.default.addObserver(forName: Notification.Name("TriggerFollowUpQuestions"), object: nil, queue: .main) { _ in
                    loadFollowUpQuestions()
                }
            }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: Notification.Name("TriggerFollowUpQuestions"), object: nil)
            //saveResponsesToFileAndUpload(authManager: authManager, baseURL: "https://g-4e0411.88cee.8443.data.globus.org")
        }
        
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background {
                //saveResponsesToFileAndUpload(authManager: authManager, baseURL: "https://g-4e0411.88cee.8443.data.globus.org")
                resetAppState() // Reset the app state when the app is minimized
            }
        }
        
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorPalette.color1.ignoresSafeArea())
        .onDisappear {
            //saveResponsesToFileAndUpload(authManager: authManager, baseURL: "https://g-4e0411.88cee.8443.data.globus.org") // Save to JSON when the view disappears (or when session ends)
        }
    }
    
    func resetAppState() {
            questions = ContentView.initialQuestions()
            currentQuestionIndex = 0
            userInput = ""
            yesNoAnswer = nil
            optionChosen = nil
            sliderValue = 10.0
            selectedOptions.removeAll()
            nextQuestionSelectedOptions.removeAll()
            responses.removeAll()
        }
    
    // Navigate to the next question based on the answer
    func nextQuestion() {
        let currentQuestion = questions[currentQuestionIndex]
        
        if (currentQuestion.text == "Are you craving food right now?" || currentQuestion.text == "Are you still craving?") && yesNoAnswer == true {
                // Schedule the follow-up notification
                NotificationManager.shared.scheduleFollowUpNotification(after: 20 * 60) 
            }
        
        if currentQuestion.type == .yesNo {
            if let yesNextIndex = currentQuestion.yesNextIndex, yesNoAnswer == true {
                currentQuestionIndex = yesNextIndex
            } else if let noNextIndex = currentQuestion.noNextIndex, yesNoAnswer == false {
                currentQuestionIndex = noNextIndex
            }
        }
        
        else if currentQuestion.type == .slider {
            if let intenseNextIndex = currentQuestion.intenseNextIndex, sliderValue >= 5 {
                currentQuestionIndex = intenseNextIndex
                print("Next index = ")
                print(intenseNextIndex)
            } else if let mildNextIndex = currentQuestion.mildNextIndex, sliderValue < 5 {
                currentQuestionIndex = mildNextIndex
            }
        }
        
        else if currentQuestion.type == .text && (currentQuestionIndex == 8 || currentQuestionIndex == 21) && followUpTriggered == false {
            currentQuestionIndex += 2
        }
        
        else if currentQuestion.type == .multiQ {
            currentQuestionIndex = 29
        }
        
        else if currentQuestion.type == .text && currentQuestionIndex == 3 && followUpTriggered == true {
            currentQuestionIndex += 2
        }
        
        else if followUpTriggered == true && currentQuestionIndex == 8 {
            currentQuestionIndex += 2
        }
        
        else if questions[currentQuestionIndex].type == .endLoop && followUpTriggered == true {
            // Reset to initial questions after follow-up
            questions = ContentView.initialQuestions() // Restore initial question set
            infoMessages = ContentView.initialInfoMessages() // Restore initial info messages
            currentQuestionIndex = 0
            followUpTriggered = false
        }
        
        else {
            currentQuestionIndex += 1 // Move to the next question for text-based ones
        }
        
        // Reset input for the next question
        userInput = ""
        yesNoAnswer = nil
        optionChosen = nil
        sliderValue = 10.0
        selectedOptions.removeAll()
        nextQuestionSelectedOptions.removeAll()
        multiTextResponses.removeAll() // Clear multi-text responses
    }

    
    func loadFollowUpQuestions() {
        questions = [
            Question(text: "“Hi again! Let's take a moment and explore what is happening for you right now.", type: .statement),
            Question(text: "Are you still craving?", type: .yesNo, yesNextIndex: 2, noNextIndex: 10),
            Question(text: "How intense is your craving?", type: .slider, sliderRange: 0.0...10.0, sliderStep: 1.0, intenseNextIndex: 3, mildNextIndex: 4),
            Question(text: "What makes your craving feel intense?", type: .text),
            Question(text: "What makes your craving feel mild?", type:.text),
            Question(text: "Does it feel like things are happening for you with a greater speed? Or does it feel like things are slowing down and the moment never passes? Or do you not notice any change at all?", type: .option, options: ["Speeding up", "Slowing down", "No change"]),//time
            Question(text: "Which image below best represents your attentional state?", type: .imageOptions, images: ["Busy Mind", "Calm mind", "Tunnel Vision"]), //attention
            Question(text: "Please describe any emotions that are standing out to you.", type: .text), //emotion
            Question(text: "Are you trying to control the craving?", type: .conditionalText, followUpTextPrompt: "What are you doing to control it?"),
            Question(text: "How did the craving stop? How did you know it was over?", type: .text),
            Question(text: "Thank you for completing the follow-up. See you next time!", type: .endLoop, endLoop: true)
        ]
        currentQuestionIndex = 0 // Start from the first follow-up question
        loadFollowUpInfo()
        followUpTriggered = true
    }
    
    func loadFollowUpInfo() {
        infoMessages = [
            "", //statement ind0
            "", //are you still ind1
            // if yes//
            "Please rate the intensity of your craving from Mild to Very Strong", //slider ind2
            "", //more intense ind3
            "", //more mild ind4
            "Sometimes the flow of time may feel accelerated or slowed down without an obvious explanation. Do you notice any change in your experience of time, or does it feel like nothing has changed at all?", //time perception ind7
            "", //attentional state ind5
            "", //emotions that stand out ind6
            "", //trying to control ind8
            "", //completing followup ind 9
    ]
            }

    
    // Save the response for the current question
    func saveResponse() {
        let currentQuestion = questions[currentQuestionIndex]
        let answer: String
        var sliderAnswer: Double? = nil  // Optional storage for slider value
        var imageIndex: Int? = nil        // Optional storage for image index
        

        switch currentQuestion.type {
        case .yesNo:
            answer = yesNoAnswer == true ? "Yes" : "No"
        case .option:
            answer = optionChosen ?? ""
        case .slider:
            answer = "\(sliderValue)"
            sliderAnswer = sliderValue
        case .multiText:
            answer = multiTextResponses.joined(separator: " | ")
        case .conditionalText:
            if let selectedYes = conditionalYesNoAnswer {
                answer = selectedYes ? "Yes: \(conditionalTextResponse)" : "No"
            } else {
                answer = "No Response"
            }
            conditionalYesNoAnswer = nil
            conditionalTextResponse = ""
        case .imageOptions:
            // Save the index as the answer (if available)
            if let index = selectedImageIndex {
                answer = "\(index)"
            } else {
                answer = ""
            }
        default:
            answer = userInput
        }
        
        // Create a response object including the image index if needed.
        let response = QuestionResponse(question: currentQuestion.text, type: currentQuestion.type, answer: answer, slider: sliderAnswer, imageIndex: imageIndex, timeSelect: Date())
        responses.append(response)
        
        // Reset multiTextResponses and selectedImageIndex after saving
        multiTextResponses.removeAll()
        selectedImageIndex = nil
    }

    
    // Check if the answer is valid depending on the question type
    func isAnswerValid() -> Bool {
        let questionType = questions[currentQuestionIndex].type
        switch questionType {
        case .statement:
            return true
        case .text:
            return !userInput.isEmpty // Text answer must not be empty
        case .yesNo:
            return yesNoAnswer != nil // Yes/No question must be answered
        case .option:
            return optionChosen != nil // option must be chosen
        case .slider:
            return true
        case .imageOptions:
            return optionChosen != nil // Image option must be chosen
        case .timeSelect:
            return true
        case .multiQ:
            return !currentQuestionTextInput.isEmpty
            && !selectedOptions.isEmpty
            && !nextQuestionSelectedOptions.isEmpty
        case .multiText:
            if let subQuestions = questions[currentQuestionIndex].subQuestions {
                return multiTextResponses.count == subQuestions.count
                    && !multiTextResponses.contains(where: { $0.isEmpty }) // Ensure all fields are filled
            }
            return false // Fail-safe if subQuestions is nil
        case .conditionalText:
            if let selectedYes = conditionalYesNoAnswer {
                if selectedYes {
                    return !conditionalTextResponse.isEmpty // Require input if "Yes"
                } else {
                    return true // "No" is a valid answer without text
                }
            }
            return false // Prevents proceeding if neither Yes nor No is selected
        case .endLoop:
            return true
        }
        
    }
    
    
//    func saveResponsesToFileAndUpload(baseURL: String) {
//        do {
//            let jsonData = try JSONEncoder().encode(responses)
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
//            let dateString = dateFormatter.string(from: Date())
//            let fileName = "responses_\(dateString).json"
//
//            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//                let fileURL = documentDirectory.appendingPathComponent(fileName)
//                try jsonData.write(to: fileURL)
//                print("Saved responses to file: \(fileURL)")
//
//                // Upload anonymously — no token required
//                GlobusUploader.upload(fileURL: fileURL, baseURL: baseURL)
//            }
//        } catch {
//            print("Error saving or uploading responses: \(error)")
//        }
//    }

    func saveResponsesToFileAndUpload(authManager: AuthManager, baseURL: String) {
        do {
            let jsonData = try JSONEncoder().encode(responses)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
            let dateString = dateFormatter.string(from: Date())
            let fileName = "responses_\(dateString).json"

            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent(fileName)
                try jsonData.write(to: fileURL)
                print("Saved responses to file: \(fileURL)")

                // Get access token from AppAuth state
                print("Getting access token")
                authManager.getAccessToken { token in
                    if let token = token {
                        GlobusUploader.upload(fileURL: fileURL, accessToken: token, baseURL: baseURL)
                    }
                }
            }
        } catch {
            print("Error saving or uploading responses: \(error)")
        }
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
