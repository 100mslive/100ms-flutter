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
                if let roomEndReason = model.roomEndedString {
                    Text(roomEndReason)
                }
                else if let track = model.track {
                    GeometryReader { geo in
                        HMSSampleBufferSwiftUIView(track: track, contentMode: .scaleAspectFit, preferredSize: geo.size, model: model)
                            .frame(width: geo.size.width, height: geo.size.height)
                    }
                }
//                else if let track = model.track {
//                    HMSSampleBufferSwiftUIView(track: track, contentMode: .scaleAspectFit, model: model)
//                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
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
    @Published var name: String?
    @Published var screenTrack: HMSVideoTrack?
    @Published var isVideoActive = false
    
    @Published var pipViewEnabled = false
    @Published var roomEndedString: String?
}
