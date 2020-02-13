package xh.zero.flutter_demo.plugins

import android.content.Context
import android.view.View
import android.widget.TextView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class FlutterTextView(
        private val context: Context?,
        private val messenger: BinaryMessenger,
        id: Int
) : PlatformView, MethodChannel.MethodCallHandler {

    private val textView = TextView(context)

    private val methodChannel = MethodChannel(messenger, "xh.zero/textview_$id")

    init {
        methodChannel.setMethodCallHandler(this)
    }

    override fun getView(): View = textView

    override fun dispose() {
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "setText") {
            val txt: String? = call.arguments as? String
            textView.text = txt;
            result.success(null)
        }
    }
}