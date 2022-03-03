// DO NOT EDIT. This is code generated via package:gen_lang/generate.dart

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'messages_all.dart';

class S {
 
  static const GeneratedLocalizationsDelegate delegate = GeneratedLocalizationsDelegate();

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }
  
  static Future<S> load(Locale locale) {
    final String name = locale.countryCode == null ? locale.languageCode : locale.toString();

    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new S();
    });
  }
  
  String get hi {
    return Intl.message("Hi", name: 'hi');
  }

  String messageWithParams(yourName) {
    return Intl.message("Hi ${yourName}, Welcome you!", name: 'messageWithParams', args: [yourName]);
  }

  String get iamfine {
    return Intl.message("I am fine", name: 'i_am_fine');
  }

  String get howareyou {
    return Intl.message("How are you", name: 'how_are_you');
  }

  String get howitsgoing {
    return Intl.message("How’s it going", name: 'how_its_going');
  }

  String get howareyoudoing {
    return Intl.message("How are you doing", name: 'how_are_you_doing');
  }

  String get whatsup {
    return Intl.message("What’s up", name: 'whats_up');
  }

  String get areyouarobot {
    return Intl.message("Are you a robot", name: 'are_you_a_robot');
  }

  String get yesiamarobot {
    return Intl.message("Yes I am a robot, but I’m a good one. Let me prove it. How can I help you?", name: 'yes_i_am__a_robot');
  }

  String get areyouahuman {
    return Intl.message("Are you human", name: 'are_you_a_human');
  }

  String get noiamarobot {
    return Intl.message("I am a robot, but I’m a good one. Let me prove it. How can I help you?", name: 'no_i_am_a_robot');
  }

  String get whatisyourname {
    return Intl.message("What is your name", name: 'what_is_your_name');
  }

  String get howoldareyou {
    return Intl.message("How old are you", name: 'how_old_are_you');
  }

  String get whatsyourage {
    return Intl.message("What’s your age", name: 'Whats_your_age');
  }

  String get sorryididntunderstand {
    return Intl.message("sorry I didn’t understand", name: 'sorry_i_didnt_understand');
  }

  String get ididntunderstandadvance {
    return Intl.message("this is me telling you i didn't understand what you just said. I am learning, you see. could you try again?", name: 'i_didnt_understand_advance');
  }


}

class GeneratedLocalizationsDelegate extends LocalizationsDelegate<S> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
			Locale("en", ""),

    ];
  }

  LocaleListResolutionCallback listResolution({Locale fallback}) {
    return (List<Locale> locales, Iterable<Locale> supported) {
      if (locales == null || locales.isEmpty) {
        return fallback ?? supported.first;
      } else {
        return _resolve(locales.first, fallback, supported);
      }
    };
  }

  LocaleResolutionCallback resolution({Locale fallback}) {
    return (Locale locale, Iterable<Locale> supported) {
      return _resolve(locale, fallback, supported);
    };
  }

  Locale _resolve(Locale locale, Locale fallback, Iterable<Locale> supported) {
    if (locale == null || !isSupported(locale)) {
      return fallback ?? supported.first;
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    }
  }

  @override
  Future<S> load(Locale locale) {
    return S.load(locale);
  }

  @override
  bool isSupported(Locale locale) =>
    locale != null && supportedLocales.contains(locale);

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => false;
}

// ignore_for_file: unnecessary_brace_in_string_interps
