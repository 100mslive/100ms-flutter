package live.hms.hmssdk_flutter.views

import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.FrameLayout
import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.ui.StyledPlayerView
import com.google.android.exoplayer2.util.MimeTypes
import live.hms.hmssdk_flutter.R

class HMSVideoPlayer(context: Context,
                     private val url: String):FrameLayout(context, null) {
    private var view: View? = null
    private var hmsVideoPlayer: StyledPlayerView? = null
    private var player: ExoPlayer? = null

    init {
        view =
            (context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater).inflate(R.layout.hms_video_player, this)
        if (view != null) {
            player = ExoPlayer.Builder(context).build()
            hmsVideoPlayer = view?.findViewById(R.id.hmsVideoPlayer)
            hmsVideoPlayer?.player = player
            player?.playWhenReady = true
            val mediaItem = MediaItem.Builder()
                .setUri(url)
                .setMimeType(MimeTypes.APPLICATION_M3U8)
                .build()
            player?.setMediaItem(mediaItem)
            player?.prepare()
        } else {
            Log.i("HMSVideoPlayer Error", "HMSVideoView init error view is null")
        }
    }

    fun onDisposeCalled() {
        hmsVideoPlayer?.player?.stop()
        hmsVideoPlayer?.player?.release()
        player = null
        view = null
        hmsVideoPlayer = null
    }
}