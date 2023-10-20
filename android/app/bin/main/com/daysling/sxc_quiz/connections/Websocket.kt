package com.daysling.sxc_quiz.connections

import com.daysling.sxc_quiz.connections.client.WsClient
import com.daysling.sxc_quiz.connections.server.WsServer
import java.net.URI

class Websocket {
    companion object {
        var wsClient: WsClient? = null
        var wsServer: WsServer? = null

        fun startServer() {
            // check null
            wsServer = WsServer()
            wsServer!!.run()
        }

        fun startClient(ip: String, name: String) {
            // check null
            startClient(false, ip, name)
        }

        fun startClient(createNew: Boolean, ip: String, name: String): WsClient {
            if (wsClient != null && !createNew) {
                return wsClient!!
            }
            val uri = URI("ws://$ip:8887")
            wsClient = WsClient(uri, name)
            wsClient!!.connect()
            return wsClient!!
        }

        fun stopServer() {
            // check null
            if(wsServer == null) return;
            wsServer!!.stop()
        }

    }
}
