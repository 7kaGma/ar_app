class ImagesPath{
  //待ち時間計測画面で用いる画像のパス
  Map <String,String> bgPath = {
    "ハリー・ポッター・アンド・ザ・フォービドゥン・ジャーニー":"hp_bg.jpg",
    "ジョーズ":"jaws_bg.jpg",
    "ジュラシックパーク・ザ・ライド":"jurassic_bg.jpg",
    "default":"default_bg.jpg"
  };

    String getBgPath(String value) {
    return bgPath.containsKey(value) ? bgPath[value]! : bgPath["default"]!;
  }
}