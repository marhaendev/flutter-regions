extension StringExtension on String {
  String get toProperCase {
    return this.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
      return word;
    }).join(' ');
  }

  String removeWord(String word) {
    final pattern = RegExp(r'\b' + RegExp.escape(word) + r'\b');
    return this.replaceAll(pattern, '').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String removeWords(List<String> words) {
    String result = this;
    for (var word in words) {
      final pattern = RegExp(r'\b' + RegExp.escape(word) + r'\b');
      result = result.replaceAll(pattern, '');
    }
    return result.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
