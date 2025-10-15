package com.droidfakecam

import android.net.Uri
import android.os.Bundle
import android.widget.Button
import android.widget.Switch
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import com.topjohnwu.superuser.Shell

class MainActivity : AppCompatActivity() {

    private val pickVideoLauncher = registerForActivityResult(ActivityResultContracts.GetContent()) { uri: Uri? ->
        uri?.let { handleVideoSelection(it) }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val pickButton: Button = findViewById(R.id.btn_pick_video)
        val enableSwitch: Switch = findViewById(R.id.switch_enable)

        pickButton.setOnClickListener {
            // Launch file picker for video
            pickVideoLauncher.launch("video/*")
        }

        enableSwitch.setOnCheckedChangeListener { _, isChecked ->
            // Toggle disable flag: when switch off, create disable flag
            toggleDisableFlag(!isChecked)
        }

        // Check for root access
        if (!Shell.isAppGrantedRoot()) {
            Toast.makeText(this, "Root access is required for full functionality", Toast.LENGTH_LONG).show()
        }
    }

    private fun handleVideoSelection(uri: Uri) {
        val destPath = "/sdcard/DCIM/Camera1/virtual.mp4"
        // Ensure directory exists
        Shell.cmd("mkdir -p /sdcard/DCIM/Camera1").exec()
        contentResolver.openInputStream(uri)?.use { input ->
            // Use libsu to write the file as root
            Shell.su("cat > '$destPath'").to(input).exec()
        }
        Toast.makeText(this, "Video selected", Toast.LENGTH_SHORT).show()
    }

    private fun toggleDisableFlag(disable: Boolean) {
        val flagPath = "/sdcard/DCIM/Camera1/disable.jpg"
        if (disable) {
            Shell.cmd("touch $flagPath").exec()
        } else {
            Shell.cmd("rm -f $flagPath").exec()
        }
    }
}
