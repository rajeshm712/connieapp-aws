class QnsAns {
  static String hi = "Hi";
  static String iamfine = "I am fine";
  static String yesiamarobot =
      "Yes I am a robot, but I’m a good one. Let me prove it. How can I help you?";
  static String noiamarobot =
      "I am a robot, but I’m a good one. Let me prove it. How can I help you?";
  static String ididntunderstandadvance =
      "this is me telling you i didn't understand what you just said. I am learning, you see. could you try again?";

  static String response(String text) {
    String respond = "";
    switch (text) {
      case "hi":
      case "hello":
        respond = hi;
        break;
      case "how are you":
      case "how are you doing":
        respond = iamfine;
        break;
      case "are you a robot":
        respond = yesiamarobot;
        break;
      case "are you a human":
        respond = noiamarobot;
        break;
      default:
        respond = ididntunderstandadvance;
    }

    return respond;
  }
}
