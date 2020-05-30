mixin Functionality {

  bool isValidString(String value) {
    if (value == null || value.isEmpty || value == "null") {
      return false;
    }
    return true;
  }

  bool isValidObject(Object value) {
    if (value == null) {
      return false;
    }
    return true;
  }

  bool isValidList(List value) {
    if (value == null || value.isEmpty || value.length <= 0) {
      return false;
    }
    return true;
  }
}
