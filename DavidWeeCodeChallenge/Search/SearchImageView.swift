//
//  SearchImageView.swift
//  DavidWeeCodeChallenge
//
//  Created by David Wee on 3/1/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchImageView: View {
    @Namespace private var animation
    @ObservedObject var viewModel: SearchImageViewModel

    @State private var selectedImage: SearchImage?
    @State private var isShowingImage: Bool = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.hasItems {
                    ScrollView {
                        HStack(alignment: .top, spacing: 2.0) {
                            ForEach(viewModel.itemColumns, id: \.self) { col in
                                LazyVStack(spacing: 2.0) {
                                    ForEach(col, id: \.self) { item in
                                        if item == selectedImage, isShowingImage {
                                            Color.clear
                                        } else {
                                            WebImage(url: item.media.url)
                                                .resizable()
                                                .indicator(.activity)
                                                .matchedGeometryEffect(id: item.hashValue, in: animation)
                                                .scaledToFit()
                                                .onTapGesture {
                                                    guard selectedImage == nil else { return }
                                                    withAnimation {
                                                        selectedImage = item
                                                        isShowingImage = true
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .scrollDismissesKeyboard(.immediately)
                } else {
                    Group {
                        if viewModel.searchString.isEmpty {
                            Text(Strings.Search.searchHelp)
                        } else if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                        }
                    }
                    .multilineTextAlignment(.center)
                    .font(.callout)
                }
            }
            .loading(viewModel.isLoading)
            .navigationTitle(Strings.Search.title)
        }
        .overlay {
            if let selectedImage, isShowingImage {
                ImageDetailView(animation: self.animation, selectedImage: selectedImage, isPresented: $isShowingImage)
                    .onDisappear {
                        self.selectedImage = nil
                    }
            }
        }
        .searchable(text: $viewModel.searchString, placement: .navigationBarDrawer(displayMode: .always), prompt: Strings.Search.placeholder)
    }
}

#Preview {
    SearchImageView(viewModel: SearchImageViewModel())
}
