//
//  AISplashView.swift
//  ImgIdentification
//
//  Created by Shazia Idrees on 2026-06-16.
//

import SwiftUI

struct AISplashView: View {
	@State private var glow = false
	@State private var fadeIn = false

	var body: some View {
		ZStack {
			// Futuristic AI gradient
			LinearGradient(
				colors: [
					Color.black,
					Color.blue.opacity(0.4),
					Color.purple.opacity(0.5)
				],
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
			.ignoresSafeArea()

			VStack(spacing: 30) {

				ZStack {
					// Outer pulsing ring
					Circle()
						.stroke(Color.blue.opacity(0.4), lineWidth: 4)
						.frame(width: 220, height: 220)
						.scaleEffect(glow ? 1.15 : 0.9)
						.blur(radius: 6)
						.animation(.easeInOut(duration: 1.8).repeatForever(), value: glow)

					// Middle ring
					Circle()
						.stroke(Color.purple.opacity(0.5), lineWidth: 3)
						.frame(width: 160, height: 160)
						.scaleEffect(glow ? 1.05 : 0.95)
						.animation(.easeInOut(duration: 1.6).repeatForever(), value: glow)

					// AI Core Glow
					Circle()
						.fill(
							RadialGradient(
								colors: [Color.white, Color.blue.opacity(0.2)],
								center: .center,
								startRadius: 5,
								endRadius: 120
							)
						)
						.frame(width: 120, height: 120)
						.shadow(color: .blue.opacity(0.7), radius: 25)
				}

				// App Title
				Text("AI Vision Tutor")
					.font(.system(size: 38, weight: .semibold))
					.foregroundColor(.white)
					.opacity(fadeIn ? 1 : 0)
					.animation(.easeIn(duration: 1.0), value: fadeIn)

				Text("Powered by Azure OpenAI")
					.font(.title2)
					.foregroundColor(.gray.opacity(0.8))
					.opacity(fadeIn ? 1 : 0)
				
				Text("Developed by Shazia Idrees...")
					.font(.subheadline)
					.foregroundColor(.blue.opacity(0.8))
					.opacity(fadeIn ? 1 : 0)
			}
		}
		.onAppear {
			glow = true
			fadeIn = true
		}
	}
}
