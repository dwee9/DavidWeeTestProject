//
//  SearchImageViewModel.swift
//  DavidWeeCodeChallenge
//
//  Created by David Wee on 3/1/24.
//

import Foundation
import Combine
import UIKit

final class SearchImageViewModel: ObservableObject {

    private let network: Network
    private var cancellables = Set<AnyCancellable>()

    @Published private(set) var itemColumns: [[SearchImage]] = []
    @Published var searchString: String = ""
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var numberOfColumns: Int = 3
    @Published private(set) var errorMessage: String?

    /// If there are any items to show
    var hasItems: Bool {
        !itemColumns.flatMap { $0 }.isEmpty
    }

    init(network: Network = DefaultNetwork()) {
        self.network = network
        setupSubscribers()
    }

    /// Searches for images based on the tags
    /// - Parameter tags: The Tags to search for
    func searchForImages(tags: String) {
        isLoading = true
        network.request(endpoint: ImageEndpoint.search(tag: tags), type: SearchImagesResponse.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.processItems(response.items)
                }
            case .failure(let error):
                itemColumns = []
                errorMessage = error.displayError
                isLoading = false
            }
        }
    }
}

// MARK: Private
private extension SearchImageViewModel {

    func processItems(_ items: [SearchImage]) {
        var columnHeights: [CGFloat] = Array(repeating: .zero, count: numberOfColumns)
        var newColumns: [[SearchImage]] = Array(repeating: [], count: numberOfColumns)

        // Adds the items to the columns based on which column has the smallest height
        for item in items {
            let col = columnHeights.enumerated().min { $0.element < $1.element }.map { $0.offset } ?? 0
            let height = item.getHeight(from: (UIScreen.main.bounds.size.width / CGFloat(numberOfColumns)))
            newColumns[col].append(item)
            columnHeights[col] += height
        }
        self.itemColumns = newColumns
        if items.isEmpty {
            errorMessage = Strings.Search.noItems(searchString)
        }
        isLoading = false
    }
    
    func setupSubscribers() {
        self.$searchString
            .debounce(for: 0.25, scheduler: RunLoop.main)
            .sink { [weak self] str in
                guard let self else { return }
                errorMessage = nil
                guard !str.isEmpty else {
                    self.itemColumns = []
                    return
                }
                self.searchForImages(tags: str)
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification).map { _ in
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                return 5
            case .portraitUpsideDown:
                return self.numberOfColumns
            default:
                return 3
            }
        }
        .removeDuplicates()
        .sink { [weak self] count in
            guard let self else { return }
            self.numberOfColumns = count
            self.processItems(self.itemColumns.flatMap { $0 })
        }
        .store(in: &cancellables)
    }
}
