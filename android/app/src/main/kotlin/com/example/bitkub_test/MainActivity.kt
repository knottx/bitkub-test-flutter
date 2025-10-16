package com.example.bitkub_test

import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties

class MainActivity: FlutterActivity() {
  private val CHANNEL = "com.example.bitkub_test.crypto.device"
  private val KEY_ALIAS = "com.example.bitkub_test.crypto.device.sym.v1"
  private val IV_SIZE = 12
  private val TAG_SIZE_BIT = 128

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
      .setMethodCallHandler { call, result ->
        try {
          when (call.method) {
            "encrypt" -> {
              val data = call.argument<ByteArray>("data")!!
              val aad  = call.argument<ByteArray>("aad")
              result.success(encrypt(data, aad))
            }
            "decrypt" -> {
              val combined = call.argument<ByteArray>("data")!!
              val aad      = call.argument<ByteArray>("aad")
              result.success(decrypt(combined, aad))
            }
            else -> result.notImplemented()
          }
        } catch (e: Exception) {
          result.error("CRYPTO_ERR", e.message, null)
        }
      }
  }

  private fun getOrCreateKey(): SecretKey {
    val ks = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }

    
    if (ks.containsAlias(KEY_ALIAS)) {
      try {
        return ks.getKey(KEY_ALIAS, null) as SecretKey
      } catch (e: Exception) {
        
        ks.deleteEntry(KEY_ALIAS)
      }
    }

    val km = getSystemService(KEYGUARD_SERVICE) as android.app.KeyguardManager
    val hasSecureLock = km.isDeviceSecure

    fun buildSpec(requireAuth: Boolean): KeyGenParameterSpec {
      val b = KeyGenParameterSpec.Builder(
        KEY_ALIAS,
        KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
      )
        .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
        .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
        .setRandomizedEncryptionRequired(true)

      if (requireAuth) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
          b.setUserAuthenticationRequired(true)
          .setUserAuthenticationParameters(
            60, 
            KeyProperties.AUTH_BIOMETRIC_STRONG or KeyProperties.AUTH_DEVICE_CREDENTIAL
          )
        } else {
          b.setUserAuthenticationRequired(true)
          .setUserAuthenticationValidityDurationSeconds(60)
        }
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
          b.setInvalidatedByBiometricEnrollment(true)
        }
      } else { 
        b.setUserAuthenticationRequired(false)
      }

      
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
        try { b.setIsStrongBoxBacked(true) } catch (_: Exception) { /* ignore */ }
      }

      return b.build()
    }

    
    val kg = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore")
    if (hasSecureLock) {
      try {
        kg.init(buildSpec(requireAuth = true))
        return kg.generateKey()
      } catch (e: Exception) {
        
        ks.deleteEntry(KEY_ALIAS)
      }
    }

    
    try {
      kg.init(buildSpec(requireAuth = false))
      return kg.generateKey()
    } catch (e: Exception) {
      
      val b = KeyGenParameterSpec.Builder(
        KEY_ALIAS,
        KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
      )
        .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
        .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
        .setRandomizedEncryptionRequired(true)
        .setUserAuthenticationRequired(false)
      
      ks.deleteEntry(KEY_ALIAS)
      kg.init(b.build())
      return kg.generateKey()
    }
  }

  private fun encrypt(plain: ByteArray, aad: ByteArray?): ByteArray {
    val key = getOrCreateKey()
    val cipher = Cipher.getInstance("AES/GCM/NoPadding")
    cipher.init(Cipher.ENCRYPT_MODE, key)
    if (aad != null) cipher.updateAAD(aad)

    val iv = cipher.iv     
    val ct = cipher.doFinal(plain)  
    
    return ByteArray(iv.size + ct.size).apply {
      System.arraycopy(iv, 0, this, 0, iv.size)
      System.arraycopy(ct, 0, this, iv.size, ct.size)
    }
  }

  private fun decrypt(combined: ByteArray, aad: ByteArray?): ByteArray {
    require(combined.size > IV_SIZE + 16) { "Combined too short" }
    val iv = combined.copyOfRange(0, IV_SIZE)
    val ctWithTag = combined.copyOfRange(IV_SIZE, combined.size)

    val key = getOrCreateKey()
    val cipher = Cipher.getInstance("AES/GCM/NoPadding")
    cipher.init(Cipher.DECRYPT_MODE, key, GCMParameterSpec(TAG_SIZE_BIT, iv))
    if (aad != null) cipher.updateAAD(aad)

    return cipher.doFinal(ctWithTag)
  }
}