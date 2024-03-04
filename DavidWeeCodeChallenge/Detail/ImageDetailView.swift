//
//  ImageDetailView.swift
//  DavidWeeCodeChallenge
//
//  Created by David Wee on 3/3/24.
//

import SwiftUI
import SDWebImageSwiftUI
import WebKit

struct ImageDetailView: View {

    let animation: Namespace.ID
    let selectedImage: SearchImage
    @State var descriptionString: String = ""
    @Binding var isPresented: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {

                header

                HStack {
                    Spacer()
                    WebImage(url: selectedImage.media.url)
                        .resizable()
                        .frame(maxWidth: selectedImage.width, maxHeight: selectedImage.height)
                        .clipShape(RoundedRectangle(cornerRadius: 12.0, style: .continuous))
                        .matchedGeometryEffect(id: selectedImage.hashValue, in: animation)
                        .scaledToFit()
                    Spacer()
                }
                imageDetails
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .background {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
        }
        .task {
            DispatchQueue.main.async {
                self.resignFirstResponder()
                descriptionString = selectedImage.description.convertFromHTML.capitalized
            }
        }
    }

    // MARK: - Header
    @ViewBuilder
    private var header: some View {
        ZStack(alignment: .top) {
            HStack {
                Button(action: {
                    withAnimation {
                        isPresented = false
                    }
                }, label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20.0))
                })
                Spacer()
            }
            .padding(.top, 5.0)

            Text(selectedImage.title)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30.0)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Details
    @ViewBuilder
    private var imageDetails: some View {
        Text("**Size:** \(Int(selectedImage.width)) x \(Int(selectedImage.height))")
            .padding(.bottom, 10.0)

        VStack(alignment: .leading, spacing: 10.0) {
            Text("**Author:** \(selectedImage.author)")
            Text("**Taken:** \(selectedImage.dateTaken)")
            Text("**Published:** \(selectedImage.publishedDate)")
            Text("**Description:** \(descriptionString)")
        }

        Spacer()
    }

}
