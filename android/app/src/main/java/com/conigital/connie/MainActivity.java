
package com.conigital.connie;


import android.app.Activity;
import android.app.ActivityManager;
import android.app.AlertDialog;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.os.Build;
import android.os.Bundle;
import android.os.IBinder;
import android.os.Looper;
import android.os.SystemClock;
import android.speech.SpeechRecognizer;
import android.util.Log;

import java.lang.String;


import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.speech.RecognitionListener;
import android.speech.RecognizerIntent;
import android.speech.SpeechRecognizer;
import android.speech.tts.TextToSpeech;
import android.speech.tts.UtteranceProgressListener;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Locale;
import java.util.Set;


import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.ProcessLifecycleOwner;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.coloros.ocs.base.task.OnCompleteListener;
import com.coloros.ocs.base.task.Task;
import com.google.firebase.messaging.FirebaseMessaging;
import com.twilio.voice.Call;
import com.twilio.voice.CallException;
import com.twilio.voice.CallInvite;
import com.twilio.voice.ConnectOptions;
import com.twilio.voice.RegistrationException;
import com.twilio.voice.RegistrationListener;
import com.twilio.voice.Voice;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import com.conigital.connie.utils.TextFileUtil;

import static android.speech.RecognizerIntent.EXTRA_SPEECH_INPUT_MINIMUM_LENGTH_MILLIS;

public class MainActivity extends FlutterActivity implements MethodChannel.Result, RecognitionListener, TextToSpeech.OnUtteranceCompletedListener {
    private static final String CHANNEL = "flutter.native/helper";
    private String stoptts;
    private SpeechRecognizer speech;
    private Intent recognizerIntent;
    private String LOG_TAG = "VoiceRecognitionActivity";
    boolean listening = false;
    HashMap<String, String> map;
    private ProgressBar progressBar;
    MethodChannel.Result result1;
    boolean connieDetected = false;
    String callFrom;

    boolean callFromFlutter;
    boolean songisPlaying = false;
    boolean spotifyOpned = false;
    boolean welcometextMsg = false;
    String someData2;
    boolean notificationReceived = false;

    RegistrationListener registrationListener = registrationListener();
    Call.Listener callListener = callListener();

    private NotificationManager notificationManager;
    private AlertDialog alertDialog;
    private CallInvite activeCallInvite;
    private int activeCallNotificationId;
    private String accessToken;
    private Boolean makeCall = false;
    private Boolean twilioCallSupervisor = false;


    private boolean isReceiverRegistered = false;
    private VoiceBroadcastReceiver voiceBroadcastReceiver;

    private MethodChannel.Result methodResultWrapper;
    private Handler handler;

    boolean isBound = false;
    Call activeCall;
    boolean food  = false;

    HashMap<String, String> params = new HashMap<>();

    boolean callConnectedStatus = false;
    String notificationData;
    // Required for Voice

    String callTo;
    FlutterEngine flutterEngine;

    Intent speechRecognizerIntent;
    private ServiceConnection m_serviceConnection = new ServiceConnection()
    {
        @Override
        public void onServiceConnected(ComponentName name, IBinder binder) {
            isBound = true;
            Log.d(LOG_TAG, "onServiceConnected");
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            isBound = false;
            Log.d(LOG_TAG, "onServiceDisconnected");
        }
    };



    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TextFileUtil logger = new TextFileUtil(getApplicationContext());
        logger.writeLog("Main Activity", "OnCreate");
//        registerTwilio();
        notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        voiceBroadcastReceiver = new VoiceBroadcastReceiver();
        registerReceiver();
        Intent intent = getIntent();
        if (intent != null && intent.getExtras() != null) {
            Bundle extras = intent.getExtras();
//            String someData= extras.getString("title");
             someData2 = extras.getString("data");
             if(someData2!=null){
                 notificationReceived = true;
                 connieDetected = true;
                 Log.e("IncommingCallNotific", "yessssss");
//                 configureFlutterEngine(flutterEngine);

             }

//            Log.e("someData2",someData2);
//            result1.success(someData2);
        }
        if(ContextCompat.checkSelfPermission(this,Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED ){
            checkPermission();
        }



    }

    private void checkPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            ActivityCompat.requestPermissions(this,new String[]{Manifest.permission.RECORD_AUDIO},1);
//            ActivityCompat.requestPermissions(this, new String[] {Manifest.permission.CAMERA}, 2);

        }
    }

    private void checkCamPermission()
    {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            ActivityCompat.requestPermissions(this, new String[] {Manifest.permission.CAMERA}, 2);
        }
    }

    public void stop() {
        getApplicationContext().stopService(new Intent(getApplicationContext(), IncomingCallNotificationServiceNew.class));
        getApplicationContext().unbindService(m_serviceConnection);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            voiceBroadcastReceiver = new VoiceBroadcastReceiver();
                            registerReceiver();
                            result1 = result;
                            methodResultWrapper = new MethodResultWrapper(result);
                            if(notificationReceived){
                                connieDetected = true;
                                result1.success("firebase"+ " "+someData2);
                                notificationReceived = false;
                                Log.e("IncommingCallNotific", "flutter");

                            }
                            if (call.method.equals("helloFromNativeCode")) {
                                stoptts = call.argument("startOrStop");
                                accessToken = call.argument("accessToken");
                                callTo = call.argument("callTo");

                                Log.e("callFromFlutter", callFromFlutter + "");
                                //Call `twilio function make a call
                                if (stoptts.trim().equalsIgnoreCase("callTwilio")) {
                                    twilioCallSupervisor = true;
                                    makeCall = true;
                                    registerTwilio();
                                } else if (stoptts.trim().equalsIgnoreCase("calltwilioConnected")) {
                                    makeCall = false;
                                    callConnectedStatus = true;
                                    registerTwilio();
                                } else if (stoptts.trim().equalsIgnoreCase("registertwilio")) {
                                    makeCall = false;
                                    callConnectedStatus = false;
//                                    voiceBroadcastReceiver = new VoiceBroadcastReceiver();
//                                    registerReceiver();
//                                    registerTwilio();

                                } else if (stoptts.trim().equalsIgnoreCase("calltwilioDiscconectedFromUser")) {
                                    startServiceFotDiscooncted();
                                } else {
                                    twilioCallSupervisor = false;


                                    Log.e("stopCalled", "tsssssStop");
                                    Log.e("stopCalledAvi", stoptts.trim());

                                    //Call TTS feature
                                    callFromFlutter = call.argument("nativeTtsStarted");
                                    if (stoptts.trim().equalsIgnoreCase("stop")) {
                                        if(speech!=null) {
                                            speech.stopListening();
                                            speech.destroy();
                                        }
                                    } else if(stoptts.trim().equalsIgnoreCase("stopmusic"))
                                    {

                                            String action = "stop";
                                            Intent stopService =new Intent(this, BackgroundSoundService.class);
                                            stopService.setAction(action);
                                            startService(stopService);
                                            result1.success("musicstopped");

                                    }else{
                                        welcometext();
                                        callTTS();
                                    }
//                                    else {
//                                        if (!callFromFlutter) {
//                                        } else {
////                                            if(speech==null) {
//                                            try {
//                                                if(speech!=null){
//                                                    Log.e("destryedddd","speeech");
//
//                                                    speech.destroy();
//                                                }else{
//
//                                                    Log.e("destryedddd","createedd");
//
//                                                    speech = SpeechRecognizer.createSpeechRecognizer(this);
//                                                }
//
//                                            }catch(Exception e)
//                                            {
//                                                Log.e("ttseceleje",e.getMessage());
//                                            }
//
//                                                speechRecognizerIntent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
//                                                speechRecognizerIntent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
//                                                speechRecognizerIntent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.getDefault());
////                                               speechRecognizerIntent.putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true);
//                                                speechRecognizerIntent.putExtra(EXTRA_SPEECH_INPUT_MINIMUM_LENGTH_MILLIS, 10000);
////                                               speechRecognizerIntent.putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 3);
////                                            }
//                                            callTTS();
//                                        }
//
//                                    }
                                }

                            }
                        }
                );

    }

    private void welcometext()
    {
        if(!welcometextMsg){
            welcometextMsg = true;
            result1.success("welcometext");
        }
    }

    private void registerReceiver() {
        if (!isReceiverRegistered) {
            IntentFilter intentFilter = new IntentFilter();
            intentFilter.addAction(Constants.SPEECH_RESULT);
            intentFilter.addAction(Constants.FOREGROUND_NOTIFICATION);
            LocalBroadcastManager.getInstance(this).registerReceiver(
                    voiceBroadcastReceiver, intentFilter);
            isReceiverRegistered = true;
            Log.e("isReceiverRegistered", "isReceiverRegistered");
        }
    }

    private void startServiceFotDiscooncted() {
        Log.e("ServiceStarted ", "  Disconnected");
        Intent acceptIntent = new Intent(getApplicationContext(), IncomingCallNotificationServiceNew.class);
        acceptIntent.setAction(Constants.ACTION_DISCONNECTED);
        acceptIntent.putExtra(Constants.INCOMING_CALL_INVITE, activeCallInvite);
        acceptIntent.putExtra(Constants.INCOMING_CALL_NOTIFICATION_ID, activeCallNotificationId);
        Log.e("ServiceStarted ", "accept Disconnected");
        getApplicationContext().bindService(acceptIntent, m_serviceConnection, Context.BIND_AUTO_CREATE);
        startService(acceptIntent);
    }

    private boolean appInstalledOrNot(String uri)
    {
        PackageManager pm = getPackageManager();
        boolean app_installed = false;
        try
        {
            pm.getPackageInfo(uri, PackageManager.GET_ACTIVITIES);
            app_installed = true;
        }
        catch (PackageManager.NameNotFoundException e)
        {
            app_installed = false;
        }
        return app_installed ;
    }
    private class VoiceBroadcastReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();

            if(action.equals(Constants.FOREGROUND_NOTIFICATION)){
                Log.e("connieeeer", "connieeeer  " + intent.getAction());

                connieDetected = true;
                String notificationContentTitle =  intent.getStringExtra("title");
                String notificationContentBody =  intent.getStringExtra("body");


                result1.success("notify"+".."+ notificationContentTitle + ".."+notificationContentBody);
            }

            Log.e("ServiceStarted", "Accepeted  and Sent and received in receiver  " + intent.getAction());

//            Log.e("BroadcAset", "IncmoingBroadTriggered   " + intent.getAction().toString() + "");

            if (action != null && (action.equals(Constants.SPEECH_RESULT))){
                /*
                 * Handle the incoming or cancelled call invite
                 */
//                Log.e("BroadcAset", "Incmoing   " + intent.getAction().toString() + "");

                String speechValues  = intent.getStringExtra(Constants.SPEECH_RESULT_VALUE);

                Log.e("BroadcAset", "SpeechValues   " + speechValues.toString() + "");

                if(speechValues.trim().equalsIgnoreCase("pub")||speechValues.trim().equalsIgnoreCase("cafe")||speechValues.trim().equalsIgnoreCase("pupg")||speechValues.trim().equalsIgnoreCase("play music")||speechValues.trim().equalsIgnoreCase("change music")||speechValues.trim().equalsIgnoreCase("yes")||speechValues.trim().equalsIgnoreCase("no")||speechValues.trim().contains("video")||speechValues.trim().contains("Video")||speechValues.trim().contains("News")||speechValues.trim().contains("play")||speechValues.trim().contains("Play")||speechValues.trim().contains("bbc")){
                    connieDetected = true;
                }

                if(!twilioCallSupervisor) {
                    handleRecoText(speechValues);
                }
            }
        }
    }


    private void handleIncomingCallIntent(Intent intent) {
        if (intent != null && intent.getAction() != null) {
            String action = intent.getAction();
            activeCallInvite = intent.getParcelableExtra(Constants.INCOMING_CALL_INVITE);
            activeCallNotificationId = intent.getIntExtra(Constants.INCOMING_CALL_NOTIFICATION_ID, 0);

            Log.e("activeCallInvite", " " + activeCallInvite + "");
            switch (action) {
                case Constants.ACTION_INCOMING_CALL:
                    handleIncomingCall();
                    break;
                case Constants.ACTION_INCOMING_CALL_NOTIFICATION:
                    showIncomingCallDialog();
                    break;
                case Constants.ACTION_CANCEL_CALL:
                    handleCancel();
                    break;
                case Constants.ACTION_FCM_TOKEN:
//                    registerTwilio();
                    break;
                case Constants.ACTION_ACCEPT:
                    answer();
                    break;
                case Constants.ACTION_DISCONNECTED:
                    methodResultWrapper.success("disconnected");
                    break;
                default:
                    break;
            }
        }
    }

    private void handleCancel() {
        if (alertDialog != null && alertDialog.isShowing()) {
            SoundPoolManager.getInstance(this).stopRinging();
            alertDialog.cancel();
        }
    }

    /*
     * Accept an incoming Call
     */
    private void answer() {
        Log.e("Answered","djkwgdjhwagdhjaw");
        SoundPoolManager.getInstance(this).stopRinging();
        notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        activeCallInvite.accept(this, callListener);
        notificationManager.cancel(activeCallNotificationId);
        setCallUI();
        if (alertDialog != null && alertDialog.isShowing()) {
            methodResultWrapper.success("connected");
            alertDialog.dismiss();
        }
    }

    private void setCallUI() {
    }


    private void handleIncomingCall() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            showIncomingCallDialog();
        } else {
            if (isAppVisible()) {
                showIncomingCallDialog();
            }
        }
    }

    private boolean isAppVisible() {
        return ProcessLifecycleOwner
                .get()
                .getLifecycle()
                .getCurrentState()
                .isAtLeast(Lifecycle.State.STARTED);

    }

    public AlertDialog createIncomingCallDialog(
            Context context,
            CallInvite callInvite,
            DialogInterface.OnClickListener answerCallClickListener,
            DialogInterface.OnClickListener cancelClickListener) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(context);
        alertDialogBuilder.setIcon(R.drawable.navigation_empty_icon);
        alertDialogBuilder.setTitle("Incoming Call");
        alertDialogBuilder.setPositiveButton("Accept", answerCallClickListener);
        alertDialogBuilder.setNegativeButton("Reject", cancelClickListener);
        alertDialogBuilder.setMessage("Sanjeev - tab" + "  " + "is calling you");
        return alertDialogBuilder.create();
    }

    private void showIncomingCallDialog() {
        Log.e("isReceivegisteredAveee", isReceiverRegistered + "");
        Log.e("activeCallInvite", "   ctiveCallInviteckabsckjhbaskjcbsac");
        SoundPoolManager.getInstance(this).playRinging();
        if (activeCallInvite != null) {
            Log.e("activeCallInvite", "Object   " + activeCallInvite.toString() + "");

            Log.e("activeCallInvite", "From   " + activeCallInvite.getFrom().toString() + "");
            Log.e("activeCallInvite", "CallSID  " + activeCallInvite.getCallSid().toString() + "");
            Log.e("activeCallInvite", "To   " + activeCallInvite.getTo().toString() + "");
            Log.e("activeCallInvite", "CallerInfo   " + activeCallInvite.getCallerInfo().toString() + "");


//            Log.e("CaaalFrom",callFrom);
            String[] to = activeCallInvite.getTo().split(":");

            alertDialog = createIncomingCallDialog(MainActivity.this,
                    activeCallInvite,
                    answerCallClickListener(),
                    cancelCallClickListener());
            alertDialog.show();
        }
    }

    private DialogInterface.OnClickListener cancelCallClickListener() {
        return (dialogInterface, i) -> {
            SoundPoolManager.getInstance(MainActivity.this).stopRinging();
            if (activeCallInvite != null) {
                Intent intent = new Intent(MainActivity.this, IncomingCallNotificationServiceNew.class);
                intent.setAction(Constants.ACTION_REJECT);
                intent.putExtra(Constants.INCOMING_CALL_INVITE, activeCallInvite);
                getApplicationContext().bindService(intent, m_serviceConnection, Context.BIND_AUTO_CREATE);
                startService(intent);
            }
            if (alertDialog != null && alertDialog.isShowing()) {
                alertDialog.dismiss();
            }
        };
    }


    private DialogInterface.OnClickListener answerCallClickListener() {
        return (dialog, which) -> {
            Log.e("ServiceStarted ", "  Clicked accept");
            Intent acceptIntent = new Intent(getApplicationContext(), IncomingCallNotificationServiceNew.class);
            acceptIntent.setAction(Constants.ACTION_ACCEPT);
            acceptIntent.putExtra(Constants.INCOMING_CALL_INVITE, activeCallInvite);
            acceptIntent.putExtra(Constants.INCOMING_CALL_NOTIFICATION_ID, activeCallNotificationId);
            Log.e("ServiceStarted ", " Clicked accept startService");
            getApplicationContext().bindService(acceptIntent, m_serviceConnection, Context.BIND_AUTO_CREATE);
            startService(acceptIntent);
        };
    }

    private void registerTwilio() {
        Log.e("FCMToken", "Registering with FCM" + "calleddd");

        FirebaseMessaging.getInstance().getToken().addOnSuccessListener(this, instanceIdResult -> {
//            String fcmToken = instanceIdResult.();
            Log.e("FCMToken", "Registering with FCM" + instanceIdResult.toString());
            Log.e("FCMToken", "AcceessToken" + accessToken);
            RegistrationListener registrationListener = registrationListener();
            if (!callConnectedStatus) {
                Voice.register(accessToken, Voice.RegistrationChannel.FCM, instanceIdResult.toString(), registrationListener);
            }
        });

    }




    @Override
    protected void onPause() {
        if(speech!=null){
            speech.stopListening();
            speech.cancel();
            speech.destroy();

        }
        speech = null;

        super.onPause();
//        Log.i(TAG, "on pause called on TestActivity ");
    }

    private RegistrationListener registrationListener() {
        return new RegistrationListener() {
            @Override
            public void onRegistered(@NonNull String accessToken, @NonNull String fcmToken) {
                Log.e("FCMToken", "Successfully registered FCM " + fcmToken);
                if (makeCall) {
                    String[] strings = callTo.split(" ");
//                    Log.e("strings", strings[2]);

                    if(strings[2].toString().trim().equalsIgnoreCase("supervisor")) {
//                        callFrom = "7960887290";
//                        params.put("to", "+447960887290");
                        params.put("to", "+919513007561");
//                        params.put("to", "+447460269792");


                    }else {
                        callFrom = strings[2];
                        params.put("to", strings[2]);
//                        params.put("from","Sanjeev");

                    }
                    ConnectOptions connectOptions = new ConnectOptions.Builder(accessToken)
                            .params(params)
                            .build();
                    Call activeCall = Voice.connect(getApplicationContext(), connectOptions, callListener);
                }
            }

            @Override
            public void onError(@NonNull RegistrationException error,
                                @NonNull String accessToken,
                                @NonNull String fcmToken) {
                String message = String.format(
                        Locale.US,
                        "Registration Error: %d, %s",
                        error.getErrorCode(),
                        error.getMessage());
                Log.e("FCMToken", message);
            }
        };
    }


    private Call.Listener callListener() {
        return new Call.Listener() {
            /*
             * This callback is emitted once before the Call.Listener.onConnected() callback when
             * the callee is being alerted of a Call. The behavior of this callback is determined by
             * the answerOnBridge flag provided in the Dial verb of your TwiML application
             * associated with this client. If the answerOnBridge flag is false, which is the
             * default, the Call.Listener.onConnected() callback will be emitted immediately after
             * Call.Listener.onRinging(). If the answerOnBridge flag is true, this will cause the
             * call to emit the onConnected callback only after the call is answered.
             * See answeronbridge for more details on how to use it with the Dial TwiML verb. If the
             * twiML response contains a Say verb, then the call will emit the
             * Call.Listener.onConnected callback immediately after Call.Listener.onRinging() is
             * raised, irrespective of the value of answerOnBridge being set to true or false
             */
            @Override
            public void onRinging(@NonNull Call call) {


                Log.e("CallStatus", "OnrRing" + call);
                result1.success("ringing");


//                Log.d(TAG, "Ringing");
                /*
                 * When [answerOnBridge](https://www.twilio.com/docs/voice/twiml/dial#answeronbridge)
                 * is enabled in the <Dial> TwiML verb, the caller will not hear the ringback while
                 * the call is ringing and awaiting to be accepted on the callee's side. The application
                 * can use the `SoundPoolManager` to play custom audio files between the
                 * `Call.Listener.onRinging()` and the `Call.Listener.onConnected()` callbacks.
                 */
                if (BuildConfig.playCustomRingback) {
                    SoundPoolManager.getInstance(MainActivity.this).playRinging();
                }
            }

            @Override
            public void onConnectFailure(@NonNull Call call, @NonNull CallException error) {
                Log.e("CallStatus", "callFailed" + call);

                callConnectedStatus = false;

                result1.success("callfailed");

//                audioSwitch.deactivate();
                if (BuildConfig.playCustomRingback) {
                    SoundPoolManager.getInstance(MainActivity.this).stopRinging();
                }
//                Log.d(TAG, "Connect failure");
                String message = String.format(
                        Locale.US,
                        "Call Error: %d, %s",
                        error.getErrorCode(),
                        error.getMessage());
//                Log.e(TAG, message);
//                Snackbar.make(coordinatorLayout, message, Snackbar.LENGTH_LONG).show();
//                resetUI();
            }

            @Override
            public void onConnected(@NonNull Call call) {
//                audioSwitch.activate();
                if (BuildConfig.playCustomRingback) {
                    SoundPoolManager.getInstance(MainActivity.this).stopRinging();
                }
//                Log.d(TAG, "Connected");


                result1.success("connected");

//                runOnUiThread(new Runnable() {
//                    public void run() {
//                        result1.success("connected");
//
//                        // Do stuff…
//                    }
//                });
                Log.e("CallStatus", "connected" + call);
                activeCall = call;
            }

            @Override
            public void onReconnecting(@NonNull Call call, @NonNull CallException callException) {
                Log.e("CallStatus", "onREconnect" + call);
            }

            @Override
            public void onReconnected(@NonNull Call call) {
                Log.e("CallStatus", "onREconnecteddddd" + call);
            }

            @Override
            public void onDisconnected(@NonNull Call call, CallException error) {
                Log.e("CallStatus", "onDisconnected" + call);

                callConnectedStatus = false;

                result1.success("disconnected");
                if (BuildConfig.playCustomRingback) {
                    SoundPoolManager.getInstance(MainActivity.this).stopRinging();
                }
//                Log.d(TAG, "Disconnected");
                if (error != null) {
                    String message = String.format(
                            Locale.US,
                            "Call Error: %d, %s",
                            error.getErrorCode(),
                            error.getMessage());
                }
            }

            /*
             * currentWarnings: existing quality warnings that have not been cleared yet
             * previousWarnings: last set of warnings prior to receiving this callback
             *
             * Example:
             *   - currentWarnings: { A, B }
             *   - previousWarnings: { B, C }
             *
             * Newly raised warnings = currentWarnings - intersection = { A }
             * Newly cleared warnings = previousWarnings - intersection = { C }
             */
            public void onCallQualityWarningsChanged(@NonNull Call call,
                                                     @NonNull Set<Call.CallQualityWarning> currentWarnings,
                                                     @NonNull Set<Call.CallQualityWarning> previousWarnings) {

                Log.e("CallStatus", "onCallQualityWarningsChanged" + call);

            }
        };
    }

    private void callTTS() {
//        registerReceiver();

        if(!checkServiceRunning()) {
            startService(new Intent(MainActivity.this, MyService.class));
        }

        new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {
            @Override
            public void run() {
                if(!food) {
                    food = true;
                    connieDetected = true;
                    result1.success("food");
                }
            }
        }, 30000);





////        speech.setRecognitionListener(this);
//        Handler mainHandler = new Handler(getApplication().getMainLooper());
//
//        Runnable myRunnable = new Runnable() {
//            @Override
//            public void run() {
//                startService(new Intent(MainActivity.this, MyService.class));
//
////                resetSpeechRecognizer();
////                setRecogniserIntent();
////                try {
////                    speech.startListening(speechRecognizerIntent);
////                }catch(Exception e)
////                {
////                Log.e("ttseceleje1234",e.getMessage());}
////                // This is your code
////            }
////        };
////        mainHandler.post(myRunnable);
//            }
//        };
    }


    public boolean checkServiceRunning() {
        ActivityManager manager = (ActivityManager) getSystemService(ACTIVITY_SERVICE);
        if (manager != null) {
            for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(
                    Integer.MAX_VALUE)) {
                if (getString(R.string.my_service_name).equals(service.service.getClassName())) {
                    return true;
                }
            }
        }
        return false;
    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           @NonNull String[] permissions, @NonNull int[] grantResults) {
        if (requestCode == 1) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                checkCamPermission();
            } else {
                Toast.makeText(MainActivity.this, "Permission Denied!", Toast.LENGTH_SHORT).show();
                checkCamPermission();
                finish();
            }
        }

        if(requestCode ==  2)
        {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            } else {
                Toast.makeText(MainActivity.this, "Permission Denied!", Toast.LENGTH_SHORT).show();
                finish();
            }
        }
    }
    private String helloFromNativeCode() {
        return "Hello from Native Android Code";
    }

    @Override
    public void onReadyForSpeech(Bundle params) {
        Log.e("redayforspeach","sfeweew");

    }

    @Override
    public void onBeginningOfSpeech() {
    }

    @Override
    public void onRmsChanged(float rmsdB) {
    }

    @Override
    public void onBufferReceived(byte[] buffer) {

    }

    @Override
    public void onEndOfSpeech() {
        Log.i(LOG_TAG, "onEndOfSpeech");
        speech.stopListening();
    }

    @Override
    public void onError(int error) {
        String errorMessage = getErrorText(error);
        Log.i(LOG_TAG, "FAILED " + errorMessage);
           callTTS();
    }

    public String getErrorText(int errorCode) {
        String message;
        switch (errorCode) {
            case SpeechRecognizer.ERROR_AUDIO:
                message = "Audio recording error";
                break;
            case SpeechRecognizer.ERROR_CLIENT:
                message = "Client side error";
                break;
            case SpeechRecognizer.ERROR_INSUFFICIENT_PERMISSIONS:
                message = "Insufficient permissions";
                break;
            case SpeechRecognizer.ERROR_NETWORK:
                message = "Network error";
                break;
            case SpeechRecognizer.ERROR_NETWORK_TIMEOUT:
                message = "Network timeout";
                break;
            case SpeechRecognizer.ERROR_NO_MATCH:
                message = "No match";
                break;
            case SpeechRecognizer.ERROR_RECOGNIZER_BUSY:
                message = "RecognitionService busy";
                break;
            case SpeechRecognizer.ERROR_SERVER:
                message = "error from server";
                break;
            case SpeechRecognizer.ERROR_SPEECH_TIMEOUT:
                message = "No speech input";
                break;
            default:
                message = "Didn't understand, please try again.";
                break;
        }
        return message;
    }


    @Override
    public void onDestroy() {
        super.onDestroy();
        if(speech!=null)
        {
            speech.destroy();
        }

        if(isBound)
        {
            stop();
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        if(isBound) {
            stop();
        }
        if(speech!=null)
        {
            speech.destroy();
        }
    };
    @Override
    public void onResults(Bundle results) {
//        audioManager.setStreamMute(AudioManager.STREAM_MUSIC, false);
        Log.i(LOG_TAG, "onResults");
        ArrayList<String> matches = results
                .getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION);
        String text = "";
//        for (String result : matches) {
//            Log.e("AllMatches",result);
//            text += result + " ";
//        }

        text = matches.get(0).toString();
        Log.e("textspeech", text);
        if(text.toLowerCase().contains("stop song") ||text.toLowerCase().contains("stop music") ||text.toLowerCase().contains("stop"))
        {
            songisPlaying = false;
            String action = "stop";
            Intent stopService =new Intent(this, BackgroundSoundService.class);
            stopService.setAction(action);
            startService(stopService);
            result1.success("musicstopped");
        }else {
            if (text.toLowerCase().contains("a koni") || text.toLowerCase().contains("acorny") || text.toLowerCase().contains("hey Koni") || text.toLowerCase().contains("hi Koni") || text.toLowerCase().contains("Ek Koni") || text.toLowerCase().contains("hi Karni") || text.toLowerCase().contains("hakani")
                    || text.toLowerCase().contains("hai koni") || text.toLowerCase().contains("hey Connie") || text.toLowerCase().contains("connie") || text.contains("corny") ||
                    text.toLowerCase().contains("iconic") || text.toLowerCase().contains("hakani") || text.toLowerCase().contains("hi connie") ||
                    text.toLowerCase().contains("kahani") || text.toLowerCase().contains("connie") || text.toLowerCase().contains("economy")
                    || text.toLowerCase().contains("akon") || text.toLowerCase().contains("koni") || text.toLowerCase().contains("calling") || text.toLowerCase().contains("consider")
                    || text.toLowerCase().contains("conexa") || text.toLowerCase().contains("astrix") || text.toLowerCase().contains("astrix") || text.toLowerCase().contains("gane") || text.toLowerCase().contains("i can't") || text.toLowerCase().contains("recording")||text.toLowerCase().contains("according") ||text.toLowerCase().contains("android") || text.toLowerCase().contains("colony")||text.toLowerCase().contains("tectonic")||text.toLowerCase().contains("hay coin")|| text.toLowerCase().contains("take on Me")|| text.toLowerCase().contains("chicken") ){
                Log.e("textspeech", "conniedetected");
                connieDetected = true;
                if(songisPlaying) {
                    songisPlaying = false;
                    String action = "stop";
                    Intent stopService = new Intent(this, BackgroundSoundService.class);
                    stopService.setAction(action);
                    startService(stopService);
                    result1.success("musicstopped");
                }else
                {
                    result1.success("tph");
                }
//            tts.speak("Yes", TextToSpeech.QUEUE_ADD, map);//hi Karni hakani iconic
            } else {
                if (connieDetected) {

                    connieDetected = false;
                    if (text.toLowerCase().contains("open spotify") || text.toLowerCase().contains("open music")) {
                        boolean installedorNot = appInstalledOrNot("com.spotify.music");
                        if (installedorNot) {
                            spotifyOpned = true;
                            Intent LaunchIntent = getPackageManager()
                                    .getLaunchIntentForPackage("com.spotify.music");
                            startActivity(LaunchIntent);
                        } else {
                            try {
                                spotifyOpned = true;
                                startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=com.spotify.music")));
                            } catch (android.content.ActivityNotFoundException anfe) {
                                startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=" + "com.spotify.music")));
                            }
                        }
                    } else {
                        Log.e("stopsong", text);
                        if (text.toLowerCase().contains("play songs") || text.toLowerCase().contains("play best songs")) {
                            String action = "play";
                            songisPlaying = true;
                            Intent svc = new Intent(this, BackgroundSoundService.class);
                            svc.setAction(action);
                            startService(svc);result1.success("musicisplaying");
                        }
                        else {
                            if(spotifyOpned)
                            {
                               if(text.toLowerCase().contains("go back"))
                               {
                                   spotifyOpned = false;
                                   ActivityManager am = (ActivityManager) getApplicationContext().getSystemService("activity");
                                   Method forceStopPackage = null;
                                   try {
                                       forceStopPackage =am.getClass().getDeclaredMethod("forceStopPackage",String.class);
                                   } catch (NoSuchMethodException e) {
                                       e.printStackTrace();
                                   }
                                   forceStopPackage.setAccessible(true);
                                   try {
                                       forceStopPackage.invoke(am, "com.spotify.music");
                                   } catch (IllegalAccessException e) {
                                       e.printStackTrace();
                                   } catch (InvocationTargetException e) {
                                       e.printStackTrace();
                                   }

//                                   ActivityManager am = (ActivityManager) getSystemService(Activity.ACTIVITY_SERVICE);
//                                   am.killBackgroundProcesses("com.spotify.music");
                               }
                            }else {
                                result1.success(text);
                            }
                        }
                    }
                } else {
                    callTTS();
                }
            }
        }

    }

    void handleRecoText(String text){
        if(text.toLowerCase().contains("stop song") ||text.toLowerCase().contains("stop music") ||text.toLowerCase().contains("stop"))
        {
            songisPlaying = false;
            String action = "stop";
            Intent stopService =new Intent(this, BackgroundSoundService.class);
            stopService.setAction(action);
            startService(stopService);
            result1.success("musicstopped");
        }else {
            if (text.toLowerCase().contains("a koni") || text.toLowerCase().contains("acorny") || text.toLowerCase().contains("hey Koni") || text.toLowerCase().contains("hi Koni") || text.toLowerCase().contains("Ek Koni") || text.toLowerCase().contains("hi Karni") || text.toLowerCase().contains("hakani")
                    || text.toLowerCase().contains("hai koni") || text.toLowerCase().contains("hey Connie") || text.toLowerCase().contains("connie") || text.contains("corny") ||
                    text.toLowerCase().contains("iconic") || text.toLowerCase().contains("hakani") || text.toLowerCase().contains("hi connie") ||
                    text.toLowerCase().contains("kahani") || text.toLowerCase().contains("connie") || text.toLowerCase().contains("economy")
                    || text.toLowerCase().contains("akon") || text.toLowerCase().contains("koni") || text.toLowerCase().contains("calling") || text.toLowerCase().contains("consider")
                    || text.toLowerCase().contains("conexa") || text.toLowerCase().contains("astrix") || text.toLowerCase().contains("astrix") || text.toLowerCase().contains("gane") || text.toLowerCase().contains("i can't") || text.toLowerCase().contains("recording")||text.toLowerCase().contains("according") ||text.toLowerCase().contains("android") || text.toLowerCase().contains("colony")||text.toLowerCase().contains("tectonic")||text.toLowerCase().contains("hay coin")|| text.toLowerCase().contains("take on Me")|| text.toLowerCase().contains("chicken") ){
                Log.e("textspeech", "conniedetected");
                connieDetected = true;
                if(songisPlaying) {
                    songisPlaying = false;
                    String action = "stop";
                    Intent stopService = new Intent(this, BackgroundSoundService.class);
                    stopService.setAction(action);
                    startService(stopService);
                    result1.success("musicstopped");
                }else
                {
                    try {
                        result1.success("tph");
                    } catch (Exception e){
                        Log.e("MainActivity", e.toString());
                    }
                    return;
                }
//            tts.speak("Yes", TextToSpeech.QUEUE_ADD, map);//hi Karni hakani iconic
            } else {
                if (connieDetected) {

                    connieDetected = false;
                    if (text.toLowerCase().contains("open spotify") || text.toLowerCase().contains("open music")) {
                        boolean installedorNot = appInstalledOrNot("com.spotify.music");
                        if (installedorNot) {
                            spotifyOpned = true;
                            Intent LaunchIntent = getPackageManager()
                                    .getLaunchIntentForPackage("com.spotify.music");
                            startActivity(LaunchIntent);
                        } else {
                            try {
                                spotifyOpned = true;
                                startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=com.spotify.music")));
                            } catch (android.content.ActivityNotFoundException anfe) {
                                startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=" + "com.spotify.music")));
                            }
                        }
                    } else {
                        Log.e("stopsong", text);
                        if (text.toLowerCase().contains("play songs") || text.toLowerCase().contains("play best songs")) {
                            String action = "play";
                            songisPlaying = true;
                            Intent svc = new Intent(this, BackgroundSoundService.class);
                            svc.setAction(action);
                            startService(svc);result1.success("musicisplaying");
                        }
                        else {
                            if(spotifyOpned)
                            {
                                if(text.toLowerCase().contains("go back"))
                                {
                                    spotifyOpned = false;
                                    ActivityManager am = (ActivityManager) getApplicationContext().getSystemService("activity");
                                    Method forceStopPackage = null;
                                    try {
                                        forceStopPackage =am.getClass().getDeclaredMethod("forceStopPackage",String.class);
                                    } catch (NoSuchMethodException e) {
                                        e.printStackTrace();
                                    }
                                    forceStopPackage.setAccessible(true);
                                    try {
                                        forceStopPackage.invoke(am, "com.spotify.music");
                                    } catch (IllegalAccessException e) {
                                        e.printStackTrace();
                                    } catch (InvocationTargetException e) {
                                        e.printStackTrace();
                                    }

//                                   ActivityManager am = (ActivityManager) getSystemService(Activity.ACTIVITY_SERVICE);
//                                   am.killBackgroundProcesses("com.spotify.music");
                                }
                            }else {
                                try {
                                    result1.success(text);
                                } catch (Exception e){
                                    Log.e("MainActivity", e.toString());
                                }
                            }
                        }
                    }
                } else {
                    callTTS();
                }
            }
        }
    }

    @Override
    public void onPartialResults(Bundle partialResults) {

    }

    @Override
    public void onEvent(int eventType, Bundle params) {

    }

    @Override
    public void onUtteranceCompleted(String utteranceId) {
    }

    @Override
    public void success(@Nullable Object result) {

    }

    @Override
    public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {

    }

    @Override
    public void notImplemented() {

    }


    private static class MethodResultWrapper implements MethodChannel.Result {
        private MethodChannel.Result methodResult;
        private Handler handler;

        MethodResultWrapper(MethodChannel.Result result) {
            methodResult = result;
            handler = new Handler(Looper.getMainLooper());
        }

        @Override
        public void success(final Object result) {
            handler.post(
                    new Runnable() {
                        @Override
                        public void run() {
                            methodResult.success(result);
                        }
                    });
        }

        @Override
        public void error(
                final String errorCode, final String errorMessage, final Object errorDetails) {
            handler.post(
                    new Runnable() {
                        @Override
                        public void run() {
                            methodResult.error(errorCode, errorMessage, errorDetails);
                        }
                    });
        }

        @Override
        public void notImplemented() {
            handler.post(
                    new Runnable() {
                        @Override
                        public void run() {
                            methodResult.notImplemented();
                        }
                    });
        }
    }
}
