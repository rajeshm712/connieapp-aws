package com.conigital.connie;

import android.annotation.TargetApi;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;

import androidx.core.app.NotificationCompat;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.ProcessLifecycleOwner;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.twilio.voice.CallInvite;

public class IncomingCallNotificationServiceNew extends Service {
    private static final String TAG = IncomingCallNotificationServiceNew.class.getSimpleName();

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        String action = intent.getAction();

        if (action != null) {
            CallInvite callInvite = intent.getParcelableExtra(Constants.INCOMING_CALL_INVITE);
            int notificationId = intent.getIntExtra(Constants.INCOMING_CALL_NOTIFICATION_ID, 0);
            Log.e("notificationId    ",notificationId+"");

            Log.e("ServiceStarted"," "+ action.toString());

            switch (action) {
                case Constants.ACTION_INCOMING_CALL:
                    handleIncomingCall(callInvite, notificationId);
                    break;
                case Constants.ACTION_ACCEPT:
                    accept(callInvite, notificationId);
                    break;
                case Constants.ACTION_REJECT:
                    reject(callInvite);
                    break;
                case Constants.ACTION_CANCEL_CALL:
                    handleCancelledCall(intent);
                    break;
                case Constants.FOREGROUND_NOTIFICATION:
                    handleNotification(intent);
                    break;

                case Constants.ACTION_DISCONNECTED:
                    handleCancelledCall(intent);
                    break;
                default:
                    break;
            }
        }
        return START_NOT_STICKY;
    }

    private void handleNotification(Intent intent){
        Intent localIntentAccept = new Intent();
        localIntentAccept.setAction(Constants.FOREGROUND_NOTIFICATION);
        localIntentAccept.putExtra("title",intent.getStringExtra("title"));
        localIntentAccept.putExtra("body",intent.getStringExtra("body"));
        LocalBroadcastManager.getInstance(this).sendBroadcast(localIntentAccept);
    }
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private Notification createNotification(CallInvite callInvite, int notificationId, int channelImportance) {
        Intent intent = new Intent(this, MainActivity.class);
        intent.setAction(Constants.ACTION_INCOMING_CALL_NOTIFICATION);
        intent.putExtra(Constants.INCOMING_CALL_NOTIFICATION_ID, notificationId);
        intent.putExtra(Constants.INCOMING_CALL_INVITE, callInvite);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        PendingIntent pendingIntent =
                PendingIntent.getActivity(this, notificationId, intent, PendingIntent.FLAG_UPDATE_CURRENT);
        /*
         * Pass the notification id and call sid to use as an identifier to cancel the
         * notification later
         */
        Bundle extras = new Bundle();
        extras.putString(Constants.CALL_SID_KEY, callInvite.getCallSid());

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            return buildNotification(callInvite.getFrom() + " is calling.",
                    pendingIntent,
                    extras,
                    callInvite,
                    notificationId,
                    createChannel(channelImportance));
        } else {
            //noinspection deprecation
            return new NotificationCompat.Builder(this)
                    .setSmallIcon(R.drawable.navigation_empty_icon)
                    .setContentTitle("Bob")
                    .setContentText(callInvite.getFrom() + " is calling.")
                    .setAutoCancel(true)
                    .setExtras(extras)
                    .setContentIntent(pendingIntent)
                    .setGroup("test_app_notification")
                    .setColor(Color.rgb(214, 10, 37)).build();
        }
    }

    /**
     * Build a notification.
     *
     * @param text          the text of the notification
     * @param pendingIntent the body, pending intent for the notification
     * @param extras        extras passed with the notification
     * @return the builder
     */
    @TargetApi(Build.VERSION_CODES.O)
    private Notification buildNotification(String text, PendingIntent pendingIntent, Bundle extras,
                                           final CallInvite callInvite,
                                           int notificationId,
                                           String channelId) {
        Intent rejectIntent = new Intent(getApplicationContext(), IncomingCallNotificationServiceNew.class);
        rejectIntent.setAction(Constants.ACTION_REJECT);
        rejectIntent.putExtra(Constants.INCOMING_CALL_INVITE, callInvite);
        rejectIntent.putExtra(Constants.INCOMING_CALL_NOTIFICATION_ID, notificationId);
        PendingIntent piRejectIntent = PendingIntent.getService(getApplicationContext(), 0, rejectIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        Intent acceptIntent = new Intent(getApplicationContext(), IncomingCallNotificationServiceNew.class);
        acceptIntent.setAction(Constants.ACTION_ACCEPT);
        acceptIntent.putExtra(Constants.INCOMING_CALL_INVITE, callInvite);
        acceptIntent.putExtra(Constants.INCOMING_CALL_NOTIFICATION_ID, notificationId);
        PendingIntent piAcceptIntent = PendingIntent.getService(getApplicationContext(), 0, acceptIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        Notification.Builder builder =
                new Notification.Builder(getApplicationContext(), channelId)
                        .setSmallIcon(R.drawable.navigation_empty_icon)
                        .setContentTitle("Bob")
                        .setContentText(text)
                        .setCategory(Notification.CATEGORY_CALL)
                        .setExtras(extras)
                        .setAutoCancel(true)
                        .addAction(android.R.drawable.ic_menu_delete, "Decline", piRejectIntent)
                        .addAction(android.R.drawable.ic_menu_call, "Answer", piAcceptIntent)
                        .setFullScreenIntent(pendingIntent, true);

        return builder.build();
    }

    @TargetApi(Build.VERSION_CODES.O)
    private String createChannel(int channelImportance) {
        NotificationChannel callInviteChannel = new NotificationChannel(Constants.VOICE_CHANNEL_HIGH_IMPORTANCE,
                "Primary Voice Channel", NotificationManager.IMPORTANCE_HIGH);
        String channelId = Constants.VOICE_CHANNEL_HIGH_IMPORTANCE;

        if (channelImportance == NotificationManager.IMPORTANCE_LOW) {
            callInviteChannel = new NotificationChannel(Constants.VOICE_CHANNEL_LOW_IMPORTANCE,
                    "Primary Voice Channel", NotificationManager.IMPORTANCE_LOW);
            channelId = Constants.VOICE_CHANNEL_LOW_IMPORTANCE;
        }
        callInviteChannel.setLightColor(Color.GREEN);
        callInviteChannel.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.createNotificationChannel(callInviteChannel);

        return channelId;
    }

    private void accept(CallInvite callInvite, int notificationId) {
        Log.e("ServiceStarted","Accepeted   "+ callInvite.getFrom());

        endForeground();
//        Intent activeCallIntent = new Intent(this, MainActivity.class);
//        activeCallIntent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
//        activeCallIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//        activeCallIntent.putExtra(Constants.INCOMING_CALL_INVITE, callInvite);
//        activeCallIntent.putExtra(Constants.INCOMING_CALL_NOTIFICATION_ID, notificationId);
//        activeCallIntent.setAction(Constants.ACTION_ACCEPT);
//        startActivity(activeCallIntent);



// register broadcast

//
//        IntentFilter filter = new IntentFilter(Constants.ACTION_ACCEPT);
//        LocalBroadcastManager.getInstance(this).registerReceiver(mReceiver, filter);

        Intent localIntentAccept = new Intent();
        localIntentAccept.setAction(Constants.ACTION_ACCEPT);
        localIntentAccept.putExtra(Constants.INCOMING_CALL_NOTIFICATION_ID, notificationId);
        localIntentAccept.putExtra(Constants.INCOMING_CALL_INVITE, callInvite);
        LocalBroadcastManager.getInstance(this).sendBroadcast(localIntentAccept);


        Log.e("ServiceStarted","Accepeted  and Sent  "+ callInvite.getFrom());


    }

    private void reject(CallInvite callInvite) {
        endForeground();
        callInvite.reject(getApplicationContext());
    }

    private void handleCancelledCall(Intent intent) {
        endForeground();
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
    }

    private void handleIncomingCall(CallInvite callInvite, int notificationId) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Log.e("ServiceStarted"," "+ Build.VERSION.SDK_INT);

            setCallInProgressNotification(callInvite, notificationId);
        }
        sendCallInviteToActivity(callInvite, notificationId);
    }

    private void endForeground() {
        stopForeground(true);
    }

    @TargetApi(Build.VERSION_CODES.O)
    private void setCallInProgressNotification(CallInvite callInvite, int notificationId) {
        if (isAppVisible()) {
            Log.i(TAG, "setCallInProgressNotification - app is visible.");
            Log.e("CreateForegrounf", "setCallInProgressNotification - app is visible.");

            startForeground(notificationId, createNotification(callInvite, notificationId, NotificationManager.IMPORTANCE_LOW));
        } else {
            Log.i(TAG, "setCallInProgressNotification - app is NOT visible.");
            startForeground(notificationId, createNotification(callInvite, notificationId, NotificationManager.IMPORTANCE_HIGH));
        }
    }

    /*
     * Send the CallInvite to the VoiceActivity. Start the activity if it is not running already.
     */
    private void sendCallInviteToActivity(CallInvite callInvite, int notificationId) {
        Log.e("ServiceStarted"," "+ callInvite.getFrom());

        if (Build.VERSION.SDK_INT >= 29 && !isAppVisible()) {
            return;
        }
        LocalBroadcastManager localBroadcastManager = LocalBroadcastManager.getInstance(getApplicationContext());
        Intent localIntent = new Intent();
        localIntent.setAction(Constants.ACTION_INCOMING_CALL);
        localIntent.putExtra(Constants.INCOMING_CALL_NOTIFICATION_ID, notificationId);
        localIntent.putExtra(Constants.INCOMING_CALL_INVITE, callInvite);
        localBroadcastManager.sendBroadcast(localIntent);
    }

    private boolean isAppVisible() {
        return ProcessLifecycleOwner
                .get()
                .getLifecycle()
                .getCurrentState()
                .isAtLeast(Lifecycle.State.STARTED);
    }
}
