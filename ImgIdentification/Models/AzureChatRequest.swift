//
//  AzureChatRequest.swift
//  ImgIdentification
//
//  Created by Shazia Idrees on 2026-06-12.
//

import Foundation

struct AzureChatRequest: Codable {
	let messages: [Message]
	let max_tokens: Int
}

struct Message: Codable {
	let role: String
	let content: [Content]
}

struct Content: Codable {
	let type: String
	let text: String?
	let image_url: ImageURL?
}

struct ImageURL: Codable {
	let url: String
}

