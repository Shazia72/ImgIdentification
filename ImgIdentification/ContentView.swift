//
//  ContentView.swift
//  ImgIdentification
//
//  Created by Shazia Idrees on 2026-06-12.
//

import SwiftUI
import PhotosUI
import AVFoundation
import AVFAudio

struct ContentView: View {
	@State private var selectedImage: UIImage?
	@State private var imageData: Data?
	@State private var keyword = ""
	@State private var language = ""
	@State private var result = ""
	@State private var isLoading = false
	@State private var showPicker = false

	let aiService = AzureAIService()
	private let synthesizer = AVSpeechSynthesizer()
	
	var body: some View {
		VStack(spacing: 20) {
			
			if let selectedImage {
				Image(uiImage: selectedImage)
					.resizable()
					.scaledToFit()
					.frame(height: 250)
			}
			
			Button {
				showPicker = true
			} label: {
				Image(systemName: "arrow.up.doc.fill")
				.font(.system(size: 16))
				.foregroundColor(.white)
				.padding()
				.background(Color.gray)
				.clipShape(Circle())
				.shadow(radius: 4)
			}
			
			TextField("Enter keyword", text: $keyword)
				.textFieldStyle(.roundedBorder)
			
			
			Picker("Language", selection: $language) {
				Text("Hindi").tag("Hindi")
				Text("Arabic").tag("Arabic")
				Text("English").tag("English")
				Text("Chinese").tag("Chinese")
			}
			.pickerStyle(.segmented)
			
			Button("Analyze Image") {
				print("hello test 2")
				result = ""
				Task { await analyze() }
			}
			.buttonStyle(.borderedProminent)
			.tint(.gray)
			
			if isLoading {
				ProgressView("Analyzing…")
			}
			
			ScrollView {
				VStack(alignment: .leading, spacing: 8){
					Text(result)
						.padding()
						.font(.subheadline)
						.frame(maxWidth: .infinity, alignment: .leading)
				
				  // we can adjust height
			
				if !result.isEmpty{
					Button {
						speak(result)
					} label: {
						Image(systemName: "speaker.wave.2.fill")
							.font(.system(size: 18))
							.foregroundColor(.gray)
						
					}
					.padding(.top,4)
				}
			}
				.padding(.horizontal)
		}
		.frame(maxHeight: 250)

			Spacer()
		}
		.padding()
		.photosPicker(isPresented: $showPicker, selection: Binding(
			get: { nil },
			set: { newItem in
				Task {
					if let data = try? await newItem?.loadTransferable(type: Data.self) {
						self.imageData = data
						self.selectedImage = UIImage(data: data)
					}
				}
			}
		))
	}

	func analyze() async {
		guard let imageData else { return }
		isLoading = true

		do {
			let response = try await aiService.analyzeImage(
				imageData: imageData,
				keyword: keyword,
				language: language
			)
			result = response
			speak(response)
		} catch {
			result = "Error: \(error.localizedDescription)"
		}

		isLoading = false
	}

	func speak(_ text: String) {
		if synthesizer.isSpeaking {
					synthesizer.stopSpeaking(at: .immediate)
				}
		let utterance = AVSpeechUtterance(string: text)
		
		utterance.voice = AVSpeechSynthesisVoice(language:
		language == "Arabic" ? "ar-SA" :
		language == "Hindi" ? "hi-IN" :
		language == "Chinese" ? "zh-CN" :
		language == "English" ? "en-US" :
						"No code found"
		)
		print(language)
		
		utterance.rate = 0.4   // slower, clearer
		
		synthesizer.speak(utterance)
	}
}
