class JuzMetadata {
  final int id;
  final String startSurahName;
  final int startAyah;
  final String endSurahName;
  final int endAyah;
  final int startPage;
  final int endPage;

  const JuzMetadata({
    required this.id,
    required this.startSurahName,
    required this.startAyah,
    required this.endSurahName,
    required this.endAyah,
    required this.startPage,
    required this.endPage,
  });
}

const List<JuzMetadata> juzList = [
  JuzMetadata(id: 1, startSurahName: "Fâtiha", startAyah: 1, endSurahName: "Bakara", endAyah: 141, startPage: 1, endPage: 21),
  JuzMetadata(id: 2, startSurahName: "Bakara", startAyah: 142, endSurahName: "Bakara", endAyah: 252, startPage: 22, endPage: 41),
  JuzMetadata(id: 3, startSurahName: "Bakara", startAyah: 253, endSurahName: "Âl-i İmrân", endAyah: 92, startPage: 42, endPage: 61),
  JuzMetadata(id: 4, startSurahName: "Âl-i İmrân", startAyah: 93, endSurahName: "Nisâ", endAyah: 23, startPage: 62, endPage: 81),
  JuzMetadata(id: 5, startSurahName: "Nisâ", startAyah: 24, endSurahName: "Nisâ", endAyah: 147, startPage: 82, endPage: 101),
  JuzMetadata(id: 6, startSurahName: "Nisâ", startAyah: 148, endSurahName: "Mâide", endAyah: 81, startPage: 102, endPage: 121),
  JuzMetadata(id: 7, startSurahName: "Mâide", startAyah: 82, endSurahName: "En'âm", endAyah: 110, startPage: 122, endPage: 141),
  JuzMetadata(id: 8, startSurahName: "En'âm", startAyah: 111, endSurahName: "A'râf", endAyah: 87, startPage: 142, endPage: 161),
  JuzMetadata(id: 9, startSurahName: "A'râf", startAyah: 88, endSurahName: "Enfâl", endAyah: 40, startPage: 162, endPage: 181),
  JuzMetadata(id: 10, startSurahName: "Enfâl", startAyah: 41, endSurahName: "Tevbe", endAyah: 92, startPage: 182, endPage: 201),
  JuzMetadata(id: 11, startSurahName: "Tevbe", startAyah: 93, endSurahName: "Hûd", endAyah: 5, startPage: 202, endPage: 221),
  JuzMetadata(id: 12, startSurahName: "Hûd", startAyah: 6, endSurahName: "Yûsuf", endAyah: 52, startPage: 222, endPage: 241),
  JuzMetadata(id: 13, startSurahName: "Yûsuf", startAyah: 53, endSurahName: "İbrâhîm", endAyah: 52, startPage: 242, endPage: 261),
  JuzMetadata(id: 14, startSurahName: "Hicr", startAyah: 1, endSurahName: "Nahl", endAyah: 128, startPage: 262, endPage: 281),
  JuzMetadata(id: 15, startSurahName: "İsrâ", startAyah: 1, endSurahName: "Kehf", endAyah: 74, startPage: 282, endPage: 301),
  JuzMetadata(id: 16, startSurahName: "Kehf", startAyah: 75, endSurahName: "Tâhâ", endAyah: 135, startPage: 302, endPage: 321),
  JuzMetadata(id: 17, startSurahName: "Enbiyâ", startAyah: 1, endSurahName: "Hac", endAyah: 78, startPage: 322, endPage: 341),
  JuzMetadata(id: 18, startSurahName: "Mü'minûn", startAyah: 1, endSurahName: "Furkân", endAyah: 20, startPage: 342, endPage: 361),
  JuzMetadata(id: 19, startSurahName: "Furkân", startAyah: 21, endSurahName: "Neml", endAyah: 55, startPage: 362, endPage: 381),
  JuzMetadata(id: 20, startSurahName: "Neml", startAyah: 56, endSurahName: "Ankebût", endAyah: 45, startPage: 382, endPage: 401),
  JuzMetadata(id: 21, startSurahName: "Ankebût", startAyah: 46, endSurahName: "Ahzâb", endAyah: 30, startPage: 402, endPage: 421),
  JuzMetadata(id: 22, startSurahName: "Ahzâb", startAyah: 31, endSurahName: "Yâsîn", endAyah: 27, startPage: 422, endPage: 441),
  JuzMetadata(id: 23, startSurahName: "Yâsîn", startAyah: 28, endSurahName: "Zümer", endAyah: 31, startPage: 442, endPage: 461),
  JuzMetadata(id: 24, startSurahName: "Zümer", startAyah: 32, endSurahName: "Fussilet", endAyah: 46, startPage: 462, endPage: 481),
  JuzMetadata(id: 25, startSurahName: "Fussilet", startAyah: 47, endSurahName: "Câsiye", endAyah: 37, startPage: 482, endPage: 501),
  JuzMetadata(id: 26, startSurahName: "Ahkâf", startAyah: 1, endSurahName: "Zâriyât", endAyah: 30, startPage: 502, endPage: 521),
  JuzMetadata(id: 27, startSurahName: "Zâriyât", startAyah: 31, endSurahName: "Hadîd", endAyah: 29, startPage: 522, endPage: 541),
  JuzMetadata(id: 28, startSurahName: "Mücâdele", startAyah: 1, endSurahName: "Tahrîm", endAyah: 12, startPage: 542, endPage: 561),
  JuzMetadata(id: 29, startSurahName: "Mülk", startAyah: 1, endSurahName: "Mürselât", endAyah: 50, startPage: 562, endPage: 581),
  JuzMetadata(id: 30, startSurahName: "Nebe", startAyah: 1, endSurahName: "Nâs", endAyah: 6, startPage: 582, endPage: 604),
];
