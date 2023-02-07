package live.hms.hmssdk_flutter

import android.util.Log

class HMSErrorLogger {

    companion object{

        fun logError(methodName:String,error:String,errorType:String){
            Log.e("FL_HMSSDK Error","$errorType: { method -> $methodName, error -> $error }")
        }

        //Function to log if parameter passed to methods are null
        fun returnError(errorMessage:String):Unit?{
            Log.e("FL_HMSSDK Args Error",errorMessage)
            return null
        }

    }
}