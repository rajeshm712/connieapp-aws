package com.conigital.connie;

import android.Manifest.permission;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.IBinder;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;


import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.conigital.connie.speech.Speech;
import com.conigital.connie.speech.SpeechDelegate;
import com.conigital.connie.utils.TextFileUtil;

import java.util.List;
import java.util.Objects;
import java.util.Random;

public class MyService extends Service implements SpeechDelegate, Speech.stopDueToDelay {

  public static SpeechDelegate delegate;


  @Override
  public int onStartCommand(Intent intent, int flags, int startId) {
    TextFileUtil logger = new TextFileUtil(getApplicationContext());
    logger.writeLog("MyService", "OnStart");

    try {
      if (VERSION.SDK_INT >= VERSION_CODES.KITKAT) {
        ((AudioManager) Objects.requireNonNull(
          getSystemService(Context.AUDIO_SERVICE))).setStreamMute(AudioManager.STREAM_SYSTEM, true);
      }
    } catch (Exception e) {
      Log.e("ResultService", "catchhh"+"");
      e.printStackTrace();
    }

    Speech.init(this);
    delegate = this;
    Speech.getInstance().setListener(this);

    if (Speech.getInstance().isListening()) {
      Log.e("MyService", "StartListening123"+"");

      Speech.getInstance().stopListening();
//      muteBeepSoundOfRecorder();
    } else {
      System.setProperty("rx.unsafe-disable", "True");
//      RxPermissions.getInstance(this).request(permission.RECORD_AUDIO).subscribe(granted -> {
//        if (granted) { // Always true pre-M
          try {
           Speech.getInstance().stopTextToSpeech();
           Speech.getInstance().startListening(null, this);
            Log.e("ResultService", "StartListening"+"");

          } catch (Exception exc) {

            Log.e("ResultService", "StartListeningCatching"+"");

            //showSpeechNotSupportedDialog();
          }

//          } catch (GoogleVoiceTypingDisabledException exc) {
//            //showEnableGoogleVoiceTyping();
//          }
//        } else {
//          Toast.makeText(this, R.string.permission_required, Toast.LENGTH_LONG).show();
//        }
////      });
//      muteBeepSoundOfRecorder();
    }
    return Service.START_STICKY;
  }


  @Override
  public IBinder onBind(Intent intent) { 
    //TODO for communication return IBinder implementation
    return null;
  }

  @Override
  public void onStartOfSpeech() {
  }

  @Override
  public void onSpeechRmsChanged(float value) {

  }

  @Override
  public void onSpeechPartialResults(List<String> results) {
    String partialresut = "";
    for (String partial : results) {
      Log.d("ResultServiceCheck", "Partials"+partial+"");
      partialresut = partial;
    }
  }

  @Override
  public void onSpeechResult(String result) {

    Log.d("ResultServiceCheck", "onSpeechResult"+result+"");

    if (!TextUtils.isEmpty(result)) {
      Intent localIntentAccept = new Intent();
      localIntentAccept.setAction(Constants.SPEECH_RESULT);
      localIntentAccept.putExtra(Constants.SPEECH_RESULT_VALUE,result);
      LocalBroadcastManager.getInstance(this).sendBroadcast(localIntentAccept);
    }
  }

  @Override
  public void onSpecifiedCommandPronounced(String event) {
    try {
      if (VERSION.SDK_INT >= VERSION_CODES.KITKAT) {
        ((AudioManager) Objects.requireNonNull(
                getSystemService(Context.AUDIO_SERVICE))).setStreamMute(AudioManager.STREAM_SYSTEM, true);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    if (Speech.getInstance().isListening()) {
//      muteBeepSoundOfRecorder();
      Speech.getInstance().stopListening();
    } else {
//      RxPermissions.getInstance(this).request(permission.RECORD_AUDIO).subscribe(granted -> {
//        if (granted) { // Always true pre-M
      try {
        Speech.getInstance().stopTextToSpeech();
        Speech.getInstance().startListening(null, this);
      } catch (Exception exc) {
        //showSpeechNotSupportedDialog();
      }
    }
  }

  /**
   * Function to remove the beep sound of voice recognizer.
   */
  private void muteBeepSoundOfRecorder() {
    AudioManager amanager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
    if (amanager != null) {
      amanager.setStreamMute(AudioManager.STREAM_NOTIFICATION, true);
      amanager.setStreamMute(AudioManager.STREAM_ALARM, true);
      amanager.setStreamMute(AudioManager.STREAM_MUSIC, true);
      amanager.setStreamMute(AudioManager.STREAM_RING, true);
      amanager.setStreamMute(AudioManager.STREAM_SYSTEM, true);
    }
  }

  @Override
  public void onTaskRemoved(Intent rootIntent) {
    //Restarting the service if it is removed.
    PendingIntent service =
      PendingIntent.getService(getApplicationContext(), new Random().nextInt(),
        new Intent(getApplicationContext(), MyService.class), PendingIntent.FLAG_ONE_SHOT);

    AlarmManager alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
    assert alarmManager != null;
    alarmManager.set(AlarmManager.ELAPSED_REALTIME_WAKEUP, 1000, service);
    super.onTaskRemoved(rootIntent);
  }
}