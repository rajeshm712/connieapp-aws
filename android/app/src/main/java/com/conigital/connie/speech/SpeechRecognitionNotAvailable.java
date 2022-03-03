package com.conigital.connie.speech;


public class SpeechRecognitionNotAvailable extends Exception {
    public SpeechRecognitionNotAvailable() {
        super("Speech recognition not available");
    }
}
