package com.droidfakecam

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.button.MaterialButton
import com.google.android.material.textview.MaterialTextView
import android.widget.Toast
import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val statusText: MaterialTextView = findViewById(R.id.statusText)
        val moduleSummary: MaterialTextView = findViewById(R.id.moduleSummary)
        val logOutput: MaterialTextView = findViewById(R.id.logOutput)
        val checkButton: MaterialButton = findViewById(R.id.buttonCheck)
        val toggleButton: MaterialButton = findViewById(R.id.buttonToggle)

        moduleSummary.text = getString(R.string.moduleSummary)

        checkButton.setOnClickListener {
            val result = runModuleCommand("status")
            val enabled = result.contains("vcam_sink=enabled")
            statusText.text = if (enabled) {
                getString(R.string.statusEnabled)
            } else {
                getString(R.string.statusDisabled)
            }
            logOutput.text = result
        }

        toggleButton.setOnClickListener {
            val result = runModuleCommand("toggle")
            logOutput.text = result
            Toast.makeText(this, "Toggle request sent to Magisk module", Toast.LENGTH_SHORT).show()
        }
    }

    private fun runModuleCommand(command: String): String {
        // The Magisk module drops a control script into /data/adb/modules/droidfakecam/bin/vcamctl
        // The script proxies to the module's service logic. We invoke it over su to avoid SELinux
        // issues on rooted devices.
        val scriptPath = "/data/adb/modules/droidfakecam/bin/vcamctl"
        if (!File(scriptPath).exists()) {
            return "vcamctl not found at $scriptPath\nInstall and enable the Magisk module first."
        }

        return try {
            val process = ProcessBuilder("su", "-c", "$scriptPath $command")
                .redirectErrorStream(true)
                .start()
            val reader = BufferedReader(InputStreamReader(process.inputStream))
            val output = buildString {
                reader.forEachLine { appendLine(it) }
            }
            process.waitFor()
            if (output.isBlank()) "Command executed with no output" else output
        } catch (ex: Exception) {
            "Failed to run vcamctl: ${ex.message}"
        }
    }
}
