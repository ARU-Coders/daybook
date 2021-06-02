import 'package:flutter/material.dart';
import 'constantStrings.dart';

enum Screens{
  JOURNEYS,
  ENTRIES,
  HABITS,
  TASKS,
  PDFS,
  IMAGES
}

const DARK_GREY = Color(0xffa3a8b8);  //darkgrey
const GREY  = Color(0xffcbcbcb);      //grey
const YELLOW  = Color(0xfffdefcc);    //yellow
const RED = Color(0xffffa194);        //red
const BLUE = Color(0xffadd2ff);       //blue
const PINK = Color(0xDAFFD1DC);       //pink
Color LIGHT_PINK = Colors.pink[200];  //lightpink
const LIGHT_GREEN = Color(0xFF90EE90);//lightgreen

const List<String> moodList = ["😭", "😥", "🙂", "😃", "😁"];

const List<Color>  colorPalette = [DARK_GREY, GREY, YELLOW, RED, BLUE];
final List<Color>  habitsColorPalette = [BLUE, LIGHT_GREEN, YELLOW, RED, LIGHT_PINK, GREY];

final Map<Color, String> habitsColorToStringMap = {
  BLUE:         "BLUE", 
  LIGHT_GREEN:  "LIGHT_GREEN", 
  YELLOW:       "YELLOW", 
  RED:          "RED", 
  LIGHT_PINK:   "LIGHT_PINK", 
  GREY:         "GREY"
}; 

final Map<String, Color> habitsStringToColorMap = {
  "BLUE":         BLUE, 
  "LIGHT_GREEN":  LIGHT_GREEN, 
  "YELLOW":       YELLOW, 
  "RED":          RED, 
  "LIGHT_PINK":   LIGHT_PINK, 
  "GREY":         GREY
}; 

final Map<String, Color> colorMoodMap = {
    "Terrible": Color(0xffa3a8b8), //darkgrey
    "Bad": Color(0xffcbcbcb), //grey
    "Neutral": Color(0xfffdefcc), //yellow
    "Good": Color(0xffffa194), //red
    "Wonderful": Color(0xffadd2ff) //blue
  };

const Map<String, String> authExceptionMessageMap = {
  "invalid-email": INVALID_EMAIL_ID,
  "user-disabled": USER_DISABLED,
  "user-not-found": USER_NOT_FOUND,
  "wrong-password": WRONG_PASSWORD
};

const Map<String, String> googleAuthExceptionMessageMap = {
  "account-exists-with-different-credential": ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL,
  "invalid-credential": INVALID_CREDENTIAL,
  "operation-not-allowed": OPERATION_NOT_ALLOWED,
  "invalid-verification-id": INVALID_VERIFICATION_ID,
  "invalid-verification-code": INVALID_VERIFICATION_CODE,
  "invalid-email": INVALID_EMAIL_ID,
  "user-disabled": USER_DISABLED,
  "user-not-found": USER_NOT_FOUND,
  "wrong-password": WRONG_PASSWORD
};

const Map<String, String> emailRegistrationExceptionMessageMap = {
  "email-already-in-use": EMAIL_ALREADY_IN_USE,
  "invalid-email":INVALID_EMAIL_ID,
  "operation-not-allowed": OPERATION_NOT_ALLOWED,
  "weak-password": WEAK_PASSWORD
};

final Map<String, String> moodText = {
    "Terrible": "Terrible 😭",
    "Bad": "Bad 😥",
    "Neutral": "Neutral 🙂",
    "Good": "Good 😃",
    "Wonderful": "Wonderful 😁"
  };

final Map<String, String> moodMap = {
  "😭": "Terrible",
  "😥": "Bad",
  "🙂": "Neutral",
  "😃": "Good",
  "😁": "Wonderful"
};

const EMAIL_REGEX = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";

//Asset Paths
const NO_ENTRY_IMAGE    = "assets/images/No-Entry.png";
const NO_TASK_IMAGE     = "assets/images/No-Tasks.png";
const NO_HABIT_IMAGE    = "assets/images/No-Habits.png";
const NO_JOURNEY_IMAGE  = "assets/images/No-Journey.png";
const NO_IMAGES_IMAGE   = "assets/images/No-Entry.png";
const NO_PDFS_IMAGE     = "assets/images/No-Entry.png";
const ENTRY_PLACEHOLDER     = "assets/images/Entry-Placeholder.png";

//Lottie File Paths
const ENTRY_LOTTIE_FILE = "assets/lottieFiles/entries.json";
const HABIT_LOTTIE_FILE = "assets/lottieFiles/habits.json";
const TASK_LOTTIE_FILE  = "assets/lottieFiles/tasks.json";
const STATS_LOTTIE_FILE = "assets/lottieFiles/stats.json";

const Map<Screens, String> noDataImageMap = {
  Screens.ENTRIES:  NO_ENTRY_IMAGE,
  Screens.TASKS:    NO_TASK_IMAGE,
  Screens.HABITS:   NO_HABIT_IMAGE,
  Screens.JOURNEYS: NO_JOURNEY_IMAGE,
  Screens.IMAGES:   NO_IMAGES_IMAGE,
  Screens.PDFS:     NO_PDFS_IMAGE,
}; 

const Map<Screens, String> noDataMessagesMap = {
  Screens.ENTRIES:  NO_ENTRY_MESSAGE,
  Screens.TASKS:    NO_TASK_MESSAGE,
  Screens.HABITS:   NO_HABIT_MESSAGE,
  Screens.JOURNEYS: NO_JOURNEY_MESSAGE,
  Screens.IMAGES:   NO_IMAGES_MESSAGE,
  Screens.PDFS:     NO_PDFS_MESSAGE,
};