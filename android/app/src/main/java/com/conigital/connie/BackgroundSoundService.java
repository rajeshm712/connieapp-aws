package com.conigital.connie;

import android.app.Notification;
import android.app.Service;
import android.content.Intent;
import android.media.MediaPlayer;
import android.os.IBinder;
import android.util.Log;

public class BackgroundSoundService extends Service {
    private static final String TAG = null;
    MediaPlayer player;
    public IBinder onBind(Intent arg0) {

        return null;
    }
    @Override
    public void onCreate() {
        super.onCreate();
        intializePlayer();
    }

    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.e("serviceStarted",intent.getAction());
        if (intent.getAction().toLowerCase().equalsIgnoreCase("play")) {
            player.start();// resume the sound
        }
        if (intent.getAction().toLowerCase().equalsIgnoreCase("stop")) {
            player.stop();
            stopService(intent);// pause the sound
        }
        return START_STICKY;
    }

    public void intializePlayer()
    {
        player = MediaPlayer.create(this, R.raw.awone);
        player.setLooping(false); // Set looping
        player.setVolume(20,20);
    }
    public void onStart(Intent intent, int startId) {
        // TO DO
    }
    public IBinder onUnBind(Intent arg0) {
        // TO DO Auto-generated method
        return null;
    }

    public void onStop() {

    }
    public void onPause() {

    }
    @Override
    public void onDestroy() {
        player.stop();
        player.release();
    }

    @Override
    public void onLowMemory() {

    }
}
