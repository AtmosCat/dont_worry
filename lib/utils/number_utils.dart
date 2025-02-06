class NumberUtils {
  /// 숫자를 3자리마다 콤마(,)가 있는 문자열로 변환
  static String formatWithCommas(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }
}