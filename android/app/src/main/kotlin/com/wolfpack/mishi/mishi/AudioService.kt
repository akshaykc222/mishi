package com.wolfpack.mishi.mishi

import android.app.NotificationChannel
import android.app.NotificationManager

import android.app.Service
import android.content.Intent
import android.os.IBinder

class AudioService:Service() {
    var serviceRunning = false
//    lateinit var builder: NotificationCompat.Builder
    lateinit var channel: NotificationChannel
    lateinit var manager: NotificationManager
    override fun onBind(p0: Intent?): IBinder? {
        TODO("Not yet implemented")
    }
}