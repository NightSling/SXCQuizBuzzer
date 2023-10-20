package com.daysling.sxc_quiz.connections.client

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodChannel
import org.java_websocket.client.WebSocketClient
import org.java_websocket.handshake.ServerHandshake
import java.net.URI

class WsClient(serverUri: URI?, private var name: String) : WebSocketClient(serverUri) {

    companion object {
        var res: MethodChannel? = null;
    }

    override fun onOpen(handshakedata: ServerHandshake?) {
        this.send("name=$name");
    }

    override fun onMessage(message: String?) {
        if(message == null) return;
        if (message.startsWith("RESET")) {
            Handler(Looper.getMainLooper()).post {
                res?.invokeMethod("resetBuzzer", null);
            }
        }
        if (message.startsWith("LOCK")) {
            Handler(Looper.getMainLooper()).post {
                res?.invokeMethod("lockBuzzer", null);
            }
        }
        if (message.startsWith("UNLOCK")) {
            Handler(Looper.getMainLooper()).post {
                res?.invokeMethod("unlockBuzzer", null);
            }
        }
        if (message.startsWith("pos=")) {
            Handler(Looper.getMainLooper()).post {
                res?.invokeMethod("setBuzzPosition", message.substring(4));
            }
        }
    }

    override fun onClose(code: Int, reason: String?, remote: Boolean) {
        println("Closed with exit code $code additional info: $reason")
    }

    override fun onError(ex: Exception?) {
        println(ex);
    }

}
