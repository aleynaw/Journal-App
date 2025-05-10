//
//  ParticipantIDView.swift
//  Journal App
//
//  Created by Aleyna Warner on 2025-04-20.
//


import SwiftUI

/// A simple view that prompts the user to enter a Participant ID, stores it via @AppStorage,
/// and prevents re-entry on subsequent launches.
struct ParticipantIDView: View {
    @AppStorage("participantID") private var participantID: String = ""
    @State private var inputID: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter your Participant ID")
                .font(.title2)
                .bold()

            TextField("Participant ID", text: $inputID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: saveID) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isValidID ? Color.accentColor : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!isValidID)
        }
        .padding()
    }

    private var isValidID: Bool {
        !inputID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func saveID() {
        participantID = inputID.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
