//
//  CameraView.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 26/03/25.
//

import AVFoundation
import Combine
import PhotosUI
import SwiftUI

struct CameraView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = CameraViewModel()
    @State private var showingPermissionAlert = false
    @State private var isScanning = false
    @State private var scanProgress: Double = 0
    @State private var timerCancellable: AnyCancellable?
    
    @State private var imageSelection: PhotosPickerItem?
    @StateObject private var photoPickerModel = PhotoPickerModel()
    
    var onImageCaptured: (UIImage) -> Void
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            if viewModel.showCameraContent {
                CameraPreviewView(session: viewModel.session)
                    .edgesIgnoringSafeArea(.all)
                
                RoundedRectangleOverlay()
                
                GeometryReader { geometry in
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "viewfinder")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                            
                            Text("Scan Your Food")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        
                        Text("Ensure your food is well-lit and in focus for the most accurate scan.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(Color.black.opacity(0.2))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .position(x: geometry.size.width / 2, y: 128)
                    
                    VStack {
                        HStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.toggleFlash()
                            }) {
                                Image(systemName: viewModel.isFlashOn ? "bolt" : "bolt.slash")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        Spacer()
                        
                        HStack(spacing: 30) {
                            PhotosPicker(
                                selection: $imageSelection,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                Image(systemName: "photo.on.rectangle")
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                hapticFeedback()
                                viewModel.capturePhoto()
                                print("Photo captured button pressed")
                            }) {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 70, height: 70)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 3)
                                            .frame(width: 80, height: 80)
                                    )
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.toggleZoom()
                            }) {
                                Text("\(viewModel.currentZoomFactor, specifier: "%1.0f")x")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.bottom, 30)
                        .padding([.leading, .trailing], 20)
                    }
                }
            }
        }
        .onAppear {
            viewModel.checkCameraPermissions()
            viewModel.onPhotoCaptured = { [self] image in
                self.startScanningProcess(with: image)
            }
        }
        .onChange(of: viewModel.cameraPermissionDenied, initial: false) { _, denied in
            showingPermissionAlert = denied
        }
        .onChange(of: imageSelection, initial: false) { _, newValue in
            if let newValue {
                Task {
                    await photoPickerModel.loadTransferable(from: newValue)
                }
            }
        }
        .onChange(of: photoPickerModel.state) { newState in
            if case .success(let image) = newState {
                startScanningProcess(with: image)
                photoPickerModel.state = .idle
                imageSelection = nil
            }
        }
        .alert(isPresented: $showingPermissionAlert) {
            Alert(
                title: Text("Camera Permission Required"),
                message: Text("Please allow camera access in your device settings to use the scanning feature."),
                primaryButton: .default(Text("Settings"), action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }),
                secondaryButton: .cancel(Text("Cancel"), action: {
                    presentationMode.wrappedValue.dismiss()
                })
            )
        }
    }
    
    private func startScanningProcess(with image: UIImage) {
        self.onImageCaptured(image)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

