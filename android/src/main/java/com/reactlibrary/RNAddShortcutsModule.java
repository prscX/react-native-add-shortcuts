
package com.reactlibrary;

import android.annotation.TargetApi;
import android.content.Intent;
import android.content.pm.ShortcutInfo;
import android.content.pm.ShortcutManager;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.Icon;
import android.net.Uri;
import android.os.Build;
import android.os.StrictMode;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.views.text.ReactFontManager;

import java.util.ArrayList;
import java.util.List;

public class RNAddShortcutsModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public RNAddShortcutsModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNAddShortcuts";
  }


  @ReactMethod
  @TargetApi(25)
  private void AddDynamicShortcut(ReadableMap shortcut) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

      ShortcutManager mShortcutManager = getReactApplicationContext().getSystemService(ShortcutManager.class);

        String name = shortcut.getString("name");
        ReadableMap icon = shortcut.getMap("icon");
        String link = shortcut.getString("link");

        BitmapDrawable drawable = (BitmapDrawable) generateVectorIcon(icon);

        Intent shortcutIntent = new Intent(getReactApplicationContext(), RNAddShortcutsModule.class);
        shortcutIntent.setAction(Intent.ACTION_MAIN);
        Intent intent = new Intent();
        intent.setAction(Intent.ACTION_VIEW);
        intent.setData(Uri.parse(link));

        ShortcutInfo shortcutInfo = new ShortcutInfo.Builder(getReactApplicationContext(), name)
                .setShortLabel(name)
                .setLongLabel(name)
                .setIntent(intent)
                .setIcon(Icon.createWithBitmap(drawable.getBitmap()))
                .build();

      List<ShortcutInfo> list = new ArrayList<>();
        list.add(shortcutInfo);

      if (mShortcutManager != null) {
        mShortcutManager.setDynamicShortcuts(list);
      }
    }
  }


  @ReactMethod
  @TargetApi(25)
  private void AddPinnedShortcut(ReadableMap shortcut) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      String name = shortcut.getString("name");
      ReadableMap icon = shortcut.getMap("icon");
      String link = shortcut.getString("link");

      BitmapDrawable drawable = (BitmapDrawable) generateVectorIcon(icon);

      ShortcutManager mShortcutManager = getReactApplicationContext().getSystemService(ShortcutManager.class);

      Intent shortcutIntent = new Intent(getReactApplicationContext(), RNAddShortcutsModule.class);
      shortcutIntent.setAction(Intent.ACTION_MAIN);
      Intent intent = new Intent();
      intent.setAction(Intent.ACTION_VIEW);
      intent.setData(Uri.parse(link));

      ShortcutInfo shortcutInfo = new ShortcutInfo.Builder(getReactApplicationContext(), name)
              .setShortLabel(name)
              .setLongLabel(name)
              .setIntent(intent)
              .setIcon(Icon.createWithBitmap(drawable.getBitmap()))
              .build();

      if (mShortcutManager != null) {
        mShortcutManager.requestPinShortcut(shortcutInfo, null);
      }
    }
  }


  @TargetApi(21)
  private Drawable generateVectorIcon(ReadableMap icon) {
    try {
      StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
      StrictMode.setThreadPolicy(policy);

      String family = icon.getString("family");
      String name = icon.getString("name");
      String glyph = icon.getString("glyph");
      String color = icon.getString("color");
      int size = icon.getInt("size");

      if (name != null && name.length() > 0 && name.contains(".")) {
        Resources resources = getReactApplicationContext().getResources();
        name = name.substring(0, name.lastIndexOf("."));

        final int resourceId = resources.getIdentifier(name, "drawable", getReactApplicationContext().getPackageName());
        return getReactApplicationContext().getDrawable(resourceId);
      }

      float scale = getReactApplicationContext().getResources().getDisplayMetrics().density;
      String scaleSuffix = "@" + (scale == (int) scale ? Integer.toString((int) scale) : Float.toString(scale)) + "x";
      int fontSize = Math.round(size * scale);

      Typeface typeface = ReactFontManager.getInstance().getTypeface(family, 0, getReactApplicationContext().getAssets());
      Paint paint = new Paint();
      paint.setTypeface(typeface);

      if (color != null && color.length() == 4) {
        color = color + color.substring(1);
      }

      if (color != null && color.length() > 0) {
        paint.setColor(Color.parseColor(color));
      }

      paint.setTextSize(fontSize);
      paint.setAntiAlias(true);
      Rect textBounds = new Rect();
      paint.getTextBounds(glyph, 0, glyph.length(), textBounds);

      Bitmap bitmap = Bitmap.createBitmap(textBounds.width(), textBounds.height(), Bitmap.Config.ARGB_8888);
      Canvas canvas = new Canvas(bitmap);
      canvas.drawText(glyph, -textBounds.left, -textBounds.top, paint);

      return new BitmapDrawable(getReactApplicationContext().getResources(), bitmap);
    } catch (Exception exception) {
      return null;
    }
  }
}