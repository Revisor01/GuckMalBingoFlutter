# R8-Regeln für Guck mal! Reisebingo
# Flutter bringt eigene Regeln mit (flutter_proguard_rules.pro), die Plugins
# ihre consumer-rules. Hier nur, was darüber hinaus nötig ist.

# Stacktraces in Play Console lesbar halten (Dateiname + Zeilennummer)
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# Flutter-Engine referenziert Play Core (Deferred Components), das die App
# nicht nutzt – ohne diese Zeile bricht R8 mit "Missing class" ab.
-dontwarn com.google.android.play.core.**

# flutter_secure_storage nutzt Tink; dessen Annotationen fehlen zur Laufzeit.
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**
