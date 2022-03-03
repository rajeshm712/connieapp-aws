package com.conigital.connie.utils;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import java.io.*;
import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.lang.*;
import java.lang.Object;
import java.util.*;
import android.os.Environment;
import android.content.Context;
import android.util.Log;

public class TextFileUtil {

    private String baseDir;

    //#region | Construction |

    public TextFileUtil(Context context) {
        baseDir = context.getFilesDir().toString();
        ensureLogOutputFolders();
    }

    public TextFileUtil(String baseFileDir) {
        baseDir = baseFileDir;
        ensureLogOutputFolders();
    }

    //#region | Construction |

    public void writeLog(String className, String message) {
        Log.d(className, message);
        try {
            File file = getLogFile();
            PrintWriter pw = new PrintWriter(new FileOutputStream(file, file.exists()));
            pw.println(getTimeStamp() + " | " + className + " | " +  message);
            pw.flush();
        } catch (Exception ex) {
            Log.e("TextFileUtil", ex.toString());
        }
    }

    public File getLogDirectory() {
        return new File(baseDir, "logs");
    }

    public String getDateStamp() {
        return DateTime.now().toString(DateTimeFormat.forPattern("yyyy-MM-dd"));
    }

    public String getTimeStamp() {
        return DateTime.now().toString(DateTimeFormat.forPattern("HH:mm:ss.SSS"));
    }

    public File getLogFile(){
        return new File(getLogDirectory(), "Connie-" + getDateStamp() + ".txt");
    }

    //#region | Private Methods |

    private Boolean ensureLogOutputFolders() {
        File logDir = getLogDirectory();
        try {
            if (!logDir.exists()) {
                if (logDir.mkdirs()) {
                    Log.d("TextFileUtil", "Log directory created: " + logDir);
                }
            }
        } catch (Exception e) {
            Log.e(e.toString(), "error creating log directory: " + logDir);
        }
        return true;
    }

    //#endregion | Private Methods |

}