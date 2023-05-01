//
//  HMSSessionStoreKeyChangeListener.swift
//  hmssdk_flutter
//
//  Created by Yogesh Singh on 26/04/23.
//

import Foundation

class HMSSessionStoreKeyChangeListener: NSObject {

    let uid: String

    let observer: NSObjectProtocol

    init(_ uid: String, _ observer: NSObjectProtocol) {
        self.uid = uid
        self.observer = observer
    }
}
