package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.HMSMessage
import live.hms.video.sdk.models.HMSPeer

class HMSMessageExtension {
    companion object{
        fun toDictionary(message:HMSMessage?):HashMap<String,Any>?{
            val args=HashMap<String,Any>()
            if(message==null)return null
            args.put("message",message.message)
            args.put("time",message.serverReceiveTime.toLocaleString())
            args.put("type",message.type)
            args.put("sender",HMSPeerExtension.toDictionary(message.sender)!!)
            args.put("hms_message_recipient",HMSMessageRecipientExtension.toDictionary(message.recipient)!!)
            val messageArgs=HashMap<String,Any>()
            messageArgs.put("message",args)
            return messageArgs
        }
    }
}