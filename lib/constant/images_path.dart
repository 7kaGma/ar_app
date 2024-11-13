class DataArray {
  Map<String, dynamic> attraction = {
    "ハリー・ポッター・アンド・ザ・フォービドゥン・ジャーニー": {"path": "hp_bg.jpg", "scene": "1"},
    "ジュラシックパーク・ザ・ライド": {"path": "jurassic_bg.jpg", "scene": "2"},
    "ジョーズ": {"path": "jaws_bg.jpg", "scene": "3"},
    "default": {"path": "default_bg.jpg", "scene": "4"},
  };

  String getBgPath(String value) {
    return attraction.containsKey(value)
        ? attraction[value]["path"]
        : attraction["default"]["path"];
  }

  String getScene(String value) {
    return attraction.containsKey(value)
        ? attraction[value]["scene"]
        : attraction["default"]["scene"];
  }
}
