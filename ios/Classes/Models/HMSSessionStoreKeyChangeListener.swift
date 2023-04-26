//
//  HMSSessionStoreKeyChangeListener.swift
//  hmssdk_flutter
//
//  Created by Yogesh Singh on 26/04/23.
//

import Foundation

class HMSSessionStoreKeyChangeListener: NSObject {

    let identifier: String

    let observer: NSObjectProtocol

    init(_ identifier: String, _ observer: NSObjectProtocol) {
        self.identifier = identifier
        self.observer = observer
    }
}
