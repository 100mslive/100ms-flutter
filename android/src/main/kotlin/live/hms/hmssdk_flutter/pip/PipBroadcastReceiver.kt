package live.hms.hmssdk_flutter.pip

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter

class PipBroadcastReceiver (val toogleLocalAudio: () -> Unit,val toggleLocalVideo: () -> Unit, val leaveRoom: () -> Unit) :

    BroadcastReceiver(){
    override fun onReceive(
        context: Context,
        intent: Intent,
    ) {
        if (intent.hasExtra("localAudioToggle"))
            toogleLocalAudio()
        else if(intent.hasExtra("localVideoToggle"))
            toggleLocalVideo()
        else if (intent.hasExtra("leaveRoom"))
            leaveRoom()
    }

    fun register(activity: Activity) {
        val filter = IntentFilter()
        filter.addAction("PIP_ACTION_EVENT")
        activity.registerReceiver(this, filter)
    }

    fun unregister(activity: Activity) {
        activity.unregisterReceiver(this)
    }

    }