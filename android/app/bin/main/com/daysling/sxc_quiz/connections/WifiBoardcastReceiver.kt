package com.daysling.sxc_quiz.connections

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent


class WifiBoardcastReceive: BroadcastReceiver() {
    private lateinit var context: Context

    override fun onReceive(p0: Context?, p1: Intent?) {
        if (p0 != null) {
            this.context = p0
        }

    }

}
