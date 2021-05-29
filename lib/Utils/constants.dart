import 'package:flutter/material.dart';

import 'constantStrings.dart';

const List<String> moodList = ["😭", "😥", "🙂", "😃", "😁"];

const List<Color>  colorPalette = [
    Color(0xffa3a8b8), //darkgrey
    Color(0xffcbcbcb), //grey
    Color(0xfffdefcc), //yellow
    Color(0xffffa194), //red
    Color(0xffadd2ff) //blue
  ];

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