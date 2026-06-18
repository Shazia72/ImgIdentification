//
//  ImgIdentificationApp.swift
//  ImgIdentification
//
//  Created by Shazia Idrees on 2026-06-12.
//

import SwiftUI

@main
struct ImgIdentificationApp: App {
	@State private var showSplash = true
	
    var body: some Scene {
        WindowGroup {
			ZStack {
				ContentView()
					.opacity(showSplash ? 0 : 1)

				if showSplash {
					AISplashView()
						.transition(.opacity)
				}
			}
			.onAppear {
				DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
					withAnimation(.easeOut(duration: 0.5)) {
						showSplash = false
					}
				}
			}
        }
    }
}
