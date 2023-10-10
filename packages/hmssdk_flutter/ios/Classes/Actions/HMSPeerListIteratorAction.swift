//
//  HMSPeerListIteratorAction.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 04/10/23.
//

import Foundation
import HMSSDK

class HMSPeerListIteratorAction {

    /**
     * [peerListIterators] stores the iterators with unique id's.
     * This is used whenever we call [peerListIteratorHasNext], or [peerListIteratorNext]
     * we fetch the respective peerListIterator based on the uid passed from flutter channel
     * and execute the method based on it.
     */
    private static var peerListIterators = [String: HMSPeerListIterator]()

    static func peerListIteratorAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        switch call.method {

            case "get_peer_list_iterator":
                getPeerListIterator(call, result, hmsSDK)

            case "peer_list_iterator_has_next":
                peerListIteratorHasNext(call, result)

            case "peer_list_iterator_next":
                peerListIteratorNext(call, result)

            default:
                result(FlutterMethodNotImplemented)
        }
    }

    /**
     * This method returns the peer list iterator based on the parameter we pass from flutter channel
     */
    private static func getPeerListIterator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {

        let arguments = call.arguments as? [AnyHashable: Any]

        guard let uid = arguments?["uid"] as? String
        else {
            HMSErrorLogger.returnHMSException(#function, "uid is null", "NULL Error", result)
            return
        }

        var peerListIteratorOptions: HMSPeerListIteratorOptions?

        let peerListOptionsMap = arguments?["peer_list_iterator_options"] as? [String: Any]

        guard let limit = peerListOptionsMap?["limit"] as? Int
        else {
            HMSErrorLogger.returnHMSException(#function, "limit parameter is null while peerListIteratorOptions is non-null", "NULL Error", result)
            return
        }

        peerListIteratorOptions = HMSPeerListIteratorOptions(filterByRoleName: arguments?["by_role_name"] as? String, filterByPeerIds: arguments?["by_peer_ids"] as? [String], limit: limit)

        var peerListIterator: HMSPeerListIterator?

        if peerListIteratorOptions != nil {
            peerListIterator = hmsSDK?.getPeerListIterator(options: peerListIteratorOptions!)
        } else {
            peerListIterator = hmsSDK?.getPeerListIterator()
        }

        if peerListIterator != nil {

            /**
             * We store the iterator in [peerListIterators] map for later operations with key as [id] which unique
             * id for the iterator
             */
            peerListIterators[uid] = peerListIterator

            result(HMSResultExtension.toDictionary(true, HMSPeerListIteratorExtension.toDictionary(peerListIterator!, uid)))
        } else {
            HMSErrorLogger.returnHMSException(#function, "peerListIterator is null", "NULL Error", result)
            return
        }

    }

    /**
     * Method to check whether iterator has next set of peers or not
     */
    private static func peerListIteratorHasNext(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

        let arguments = call.arguments as? [AnyHashable: Any]

        guard let uid = arguments?["uid"] as? String
        else {
            HMSErrorLogger.returnHMSException(#function, "uid is null", "NULL Error", result)
            return
        }

        /**
         * Here we find the iterator with [uid] passed from flutter channel
         * Since we need to perform the operation on that specific iterator
         */
        guard let peerListIterator = peerListIterators[uid]
        else {
            HMSErrorLogger.returnHMSException(#function, "No peerListIterator with given uid found", "NULL Error", result)
            return
        }

        result(HMSResultExtension.toDictionary(true, peerListIterator.hasNext))

    }

    /**
     * Method to get a list of next set of peers in iterator, the number of peers returned is equal to
     * the limit.
     */
    private static func peerListIteratorNext(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

        let arguments = call.arguments as? [AnyHashable: Any]

        guard let uid = arguments?["uid"] as? String
        else {
            HMSErrorLogger.returnHMSException(#function, "uid is null", "NULL Error", result)
            return
        }

        /**
         * Here we find the iterator with [uid] passed from flutter channel
         * Since we need to perform the operation on that specific iterator
         */
        guard let peerListIterator = peerListIterators[uid]
        else {
            HMSErrorLogger.returnHMSException(#function, "No peerListIterator with given uid found", "NULL Error", result)
            return
        }

        peerListIterator.next(completion: { peers, error in
            if let error = error {
                result(HMSResultExtension.toDictionary(false, HMSErrorExtension.toDictionary(error)))
            } else {
                var data = [String: Any]()
                var peersList = [Any]()

                peers?.forEach {
                    peersList.append(HMSPeerExtension.toDictionary($0))
                }

                data["peers"] = peersList
                data["total_count"] = peerListIterator.totalCount

                result(HMSResultExtension.toDictionary(true, data))
            }

        })

    }

    /**
     * This method clears the iterator map on leave, end Room or onRemovedFromRoom method calls
     */
    static func clearIteratorMap() {
        peerListIterators.removeAll()
    }

}
