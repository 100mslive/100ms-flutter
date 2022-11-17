package live.hms.hmssdk_flutter.methods

import android.app.Activity
import android.app.PendingIntent
import android.app.PictureInPictureParams
import android.app.RemoteAction
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.drawable.Icon
import android.os.Build
import android.util.Rational
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import live.hms.hmssdk_flutter.HMSPipConfig
import live.hms.hmssdk_flutter.HMSPipConfigExtension
import live.hms.hmssdk_flutter.R
import live.hms.video.sdk.HMSSDK

class HMSPipAction {

    companion object {

        private const val PIP_ACTION_EVENT = "PIP_ACTION_EVENT"
        private const val leaveRoom = "leaveRoom"
        private const val localAudioToggle = "localAudioToggle"
        private const val localVideoToggle = "localVideoToggle"

        private var pipRemoteAction  = mutableMapOf<String, RemoteAction>()

        fun pipActions(call: MethodCall, result: MethodChannel.Result, activity : Activity,hmssdk:HMSSDK){
            when(call.method){
                "enter_pip_mode"->{
                    if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                    enterPipMode(call,result,activity,hmssdk)
                }
                "is_pip_active"->{
                    if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                    result.success(activity.isInPictureInPictureMode)
                }
                "is_pip_available"->{
                    result.success(
                        activity.packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)
                    )
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        @RequiresApi(Build.VERSION_CODES.O)
        private fun enterPipMode(call: MethodCall, result: MethodChannel.Result,activity:Activity,hmssdk : HMSSDK){
            val hmsPipConfigMap = call.argument<HashMap<String,Any>>("pip_config")
            val hmsPipConfig : HMSPipConfig = HMSPipConfigExtension.setHMSPipConfig(hmsPipConfigMap)
                ?: return;

            val localPeer = hmssdk.getLocalPeer()
            if(hmsPipConfig.addAudioMuteButton){
                pipRemoteAction[localAudioToggle] = RemoteAction(
                    Icon.createWithResource(
                        activity,
                        if(localPeer!!.audioTrack!!.isMute)
                            R.drawable.ic_mic_off_24
                        else
                            R.drawable.ic_mic_24)
                        ,
                    localAudioToggle,
                    "",
                    PendingIntent.getBroadcast(activity,344,Intent(PIP_ACTION_EVENT).putExtra( localAudioToggle,344),
                        PendingIntent.FLAG_IMMUTABLE
                    )
                )
            }

            if(hmsPipConfig.addVideoMuteButton){
                pipRemoteAction[localVideoToggle] = RemoteAction(
                    Icon.createWithResource(
                        activity,
                        if(localPeer!!.videoTrack!!.isMute)
                            R.drawable.ic_camera_toggle_off
                        else
                            R.drawable.ic_camera_toggle_on)
                    ,
                    localVideoToggle,
                    "",
                    PendingIntent.getBroadcast(activity,345,Intent(PIP_ACTION_EVENT).putExtra( localVideoToggle,345),
                        PendingIntent.FLAG_IMMUTABLE
                    )
                )
            }

            if(hmsPipConfig.addLeaveRoomButton){
                pipRemoteAction[leaveRoom] = RemoteAction(
                    Icon.createWithResource(
                        activity,
                        R.drawable.ic_call_end_24)
                    ,
                    leaveRoom,
                    "",
                    PendingIntent.getBroadcast(activity,346,Intent(PIP_ACTION_EVENT).putExtra( leaveRoom,346),
                        PendingIntent.FLAG_IMMUTABLE
                    )
                )
            }

            var params = PictureInPictureParams.Builder()
            if (pipRemoteAction.isNotEmpty()){
                params.setActions(pipRemoteAction.map { it.value }.toList())
            }
            params.setAspectRatio(Rational(hmsPipConfig.aspectRatio[0],hmsPipConfig.aspectRatio[1]))
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                params = params.setAutoEnterEnabled(hmsPipConfig.autoEnterEnabled)
            }

            result.success(
                activity.enterPictureInPictureMode(params.build())
            )
        }

        fun updatePipActions(isMute:Boolean,activity : Activity,type:String,requestCode : Int){
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                when(requestCode){
                344 -> {
                    pipRemoteAction[type] = RemoteAction(
                        Icon.createWithResource(
                            activity,
                            if(isMute)
                                R.drawable.ic_mic_off_24
                            else
                                R.drawable.ic_mic_24
                        ),
                        type,
                        "",
                        PendingIntent.getBroadcast(activity,requestCode,Intent(PIP_ACTION_EVENT).putExtra( localAudioToggle,requestCode),
                            PendingIntent.FLAG_IMMUTABLE
                        )
                    )
                    activity.setPictureInPictureParams(
                        PictureInPictureParams.Builder()
                            .setActions(pipRemoteAction.map { it.value }.toList())
                            .build()
                    )
                }
                345 -> {
                    pipRemoteAction[type] = RemoteAction(
                        Icon.createWithResource(
                            activity,
                            if(isMute)
                                R.drawable.ic_camera_toggle_off
                            else
                                R.drawable.ic_camera_toggle_on
                        ),
                        type,
                        "",
                        PendingIntent.getBroadcast(activity,requestCode,Intent(PIP_ACTION_EVENT).putExtra( localVideoToggle,requestCode),
                            PendingIntent.FLAG_IMMUTABLE
                        )
                    )
                    activity?.setPictureInPictureParams(
                        PictureInPictureParams.Builder()
                            .setActions(pipRemoteAction.map { it.value }.toList())
                            .build()
                    )
                }
            }
            }
        }
    }
}