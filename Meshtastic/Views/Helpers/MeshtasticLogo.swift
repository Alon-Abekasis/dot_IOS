//
//  MeshtasticLogo.swift
//  Meshtastic
//
//  Copyright(c) Garth Vander Houwen 10/6/22.
//
import SwiftUI

struct MeshtasticLogo: View {

	@Environment(\.colorScheme) var colorScheme

	var body: some View {

		#if targetEnvironment(macCatalyst)
			VStack(alignment: .leading) {
				Image("m-logo-white")
					.resizable()
					.renderingMode(.template)
					.foregroundColor(.accentColor)
					.scaledToFit()
			}
			.padding(.bottom, 5)
			.padding(.top, 5)
			.offset(x: -5.5)
			.frame(maxWidth: .infinity, alignment: .leading)
		#else
			VStack(alignment: .leading) {
				Image(colorScheme == .dark ? "m-logo-white" : "m-logo-black")
					.resizable()
					.renderingMode(.template)
					.scaledToFit()
			}
			.padding(.bottom, 5)
			.offset(x: -5.5)
			.frame(maxWidth: .infinity, alignment: .leading)
		#endif
	}
}
