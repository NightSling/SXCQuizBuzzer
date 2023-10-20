package com.daysling.sxc_quiz.connections.server

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodChannel
import org.java_websocket.WebSocket
import org.java_websocket.handshake.ClientHandshake
import org.java_websocket.server.WebSocketServer
import java.lang.Exception
import java.net.InetSocketAddress

class WsServer: WebSocketServer(InetSocketAddress(8887)) {

    private val clients = mutableMapOf<String, WebSocket>()
    private var i = 0;
    companion object {
        var resourceChannel: MethodChannel? = null
    }

    init {
        System.setProperty("java.net.preferIPv6Addresses", "false")
        System.setProperty("java.net.preferIPv4Stack", "true")
    }

    override fun run() {
        Thread {
            super.run()
        }.start()
    }

    override fun onOpen(conn: WebSocket?, handshake: ClientHandshake?) {
    }

    override fun onClose(conn: WebSocket?, code: Int, reason: String?, remote: Boolean) {
        if (conn == null) return
        val name = clients.filterValues { it == conn }.keys.first()
        clients.remove(name)
        // return to ui thread and
        Handler(Looper.getMainLooper()).post {
            resourceChannel?.invokeMethod("onDeviceDisconnect", name)
        }
    }

    override fun onMessage(conn: WebSocket?, message: String?) {
        if(message == null) return
        if (message.startsWith("name=")) {
            val name = message.substring(5)
            clients[name] = conn!!
            Handler(Looper.getMainLooper()).post {
                resourceChannel?.invokeMethod("onDeviceConnect", name)
            }
            println("Name: $name")
        }
        if(message.startsWith("buzz=")) {
            val name = message.substring(5)
            Handler(Looper.getMainLooper()).post {
                resourceChannel?.invokeMethod("onBuzz", "${++i}#$name")
            }
            conn?.send("pos=$i")
        }
    }

    override fun onError(conn: WebSocket?, ex: Exception?) {

    }

    override fun onStart() {

    }

    fun boardcastMessage(message: String) {
        if (message == "RESET") {
            i = 0;
        }
        clients.forEach { (_, conn) ->
            conn.send(message)
        }
    }

}
