package com.daysling.sxc_quiz

import android.app.Service
import android.content.Intent
import android.os.Binder
import android.os.IBinder
import com.daysling.sxc_quiz.connections.Websocket

class NetService(
    private var isHost: Boolean = false,
    private var ip: String = "",
    private var name: String = ""
) : Service() {
    
    private val binder = ServiceBinder()
    override fun onBind(p0: Intent): IBinder {
        return binder
    }

    override fun onCreate() {
        super.onCreate()
        if (isHost) {
            Websocket.startServer()
        } else {
            Websocket.startClient(ip, name)
        }
    }

    inner class ServiceBinder : Binder() {
        fun getService(): NetService {
            // return this NetService
            return this@NetService
        }
    }
}
