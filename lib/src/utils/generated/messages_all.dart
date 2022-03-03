// DO NOT EDIT. This is code generated via package:gen_lang/generate.dart

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
// ignore: implementation_imports
import 'package:intl/src/intl_helpers.dart';

final _$en = $en();

class $en extends MessageLookupByLibrary {
  get localeName => 'en';
  
  final messages = {
		"hi" : MessageLookupByLibrary.simpleMessage("Hi"),
		"messageWithParams" : (yourName) => "Hi ${yourName}, Welcome you!",
		"i_am_fine" : MessageLookupByLibrary.simpleMessage("I am fine"),
		"how_are_you" : MessageLookupByLibrary.simpleMessage("How are you"),
		"how_its_going" : MessageLookupByLibrary.simpleMessage("How’s it going"),
		"how_are_you_doing" : MessageLookupByLibrary.simpleMessage("How are you doing"),
		"whats_up" : MessageLookupByLibrary.simpleMessage("What’s up"),
		"are_you_a_robot" : MessageLookupByLibrary.simpleMessage("Are you a robot"),
		"yes_i_am__a_robot" : MessageLookupByLibrary.simpleMessage("Yes I am a robot, but I’m a good one. Let me prove it. How can I help you?"),
		"are_you_a_human" : MessageLookupByLibrary.simpleMessage("Are you human"),
		"no_i_am_a_robot" : MessageLookupByLibrary.simpleMessage("I am a robot, but I’m a good one. Let me prove it. How can I help you?"),
		"what_is_your_name" : MessageLookupByLibrary.simpleMessage("What is your name"),
		"how_old_are_you" : MessageLookupByLibrary.simpleMessage("How old are you"),
		"Whats_your_age" : MessageLookupByLibrary.simpleMessage("What’s your age"),
		"sorry_i_didnt_understand" : MessageLookupByLibrary.simpleMessage("sorry I didn’t understand"),
		"i_didnt_understand_advance" : MessageLookupByLibrary.simpleMessage("this is me telling you i didn't understand what you just said. I am learning, you see. could you try again?"),

  };
}



typedef Future<dynamic> LibraryLoader();
Map<String, LibraryLoader> _deferredLibraries = {
	"en": () => Future.value(null),

};

MessageLookupByLibrary _findExact(localeName) {
  switch (localeName) {
    case "en":
        return _$en;

    default:
      return null;
  }
}

/// User programs should call this before using [localeName] for messages.
Future<bool> initializeMessages(String localeName) async {
  var availableLocale = Intl.verifiedLocale(
      localeName,
          (locale) => _deferredLibraries[locale] != null,
      onFailure: (_) => null);
  if (availableLocale == null) {
    return Future.value(false);
  }
  var lib = _deferredLibraries[availableLocale];
  await (lib == null ? Future.value(false) : lib());

  initializeInternalMessageLookup(() => CompositeMessageLookup());
  messageLookup.addLocale(availableLocale, _findGeneratedMessagesFor);

  return Future.value(true);
}

bool _messagesExistFor(String locale) {
  try {
    return _findExact(locale) != null;
  } catch (e) {
    return false;
  }
}

MessageLookupByLibrary _findGeneratedMessagesFor(locale) {
  var actualLocale = Intl.verifiedLocale(locale, _messagesExistFor,
      onFailure: (_) => null);
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}

// ignore_for_file: unnecessary_brace_in_string_interps
