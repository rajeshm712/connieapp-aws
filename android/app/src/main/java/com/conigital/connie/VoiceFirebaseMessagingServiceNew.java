package com.conigital.connie;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import com.twilio.voice.CallException;
import com.twilio.voice.CallInvite;
import com.twilio.voice.CancelledCallInvite;
import com.twilio.voice.MessageListener;
import com.twilio.voice.Voice;

public class VoiceFirebaseMessagingServiceNew extends FirebaseMessagingService {
    private static final String TAG = "VoiceFCMService";

    @Override
    public void onCreate() {
        super.onCreate();
    }

    /**
     * Called when message is received.
     *
     * @param remoteMessage Object representing the message received from Firebase Cloud Messaging.
     */


    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        Log.d(TAG, "FireNotif Received onMessageReceived()");
        Log.d(TAG, "FireNotif Bundle data: " + remoteMessage.getData());
        Log.d(TAG, "FireNotif Bundle data: " + remoteMessage.getNotification().getTitle());
        Log.d(TAG, "FireNotif Bundle data: " + remoteMessage.getNotification().getBody());

        if(remoteMessage.getNotification()!=null){
            Intent localIntentAccept = new Intent();
            localIntentAccept.setAction(Constants.FOREGROUND_NOTIFICATION);
            localIntentAccept.putExtra("title",remoteMessage.getNotification().getTitle());
            localIntentAccept.putExtra("body",remoteMessage.getNotification().getBody());
            LocalBroadcastManager.getInstance(this).sendBroadcast(localIntentAccept);
        }

//        Log.d(TAG, "From: " + remoteMessage.getFrom());
//        Log.e(TAG, "onCallInviteincommingCall" + remoteMessage.getData());





        // Check if message contains a data payload.
        if (remoteMessage.getData().size() > 0) {
            boolean valid = Voice.handleMessage(this, remoteMessage.getData(), new MessageListener() {
                @Override
                public void onCallInvite(@NonNull CallInvite callInvite) {
                    Log.d(TAG, "onCallInvite      incommingCall" + callInvite);
                    Log.e(TAG, "onCallInviteincommingCall" + callInvite.getTo());
                    final int notificationId = (int) System.currentTimeMillis();
                    handleInvite(callInvite, notificationId);
                }

                @Override
                public void onCancelledCallInvite(@NonNull CancelledCallInvite cancelledCallInvite, @Nullable CallException callException) {
                    Log.d(TAG, "onCallInvite      callCancelled" + cancelledCallInvite);

                    handleCanceledCallInvite(cancelledCallInvite);
                }
            });

            if (!valid) {
                Log.e(TAG, "The message was not a valid Twilio Voice SDK payload: " +
                        remoteMessage.getData());
            }
        }
    }

    private void sendNotification(String messageTitle,String messageBody) {
        Intent intent = new Intent(this, MainActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        PendingIntent pendingIntent = PendingIntent.getActivity(this,0 /* request code */, intent,PendingIntent.FLAG_UPDATE_CURRENT);

        long[] pattern = {500,500,500,500,500};

        Uri defaultSoundUri= RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);

        NotificationCompat.Builder notificationBuilder = (NotificationCompat.Builder) new NotificationCompat.Builder(this)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(messageTitle)
                .setContentText(messageBody)
                .setAutoCancel(true)
                .setVibrate(pattern)
                .setLights(Color.BLUE,1,1)
                .setSound(defaultSoundUri)
                .setContentIntent(pendingIntent);

        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.notify(0 /* ID of notification */, notificationBuilder.build());
    }

    @Override
    public void onNewToken(String token) {
        super.onNewToken(token);
        Intent intent = new Intent(Constants.ACTION_FCM_TOKEN);
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
    }

    private void handleNotification(RemoteMessage.Notification notification){
        Log.e("Connietest","notification");
        Intent intent = new Intent(this, IncomingCallNotificationServiceNew.class);
        intent.setAction(Constants.FOREGROUND_NOTIFICATION);
        intent.putExtra("title",notification.getTitle());
        intent.putExtra("body",notification.getBody());

        startService(intent);
    }

    private void handleInvite(CallInvite callInvite, int notificationId) {
        Log.d(TAG, "onCallInviteHandle" + callInvite);

        Intent intent = new Intent(this, IncomingCallNotificationServiceNew.class);
        intent.setAction(Constants.ACTION_INCOMING_CALL);
        intent.putExtra(Constants.INCOMING_CALL_NOTIFICATION_ID, notificationId);
        intent.putExtra(Constants.INCOMING_CALL_INVITE, callInvite);
        startService(intent);
    }

    private void handleCanceledCallInvite(CancelledCallInvite cancelledCallInvite) {
        Intent intent = new Intent(this, IncomingCallNotificationServiceNew.class);
        intent.setAction(Constants.ACTION_CANCEL_CALL);
        intent.putExtra(Constants.CANCELLED_CALL_INVITE, cancelledCallInvite);

        startService(intent);
    }
}