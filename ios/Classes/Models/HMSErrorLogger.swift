//
//  HMSErrorLogger.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 14/04/23.
//

import Foundation

class HMSErrorLogger {

    private static let TAG = "FL_HMSSDK Error"
    
    /**
     * This method is used to log error without returning from the function
     * If you need to send the exception and error to flutter channel
     * then consider using [returnHMSException] method
     */
    static func logError(_ methodName: String, _ error: String, _ errorType: String) {
        print("\(TAG) \(errorType): { method -> \(methodName), error -> \(error) }")
    }

    /**
     * This method is used to log of arguments passed from flutter channel is null
     * This does not stop the function execution. Function still executes normally
     */
    static func returnArgumentsError(errorMessage: String) {
        print("FL_HMSSDK Args Error \(errorMessage)")
    }
    
    /**
     * This method is used to fire [HMSException] from native to flutter, here we
     * log the exception and then send the result to flutter with [success] as [false] and [data]
     * as [HMSErrorException] map
     */
    static func returnHMSException(_ methodName: String, _ error: String, _ errorType: String,_ result: @escaping FlutterResult){
        print("\(TAG) \(errorType): { method -> \(methodName), error -> \(error) }")
        result(HMSResultExtension.toDictionary(false,HMSErrorExtension.getError(error)))
    }
    
}
