package de.revisor.guckmalreisebingo

import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import io.flutter.embedding.android.FlutterFragmentActivity

// FlutterFragmentActivity statt FlutterActivity: nur eine ComponentActivity
// kann enableEdgeToEdge() aufrufen. Das sorgt für die randlose Darstellung
// ab Android 15 und für ältere Versionen gleichermaßen.
class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
    }
}
