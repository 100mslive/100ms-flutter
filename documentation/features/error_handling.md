# Error Handling
When you make an API call to access an HMS SDK, the SDK may return error codes. ErrorCodes are returned when a problem that cannot be recovered without app intervention has occurred.

These are returned as `HMSException` in the onError callback of the `HMSUpdateListner`.

Following are the different error codes that are returned by the SDK . Before returning any error code, SDK retries the errors(whichever is possible).

| Error Code  | Cause of the error | Action to be taken     |
|-------------|--------------------|------------------------|
| 1003      | Websocket disconnected - Happens due to network issues             | Mention user to check their network connection or try again after some time.           |
| 2002   | Invalid Endpoint URL          | Check the endpoint provided while calling `join` on `HMSSDK`.               |
| 2003   | Endpoint is not reachable               | Mention user to check their network connection or try again after some time.              |
| 2004   | Token is not in proper JWT format               | The token passed while calling `join` is not in correct format. Retry getting a new token.             |
| 3001   | Cant Access Capture Device               | Ask user to check permission granted to audio/video capture devices.              |
| 3002   | Capture Device is not Available               | Ask user to check if the audio/video capture device is connected or not.              |
| 3003   | Capture device is in use by some other application               | Show notification to user mentioning that the capturing device is used by some other application currently. |
| 3008   | Browser has thrown an autoplay exception.               | Show notification to user mentioning that the browser blocked autoplay             |
| 4001   | WebRTC error               | Some webRTC error has occured. Need more logs to debug.             |
| 4002   | WebRTC error               | Some webRTC error has occured. Need more logs to debug.              |
| 4003   | WebRTC error               | 	Some webRTC error has occured. Need more logs to debug.            |
| 4004   | WebRTC error               | Some webRTC error has occured. Need more logs to debug.             |
| 4005   | ICE Connection Failed due to network issue               | Mention user to check their network connection or try again after some time.               |
| 5001   | Trying to join a room which is already joined               | Trying to join an already joined room.              |
| 6002   | webRTC Error: Error while renegotiating               | Please try again.               |
| 40101   | Token Error: Invalid Access Key               | Access Key provided in the token is wrong.         |
| 40102   | Token Error: Invalid Room Id               | RoomID provided in the token is wrong.            |
| 40103   | Token Error: Invalid Auth Id               | 	AuthID provided in the token is wrong.           |
| 40104   | Token Error: Invalid App Id               | App ID provided in the token is wrong.            |
| 40105   | Token Error: Invalid Customer Id               | Customer Id provided in the token is wrong.             |
| 40107   | Token Error: Invalid User Id               | User ID provided in the token is wrong.             |
| 40108   | Token Error: Invalid Role               | The role provided in the token is wrong.            |
| 40109   | Token Error: Bad JWT Token                 | Bad JWT Token.               |
| 40100   | 	Generic Error               | Need to debug further with logs.               |
| 40001   | Invalid Room               | Room ID provided while fetching the token is an invalid room.             |
| 40002   | Room Mismatched with Token               |Room ID provided while fetching the token does not match.               |
| 40004   | Peer already joined               | Peer who is trying to join has already joined the room.            |
| 41001   | Peer is gone               | The peer is no more present in the room.              |