package com.yuno.flutter.yuno_flutter_plugin

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat.startActivityForResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar

import com.yuno.payments.core.Yuno
import com.yuno.payments.core.YunoConfig
import com.yuno.payments.features.base.ui.screens.CardFormType
import com.yuno.payments.features.payment.continuePayment
import com.yuno.payments.features.payment.startCheckout
import com.yuno.payments.features.payment.startPaymentLite
import com.yuno.payments.features.payment.ui.views.PaymentSelected

/** YunoFlutterPlugin */
class YunoFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    private lateinit var _result: MethodChannel.Result
    private lateinit var context: Context
    private var binding: ActivityPluginBinding? = null
    private var activity: Activity? = null
    private var flutterSDKProperty = "Yuno_IS_FLUTTER"

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "yuno_flutter_plugin")
        channel.setMethodCallHandler(this)
        this.context = flutterPluginBinding.applicationContext
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addActivityResultListener(this)
        this.binding = binding
        this.activity = binding.getActivity();
    }

    override fun onDetachedFromActivityForConfigChanges() {
        this.binding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        binding.addActivityResultListener(this)
        this.binding = binding
        this.activity = binding.getActivity();
    }

    override fun onDetachedFromActivity() {
        this.binding = null
    }

    @RequiresApi(Build.VERSION_CODES.N)
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        _result = result
        when(call.method) {
            "init" -> {
                val key = call.argument("key") ?: ""
                Yuno.initialize(
                    this.context,
                    key,
                    YunoConfig(
                        CardFormType.ONE_STEP,
                        false
                    )
                )
                val checkoutSession = call.argument("checkoutSession") ?: ""
                val country = call.argument("country") ?: ""
                val action = call.argument("action") ?: ""

                this.activity?.let {
                    val intent = Intent(it, YunoActivity::class.java)
                    val bundle = Bundle()
                    bundle.putString("checkoutSession", checkoutSession)
                    bundle.putString("country", country)
                    bundle.putString("action", action)
                    intent.putExtras(bundle)
                    intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
                    it.startActivityForResult(intent, 1121,null)
                }
            }
            else ->  result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        try {
            var Result: String? = "";
            when (requestCode) {
                1121 -> {
                    Result = data?.getStringExtra("ott") ?: "";
                }
            }
            _result.success(Result);
        } catch (e: Exception) {
            Log.i("YUNOSDK: Exception", e.toString());
        }
        return false
    }
}

class YunoActivity: AppCompatActivity(){
    var ott : String? = null
    var close: Boolean = true;
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        getIntent().getStringExtra("checkoutSession")?.let { checkoutSession ->
            getIntent().getStringExtra("country")?.let { country ->
                startCheckout (
                    checkoutSession,
                    country,
                    callbackOTT
                )
            }
        }
        getIntent().getStringExtra("action")?.let { action ->
            when (action) {
                "start" ->{
                    startPaymentLite(
                        PaymentSelected(
                            "CARD",vaultedToken = null
                        ),
                        callbackOTT
                    )
                }
                "result" ->{
                    continuePayment(
                        true,
                        callbackPaymentState
                    )
                }
            }
        }
    }

    override fun onPostResume() {
        super.onPostResume()
        close=!close;
        if(close) {
            if (ott == null) {
                closer()
            }
        }
    }


    val callbackOTT: (String?) -> Unit = {
        ott=it
        closer()
    }
    val callbackPaymentState: (String?) -> Unit = {
        finish()
    }
    private fun closer(){
        val closer = Intent()
        val backpack = Bundle()
        backpack.putString("ott", ott ?: "")
        closer.putExtras(backpack)
        setResult(1121, closer);
        finish()
    }
}