package ga.afram.uniparent

import android.content.ComponentName
import android.content.pm.PackageManager
import android.nfc.NfcAdapter
import android.nfc.cardemulation.CardEmulation
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// FlutterFragmentActivity est requis par local_auth (biométrie).
class MainActivity : FlutterFragmentActivity() {
    private val hceComponent by lazy { ComponentName(this, TimetableHceService::class.java) }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // L'activation du composant survit à la mort du processus : on repart d'un état propre.
        if (TimetableHceService.ndefFile == null) setHceEnabled(false)
        // Tap-to-Sync : active l'émulation de tag NFC le temps d'un partage d'emploi du temps.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "ga.afram.uniparent/hce").setMethodCallHandler { call, result ->
            when (call.method) {
                "isSupported" -> result.success(packageManager.hasSystemFeature(PackageManager.FEATURE_NFC_HOST_CARD_EMULATION))
                "start" -> {
                    val ndef = call.argument<ByteArray>("ndef")
                    when {
                        ndef == null -> result.error("400", "Message NDEF manquant", null)
                        !TimetableHceService.share(ndef) -> result.error("413", "Message NDEF trop volumineux", null)
                        else -> {
                            setHceEnabled(true)
                            result.success(null)
                        }
                    }
                }
                "stop" -> {
                    stopSharing()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun cardEmulation(): CardEmulation? = NfcAdapter.getDefaultAdapter(this)?.let { CardEmulation.getInstance(it) }

    private fun setHceEnabled(enabled: Boolean) {
        packageManager.setComponentEnabledSetting(
            hceComponent,
            if (enabled) PackageManager.COMPONENT_ENABLED_STATE_ENABLED else PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP,
        )
        // Priorité à UniParent tant que l'écran de partage est au premier plan.
        runCatching { if (enabled) cardEmulation()?.setPreferredService(this, hceComponent) else cardEmulation()?.unsetPreferredService(this) }
    }

    private fun stopSharing() {
        TimetableHceService.ndefFile = null
        setHceEnabled(false)
    }

    override fun onDestroy() {
        if (TimetableHceService.ndefFile != null) stopSharing()
        super.onDestroy()
    }
}
