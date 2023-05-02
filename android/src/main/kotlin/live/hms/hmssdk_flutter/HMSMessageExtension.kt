package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.HMSMessage
import java.text.SimpleDateFormat

class HMSMessageExtension {
    companion object{
        fun toDictionary(message:HMSMessage?):HashMap<String,Any>?{
            val args=HashMap<String,Any>()
            if(message==null)return null
            args["message"] = message.message
            args["time"] =
                SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(message.serverReceiveTime).toString()
            args["type"] = message.type
            if(message.sender != null)
                args["sender"] = HMSPeerExtension.toDictionary(message.sender)!!
            args["hms_message_recipient"] = HMSMessageRecipientExtension.toDictionary(message.recipient)!!
            val messageArgs=HashMap<String,Any>()
            messageArgs["message"] = args
            return messageArgs
        }
    }    
}