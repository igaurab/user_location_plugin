package com.example.user_location

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import android.location.LocationListener
import android.location.LocationManager
import android.os.Bundle


class UserLocationPlugin: MethodCallHandler {
  companion object {
      var listener: LocationListener? = null
      var locationManager: LocationManager? = null

              @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "user_location")
      channel.setMethodCallHandler(UserLocationPlugin())

      val eventChannel = EventChannel(registrar.messenger(), "locationStatusStream")

     eventChannel.setStreamHandler(
            object: StreamHandler {
                override fun onListen(p0: Any?, p1: EventSink) {
                    listener = object : LocationListener {
                        override fun onLocationChanged(location: android.location.Location) {
                        }

                        override fun onStatusChanged(provider: String, status: Int, extras: Bundle) {

                        }

                        override fun onProviderEnabled(provider: String) {
                            p1.success(true)
                        }

                        override fun onProviderDisabled(provider: String) {
                            p1.success(false)
                        }
                    }

                    locationManager = registrar.activeContext().getSystemService(Context.LOCATION_SERVICE) as LocationManager
                    locationManager?.requestLocationUpdates(LocationManager.GPS_PROVIDER,
                            2000,
                            10f, listener ?: return)

                }
                override fun onCancel(p0: Any?) {
                    locationManager?.removeUpdates(listener ?: return)
                }
            }
     )


    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } 

    else {
      result.notImplemented()
    }
  }

}
