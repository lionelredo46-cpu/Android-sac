package ga.afram.uniparent

import android.content.ComponentName
import android.content.pm.PackageManager
import android.nfc.cardemulation.HostApduService
import android.os.Bundle

/**
 * Tap-to-Sync : le téléphone se présente comme un tag NFC Forum de type 4 (NDEF).
 * L'autre téléphone (Android ou iPhone) lit la semaine partagée comme un tag ordinaire,
 * sans appairage ni réseau. Le service n'est activé que pendant un partage (MainActivity).
 */
class TimetableHceService : HostApduService() {
    companion object {
        /** Fichier NDEF servi : longueur sur 2 octets + message NDEF. null = aucun partage. */
        @Volatile
        var ndefFile: ByteArray? = null

        /** Taille maximale du message : fichier NDEF de 0x7FFF octets (CC_FILE), longueur comprise. */
        const val MAX_MESSAGE = 0x7FFD

        /** Expose [message] ; false s'il dépasse la capacité d'un tag de type 4. */
        fun share(message: ByteArray): Boolean {
            if (message.size > MAX_MESSAGE) return false
            ndefFile = byteArrayOf((message.size shr 8).toByte(), message.size.toByte()) + message
            return true
        }

        private val NDEF_AID = hex("D2760000850101")
        private val CC_FILE_ID = hex("E103")
        private val NDEF_FILE_ID = hex("E104")
        private val OK = hex("9000")
        private val NOT_FOUND = hex("6A82")
        private val WRONG_OFFSET = hex("6B00")
        private val NOT_ALLOWED = hex("6986")
        private val UNKNOWN = hex("6D00")

        /** Capability Container : lecture libre, écriture interdite, réponses de 240 octets au plus. */
        private val CC_FILE = hex("000F2000F000F40406E1047FFF00FF")

        private fun hex(s: String) = ByteArray(s.length / 2) { s.substring(it * 2, it * 2 + 2).toInt(16).toByte() }
    }

    private var appSelected = false
    private var file: ByteArray? = null

    override fun processCommandApdu(apdu: ByteArray, extras: Bundle?): ByteArray {
        val ndef = ndefFile ?: run {
            // Processus tué pendant un partage : le composant est resté actif sans contenu,
            // il se désactive pour ne plus réclamer l'AID NDEF auprès des lecteurs.
            packageManager.setComponentEnabledSetting(
                ComponentName(this, TimetableHceService::class.java),
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                PackageManager.DONT_KILL_APP,
            )
            return NOT_FOUND
        }
        if (apdu.size < 4) return UNKNOWN
        val ins = apdu[1].toInt() and 0xFF
        val p1 = apdu[2].toInt() and 0xFF
        val p2 = apdu[3].toInt() and 0xFF
        return when (ins) {
            0xA4 -> select(apdu, p1, ndef)
            0xB0 -> readBinary(apdu, (p1 shl 8) or p2)
            else -> UNKNOWN
        }
    }

    private fun select(apdu: ByteArray, p1: Int, ndef: ByteArray): ByteArray {
        if (apdu.size < 5) return UNKNOWN
        val length = apdu[4].toInt() and 0xFF
        if (apdu.size < 5 + length) return UNKNOWN
        val data = apdu.copyOfRange(5, 5 + length)
        return when {
            p1 == 0x04 && data.contentEquals(NDEF_AID) -> {
                appSelected = true
                file = null
                OK
            }
            appSelected && data.contentEquals(CC_FILE_ID) -> {
                file = CC_FILE
                OK
            }
            appSelected && data.contentEquals(NDEF_FILE_ID) -> {
                file = ndef
                OK
            }
            else -> NOT_FOUND
        }
    }

    private fun readBinary(apdu: ByteArray, offset: Int): ByteArray {
        val current = file ?: return NOT_ALLOWED
        if (offset > current.size) return WRONG_OFFSET
        val requested = if (apdu.size > 4) (apdu[4].toInt() and 0xFF).let { if (it == 0) 256 else it } else 256
        val end = minOf(current.size, offset + requested)
        return current.copyOfRange(offset, end) + OK
    }

    override fun onDeactivated(reason: Int) {
        appSelected = false
        file = null
    }
}
