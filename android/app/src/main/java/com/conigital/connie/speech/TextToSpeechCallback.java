package com.conigital.connie.speech;

public interface TextToSpeechCallback {
    void onStart();
    void onCompleted();
    void onError();
}
