package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.OnTranscriptionError
import live.hms.video.sdk.models.TranscriptionState
import live.hms.video.sdk.models.Transcriptions
import live.hms.video.sdk.models.TranscriptionsMode
import live.hms.video.sdk.transcripts.HmsTranscript

class HMSTranscriptExtension {

    companion object{

        fun toDictionary(hmsTranscript: HmsTranscript):HashMap<String,Any?>{

            val args = HashMap<String,Any?>()

            args["start"] = hmsTranscript.start
            args["end"] = hmsTranscript.end
            args["transcript"] = hmsTranscript.transcript
            args["peer_id"] = hmsTranscript.peerId
            args["peer_name"] = hmsTranscript.peer?.name
            args["is_final"] = hmsTranscript.isFinal
            return args
        }

        fun getMapFromTranscriptionsList(transcriptions : List<Transcriptions>): ArrayList<HashMap<String,Any?>>{

            val transcriptionList = ArrayList<HashMap<String,Any?>>()

            transcriptions.forEach {_transcription ->
                transcriptionList.add(getMapFromTranscription(_transcription))
            }

            return transcriptionList
        }

        private fun getMapFromTranscription(transcription: Transcriptions): HashMap<String,Any?>{

            val args = HashMap<String,Any?>()

            args["error"] = transcriptionErrorExtension(transcription.error)
            args["started_at"] = transcription.startedAt
            args["stopped_at"] = transcription.stoppedAt
            args["updated_at"] = transcription.updatedAt
            args["state"] = getStringFromTranscriptionState(transcription.state)
            args["mode"] = getStringFromTranscriptionMode(transcription.mode)

            return args
        }

        private fun transcriptionErrorExtension(onTranscriptionError: OnTranscriptionError?): HashMap<String,Any?>?{
            onTranscriptionError?.let {_transcriptionError ->

                val args = HashMap<String,Any?>()

                args["code"] = _transcriptionError.code
                args["message"] = _transcriptionError.message

                return args

            }?: run {
                return null
            }
        }

        private fun getStringFromTranscriptionState(transcriptionState: TranscriptionState?): String?{
            return when(transcriptionState){
                TranscriptionState.STARTED -> "started"
                TranscriptionState.STOPPED -> "stopped"
                TranscriptionState.INITIALIZED -> "initialized"
                TranscriptionState.FAILED -> "failed"
                else -> null
            }
        }

        fun getTranscriptionModeFromString(transcriptionMode: String): TranscriptionsMode?{
            return when(transcriptionMode){
                "caption" -> TranscriptionsMode.CAPTION
                "live" -> TranscriptionsMode.LIVE
                else -> null
            }
        }

        fun getStringFromTranscriptionMode(transcriptionMode: TranscriptionsMode?): String?{
            return when(transcriptionMode){
                TranscriptionsMode.CAPTION -> "caption"
                TranscriptionsMode.LIVE -> "live"
                else -> null
            }
        }
    }
}
