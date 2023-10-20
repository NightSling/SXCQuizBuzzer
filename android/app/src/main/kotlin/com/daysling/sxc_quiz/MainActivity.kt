package com.daysling.sxc_quiz

import android.Manifest
import android.content.pm.PackageManager
import android.media.MediaPlayer
import android.net.ConnectivityManager
import android.os.Build
import android.widget.Toast
import androidx.annotation.CallSuper
import androidx.core.app.ActivityCompat
import com.daysling.sxc_quiz.connections.Websocket
import com.daysling.sxc_quiz.connections.client.WsClient
import com.daysling.sxc_quiz.connections.server.WsServer
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.net.Inet6Address
import java.net.NetworkInterface
import java.net.SocketException
import kotlin.math.ln


class MainActivity : FlutterActivity() {
    private lateinit var userName: String
    private val CHANNEL = "com.daysling.sxc_quiz/communicate"
    private val CHANNEL_B = "com.daysling.sxc_quiz/communicate-receiver"
    private var channelRes: MethodChannel? = null
    private var endpointStore: MutableMap<String, String> = mutableMapOf()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channelRes = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_B)
        if (checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(
                arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION), 422
            )
        }
        if (checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(
                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), 422
            )
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ActivityCompat.requestPermissions(
                this.activity, arrayOf(
                    Manifest.permission.CHANGE_WIFI_STATE,
                    Manifest.permission.ACCESS_WIFI_STATE,
                    Manifest.permission.ACCESS_NETWORK_STATE,
                    Manifest.permission.CHANGE_NETWORK_STATE,
                ), 422
            )
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startServer" -> {
                    hostSocketServer()
                    result.success(getIpAddress())
                }

                "startGame" -> {
                    Websocket.wsServer?.boardcastMessage("START")
                    Websocket.wsServer?.boardcastMessage("LOCK")
                }

                "invokeBuzz" -> {
                    Websocket.wsClient?.send("buzz=$userName")
                    val e = MediaPlayer.create(this, R.raw.buzzer)
                    e.setOnCompletionListener { 
                        e.release()
                    }
                    e.start()
                }

                "lockBuzzer" -> {
                    Websocket.wsServer?.boardcastMessage("LOCK")
                }

                "unlockBuzzer" -> {
                    Websocket.wsServer?.boardcastMessage("UNLOCK")
                }

                "resetBuzzer" -> {
                    Websocket.wsServer?.boardcastMessage("RESET")
                }

                "stopServer" -> {
                    result.success("Server stopped")
                }

                "joinServer" -> {
                    val ip = call.arguments as String
                    WsClient.res = channelRes
                    joinServer(ip)
                    result.success("Joining server")
                }

                "playBuzzer" -> {
                    val e = MediaPlayer.create(this.context, R.raw.buzzer)
                    e.setVolume(1.5f, 1.5f);
                    e.isLooping = false
                    e.prepare()
                    e.start()
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun hostSocketServer() {
        // new thread
        WsServer.resourceChannel = channelRes
        Websocket.startServer()
    }

    private fun joinServer(name: String) {
        this.userName = name
        // Get wifi gateway
        val cm = this.context.getSystemService(CONNECTIVITY_SERVICE) as ConnectivityManager
        val prop = cm.getLinkProperties(cm.activeNetwork)
        prop?.routes?.forEach {
            if(it.isDefaultRoute && it.gateway !is Inet6Address) {
                val ip = it.gateway?.hostAddress
                if(ip != null) {
                    // start client
                    Websocket.startClient(true, ip, name)
                }
            }
        }
    }

    @CallSuper
    override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<out String>, grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        val errMsg = "Cannot start without required permissions"
        var i = 0
        if (requestCode == 422) {
            grantResults.forEach {
                if (it == PackageManager.PERMISSION_DENIED) {
                    // log what permissions are denied
                    println(permissions[i])
                    Toast.makeText(this, permissions[i], Toast.LENGTH_LONG).show()
                    finish()
                    return
                }
                i++
            }
        }
    }

    private fun getIpAddress(): String {
        var ip = ""
        try {
            val enumNetworkInterfaces = NetworkInterface
                .getNetworkInterfaces()
            while (enumNetworkInterfaces.hasMoreElements()) {
                val networkInterface = enumNetworkInterfaces
                    .nextElement()
                val enumInetAddress = networkInterface
                    .inetAddresses
                while (enumInetAddress.hasMoreElements()) {
                    val inetAddress = enumInetAddress.nextElement()
                    if (inetAddress.isSiteLocalAddress) {
                        ip += inetAddress.hostAddress + "\n"
                    }
                }
            }
        } catch (e: SocketException) {
            // TODO Auto-generated catch block
            e.printStackTrace()
            ip += "Something Wrong! $e\n"
        }
        return ip
    }

}
