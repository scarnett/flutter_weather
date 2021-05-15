package io.flutter_weather

import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    // @see https://github.com/goderbauer/scratchpad/commit/fb5c97d3ecadf6c48bff20b5a8d83f8b19226070
    override fun onPostResume() {
      super.onPostResume()
      WindowCompat.setDecorFitsSystemWindows(window, false)
      window.navigationBarColor = 0
    }
}
