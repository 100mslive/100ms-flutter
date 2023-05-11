package live.hms.hmssdk_flutter.views

import android.content.Context
import android.view.View
import io.flutter.plugin.platform.PlatformView
import live.hms.hls_player.HmsHlsPlayer

class HMSHLSPlayer(
    context: Context,
    private val hlsUrl: String?):PlatformView {

    var hlsPlayer: HmsHlsPlayer? = null

    init {
        
    }
    override fun getView(): View? {
        TODO("Not yet implemented")
    }

    override fun dispose() {
        TODO("Not yet implemented")
    }

    override fun onFlutterViewAttached(flutterView: View) {
        super.onFlutterViewAttached(flutterView)
        hlsUrl?.let {
            hlsPlayer?.play(hlsUrl)
        }
    }
}