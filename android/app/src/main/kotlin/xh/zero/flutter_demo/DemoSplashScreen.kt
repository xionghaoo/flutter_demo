package xh.zero.flutter_demo

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import io.flutter.embedding.android.SplashScreen

/**
 * 目前看来只能用于FlutterFragment
 */
class DemoSplashScreen : SplashScreen {
    override fun createSplashView(context: Context, p1: Bundle?): View? {
        return LayoutInflater.from(context).inflate(R.layout.splash_screen, null)
    }

    override fun transitionToFlutter(onTransitionComplete: Runnable) {
        onTransitionComplete.run()
    }
}