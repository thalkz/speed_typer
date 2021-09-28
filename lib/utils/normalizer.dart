String normalize(String word) {
  return word
      .trim()
      .toUpperCase()
      .replaceAll(RegExp(r'[ÉÈÊË]'), 'E')
      .replaceAll(RegExp(r'[ÀÂ]'), 'A')
      .replaceAll(RegExp(r'[Ç]'), 'C')
      .replaceAll(RegExp(r'[Î]'), 'I')
      .replaceAll(RegExp(r'[Ô]'), 'O');
}
