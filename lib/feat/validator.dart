const String errorValidateWordShortMsg = "too short";
const String errorValidateWordLongMsg = "too long";

String? validateWord(String? value, int length) {
  if (value != null && value.length > length) {
    return errorValidateWordLongMsg;
  } else if (value != null && value.length < length) {
    return errorValidateWordShortMsg;
  }
  return null;
}
