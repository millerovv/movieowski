package com.millerovv.movieowski

import android.os.Build
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import android.view.WindowManager
import android.view.ViewTreeObserver



class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    //make transparent status bar
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      window.statusBarColor = 0x00000000
    }
    GeneratedPluginRegistrant.registerWith(this)

    window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
  }
}
