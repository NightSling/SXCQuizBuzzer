package com.daysling.sxc_quiz

import android.app.Application
import android.content.Intent

class Core: Application() {
    override fun onCreate() {
        super.onCreate()
        val intent = Intent(this, NetService::class.java)
    }
}
