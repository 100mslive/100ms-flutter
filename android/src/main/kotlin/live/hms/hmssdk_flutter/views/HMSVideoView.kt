package live.hms.hmssdk_flutter.views

import android.content.Context
import android.content.res.Resources
import android.graphics.Rect
import android.os.Build
import android.util.Log
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.View
import android.widget.FrameLayout
import android.widget.LinearLayout
import androidx.annotation.RequiresApi
import androidx.constraintlayout.widget.ConstraintLayout
import live.hms.hmssdk_flutter.R
import live.hms.hmssdk_flutter.views.HMSVideoView.Draggable.DRAG_TOLERANCE
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.video.sdk.models.HMSPeer
import live.hms.video.utils.SharedEglContext
import org.webrtc.EglBase
import org.webrtc.RendererCommon
import org.webrtc.SurfaceViewRenderer
import java.lang.Float.max
import java.lang.Float.min
import java.lang.Math.abs

class HMSVideoView(
    context: Context,
    setMirror: Boolean,
    scaleType: Int? = RendererCommon.ScalingType.SCALE_ASPECT_FIT.ordinal
) : FrameLayout(context, null) {
    val surfaceViewRenderer: SurfaceViewRenderer

    init {
        val inflater =
            getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val view = inflater.inflate(R.layout.hms_video_view, this)

        surfaceViewRenderer = view.findViewById(R.id.surfaceViewRenderer)
        surfaceViewRenderer.setEnableHardwareScaler(true)
        Log.i("HMSVideoViewAndroid", setMirror.toString())
        surfaceViewRenderer.setMirror(setMirror)
        if (scaleType ?: 0 <= RendererCommon.ScalingType.values().size) {
            surfaceViewRenderer.setScalingType(RendererCommon.ScalingType.values()[scaleType ?: 0])
        }
        surfaceViewRenderer.init(SharedEglContext.context, null)
    }


    private var draggableListener: DraggableListener? = null
    private var widgetInitialX: Float = 0F
    private var widgetDX: Float = 0F
    private var widgetInitialY: Float = 0F
    private var widgetDY: Float = 0F

    init {
//        draggableSetup()
    }

    @RequiresApi(Build.VERSION_CODES.N)
    private fun draggableSetup() {
        this.setOnTouchListener { v, event ->
            val viewParent = v.parent as View
            val parentHeight = viewParent.height
            val parentWidth = viewParent.width
            val xMax = parentWidth - v.width
            val xMiddle = parentWidth / 2
            val yMax = parentHeight - v.height

            when (event.actionMasked) {
                MotionEvent.ACTION_DOWN -> {
                    widgetDX = v.x - event.rawX
                    widgetDY = v.y - event.rawY
                    widgetInitialX = v.x
                    widgetInitialY = v.y
                }
                MotionEvent.ACTION_MOVE -> {
                    var newX = event.rawX + widgetDX
                    newX = max(0F, newX)
                    newX = min(xMax.toFloat(), newX)
                    v.x = newX

                    var newY = event.rawY + widgetDY
                    newY = max(0F, newY)
                    newY = min(yMax.toFloat(), newY)
                    v.y = newY

                    draggableListener?.onPositionChanged(v)
                }
                MotionEvent.ACTION_UP -> {
                    if (event.rawX >= xMiddle) {
                        v.animate().x(xMax.toFloat())
                            .setDuration(Draggable.DURATION_MILLIS)
                            .setUpdateListener { draggableListener?.onPositionChanged(v) }
                            .start()
                    } else {
                        v.animate().x(0F).setDuration(Draggable.DURATION_MILLIS)
                            .setUpdateListener { draggableListener?.onPositionChanged(v) }
                            .start()
                    }
                    if (abs(v.x - widgetInitialX) <= DRAG_TOLERANCE && abs(v.y - widgetInitialY) <= DRAG_TOLERANCE) {
                        performClick()
                    } else draggableListener?.xAxisChanged(event.rawX >= xMiddle)
                }
                else -> return@setOnTouchListener false
            }
            true
        }
    }

    override fun performClick(): Boolean {
        Log.d("DraggableImageView", "click")
        return super.performClick()
    }

    object Draggable {
        const val DRAG_TOLERANCE = 16
        const val DURATION_MILLIS = 250L
    }

    interface DraggableListener {
        fun onPositionChanged(view: View)
        fun xAxisChanged(isInRightSide: Boolean)
    }

    fun setVideoTrack(track: HMSVideoTrack?) {
        track?.addSink(surfaceViewRenderer)
    }
}


