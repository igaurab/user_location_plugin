package com.example.user_location

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import android.location.LocationListener
import android.os.Bundle


class UserLocationPlugin: MethodCallHandler, LocationListener {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "user_location")
      channel.setMethodCallHandler(UserLocationPlugin())

      val eventChannel = EventChannel(registrar.messenger(),"locationPermissionStream")
      eventChannel.setMethodCallHandler(UserLocationPlugin())

    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } 
    else if(call.method == "onLocationStatusChanged" ) {
        subscribeToLocationProvider(result)
    }
    else {
      result.notImplemented()
    }
  }

  fun subscribeToLocationProvider(result: Result) {

    val locationListenerGPS = object : LocationListener {
      override fun onLocationChanged(location: android.location.Location) {
        val latitude = location.latitude
        val longitude = location.longitude
      }

      override fun onStatusChanged(provider: String, status: Int, extras: Bundle) {

      }

      override fun onProviderEnabled(provider: String) {
        result.success(true)
      }

      override fun onProviderDisabled(provider: String) {
        result.success(false)
      }
    }
  }
}
