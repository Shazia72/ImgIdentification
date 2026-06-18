//
//  AzureAIService.swift
//  ImgIdentification
//
//  Created by Shazia Idrees on 2026-06-12.
//

import Foundation

class AzureAIService {
	private let endpoint = "Your-EndPoint"
	private let apiKey = "Your-Key"
	private let deployment = "gpt-4.1-mini"

	func analyzeImage(imageData: Data, keyword: String, language: String) async throws -> String {
		let base64Image = imageData.base64EncodedString()

		let prompt = """
		You are an inteligent assistant. The user provides an image and a keyword.
		1. Identify the object in the image.
		2. Use the keyword to generate a meaningful sentence.
		3. You must output ONLY one final sentence in the selected language.
		4. Do not include English explanation, headings, or multiple lines.
		5. Output the final sentence in \(language).
		"""

		let request = AzureChatRequest(
			messages: [
				Message(
					role: "user",
					content: [
						Content(type: "text", text: prompt, image_url: nil),
						Content(type: "text", text: "Keyword: \(keyword)", image_url: nil),
						Content(type: "image_url", text: nil, image_url: ImageURL(url: "data:image/jpeg;base64,\(base64Image)"))
					]
				)
			],
			max_tokens: 200
		)

		let url = URL(string: "\(endpoint)/openai/deployments/\(deployment)/chat/completions?api-version=2024-02-01")!

		var requestObj = URLRequest(url: url)
		requestObj.httpMethod = "POST"
		requestObj.addValue("application/json", forHTTPHeaderField: "Content-Type")
		requestObj.addValue(apiKey, forHTTPHeaderField: "api-key")
		requestObj.httpBody = try JSONEncoder().encode(request)

		let (data, _) = try await URLSession.shared.data(for: requestObj)
		
		print(String(data: data, encoding: .utf8) ?? "NO DATA")


		// FIXED PARSER
		if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
		   let choices = json["choices"] as? [[String: Any]],
		   let message = choices.first?["message"] as? [String: Any]{
			
			// CASE 1: content is a STRING (your model!)
		   if let text = message["content"] as? String {
			   return text
		   }

		   // CASE 2: content is an ARRAY (other Azure models)
		   if let contentArray = message["content"] as? [[String: Any]] {
			   for item in contentArray {
				   if let text = item["text"] as? String {
					   return text
				   }
			   }
		   }
		}

		throw NSError(domain: "AzureAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
	}

}
