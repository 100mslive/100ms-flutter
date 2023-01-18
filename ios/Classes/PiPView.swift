//
//  PiPView.swift
//  HMSSDK
//
//  Copyright © 2022 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK

@available(iOS 15.0, *)
struct PiPView: View {
    
    @ObservedObject var model: PiPModel
    
    var body: some View {
        if model.pipViewEnabled {
            VStack {
                if let track = model.track {
                    GeometryReader { geo in
                        if let contentMode = model.scaleType {
                            HMSSampleBufferSwiftUIView(track: track, contentMode: contentMode, preferredSize: geo.size, model: model)
                                .frame(width: geo.size.width, height: geo.size.height)
                        } else {
                            HMSSampleBufferSwiftUIView(track: track, contentMode: .scaleAspectFill, preferredSize: geo.size, model: model)
                                .frame(width: geo.size.width, height: geo.size.height)
                        }
                    }
                } else if let text = model.text {
                    Text(text)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(model.color)
        }
    }
}

@available(iOS 15.0, *)
public struct HMSSampleBufferSwiftUIView: UIViewRepresentable {
    weak var track: HMSVideoTrack?
    var contentMode: UIView.ContentMode
    var preferredSize: CGSize?
    
    @ObservedObject var model: PiPModel
    
    public func makeUIView(context: UIViewRepresentableContext<HMSSampleBufferSwiftUIView>) -> HMSSampleBufferDisplayView {
        
        let sampleBufferView = HMSSampleBufferDisplayView(frame: .zero)
        sampleBufferView.track = track
        
        if let preferredSize = preferredSize {
            sampleBufferView.preferredSize = preferredSize
        }
        sampleBufferView.contentMode = contentMode
        sampleBufferView.isEnabled = true
        
        return sampleBufferView
    }
    
    public func updateUIView(_ sampleBufferView: HMSSampleBufferDisplayView, context: UIViewRepresentableContext<HMSSampleBufferSwiftUIView>) {
        
        if track != sampleBufferView.track {
            sampleBufferView.track = track
        }
        sampleBufferView.isEnabled = model.pipViewEnabled
    }
    
    public static func dismantleUIView(_ uiView: HMSSampleBufferDisplayView, coordinator: ()) {
        uiView.isEnabled = false
        uiView.track = nil
    }
}

@available(iOS 15.0, *)
class PiPModel: ObservableObject {
    @Published var track: HMSVideoTrack?
    @Published var pipViewEnabled = false
    @Published var scaleType: UIView.ContentMode?
    @Published var text: String?
    @Published var color: Color = Color.black
}
