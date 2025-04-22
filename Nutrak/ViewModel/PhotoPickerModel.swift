//
//  PhotoPickerModel.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 27/03/25.
//

import SwiftUI
import PhotosUI

class PhotoPickerModel: ObservableObject {
    enum PhotoPickerState: Equatable {
        case idle
        case loading
        case success(UIImage)
        case failure(Error)
        
        static func == (lhs: PhotoPickerState, rhs: PhotoPickerState) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle):
                return true
            case (.loading, .loading):
                return true
            case (.success(let lhsImage), .success(let rhsImage)):
                return lhsImage.size == rhsImage.size
            case (.failure, .failure):
                return true
            default:
                return false
            }
        }
    }
    
    @Published var state: PhotoPickerState = .idle
    
    @MainActor func loadTransferable(from imageSelection: PhotosPickerItem) async {
        self.state = .loading
        
        do {
            // Load the image data
            if let data = try await imageSelection.loadTransferable(type: Data.self) {
                if let image = UIImage(data: data) {
                    self.state = .success(image)
                    return
                }
            }
            
            self.state = .failure(NSError(domain: "PhotoPickerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not load image"]))
        } catch {
            self.state = .failure(error)
        }
    }
}
