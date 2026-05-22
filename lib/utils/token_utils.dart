class Token {
  Token._();
  static Map<String, Map<String, int>> tokenMap = {};

  //preceding string is two characters for trigrams, one for digrams
  static void addToToken(String preceding, String following) {
    if (tokenMap.containsKey(preceding)){
      Map<String, int>? innerMap = tokenMap[preceding];
      innerMap!.update(
        following,
            (value) => 1 + value,
        ifAbsent: () => 1,
      );
    } else {
      tokenMap[preceding] = {following: 1};
    }
  }

  static Map<String, Map<String, int>> getTokenMap(){
    return tokenMap;
  }


  static void clearTokenMap(){
    tokenMap = {};
  }

}
