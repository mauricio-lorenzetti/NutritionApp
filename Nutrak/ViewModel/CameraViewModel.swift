//
//  CameraViewModel.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 26/03/25.
//


import SwiftUI
import AVFoundation
import Combine

class CameraViewModel: ObservableObject {
    @Published var session = AVCaptureSession()
    @Published var cameraPermissionGranted = false
    @Published var cameraPermissionDenied = false
    @Published var showCameraContent = false
    @Published var isFlashOn = false
    @Published var currentZoomFactor: CGFloat = 1.0
    
    var onPhotoCaptured: ((UIImage) -> Void)?
    
    private var cancellables = Set<AnyCancellable>()
    private let zoomFactors: [CGFloat] = [1.0, 2.0, 3.0]
    private var currentZoomIndex = 0
    private var device: AVCaptureDevice?
    private var output = AVCapturePhotoOutput()
    
    private var photoCaptureDelegate: PhotoCaptureDelegate?
    
    init() {
        setupBindings()
    }
    
    func setupBindings() {
        $cameraPermissionGranted
            .dropFirst()
            .sink { [weak self] granted in
                if granted {
                    self?.setupCamera()
                }
            }
            .store(in: &cancellables)
    }
    
    func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            cameraPermissionGranted = true
        case .notDetermined:
            requestCameraPermission()
        case .denied, .restricted:
            cameraPermissionDenied = true
        @unknown default:
            break
        }
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    self?.cameraPermissionGranted = true
                } else {
                    self?.cameraPermissionDenied = true
                }
            }
        }
    }
    
    func setupCamera() {
        do {
            self.session.beginConfiguration()
            
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                print("No back camera available")
                return
            }
            
            self.device = device
            let input = try AVCaptureDeviceInput(device: device)
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.session.startRunning()
                DispatchQueue.main.async {
                    self?.showCameraContent = true
                }
            }
        } catch {
            print("Error setting up camera: \(error.localizedDescription)")
        }
    }
    
    func toggleFlash() {
        guard let device = self.device else { return }
        
        do {
            try device.lockForConfiguration()
            
            if device.hasTorch {
                isFlashOn.toggle()
                device.torchMode = isFlashOn ? .on : .off
            }
            
            device.unlockForConfiguration()
        } catch {
            print("Error toggling flash: \(error.localizedDescription)")
        }
    }
    
    func toggleZoom() {
        currentZoomIndex = (currentZoomIndex + 1) % zoomFactors.count
        setZoomFactor(zoomFactors[currentZoomIndex])
    }
    
    private func setZoomFactor(_ factor: CGFloat) {
        guard let device = self.device else { return }
        
        do {
            try device.lockForConfiguration()
            
            let maxZoom = device.activeFormat.videoMaxZoomFactor
            let normalizedZoom = min(factor, maxZoom)
            device.videoZoomFactor = normalizedZoom
            currentZoomFactor = factor
            
            device.unlockForConfiguration()
        } catch {
            print("Error setting zoom: \(error.localizedDescription)")
        }
    }
    
    func capturePhoto() {
        print("CapturePhoto method called")
        let settings = AVCapturePhotoSettings()
        
        if let device = self.device, device.hasTorch {
            settings.flashMode = isFlashOn ? .on : .off
        }
        
        self.photoCaptureDelegate = PhotoCaptureDelegate()
        self.photoCaptureDelegate?.onImageCaptured = { [weak self] image in
            print("Delegate received image")
            DispatchQueue.main.async {
                print("Calling onPhotoCaptured callback with image")
                self?.onPhotoCaptured?(image)
            }
        }
        
        self.output.capturePhoto(with: settings, delegate: self.photoCaptureDelegate!)
    }
}

class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    var onImageCaptured: ((UIImage) -> Void)?
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("Delegate received photo")
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            print("Unable to get image data")
            return
        }
        
        if let image = UIImage(data: imageData) {
            print("onImageCaptured callback triggered with image")
            onImageCaptured?(image)
        }
        
        print("Photo captured successfully. Size: \(imageData.count) bytes")
    }
}
