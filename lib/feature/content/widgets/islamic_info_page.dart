import 'package:flutter/material.dart';

import '../../../product/constants/app_spacing.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';

// ── Veri Modeli ────────────────────────────────────────────────────────────

class IslamicInfo {
  const IslamicInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.items,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<IslamicInfoItem> items;
}

class IslamicInfoItem {
  const IslamicInfoItem({
    required this.title,
    required this.content,
    this.count,
  });

  final String title;
  final String content;
  final String? count;
}

// ── Veriler ────────────────────────────────────────────────────────────────

const List<IslamicInfo> _infos = [
  IslamicInfo(
    title: 'Âl-i İmrân 18–27',
    subtitle: 'Yatsı sonrası okunan âyetler ve faziletleri',
    icon: Icons.menu_book_rounded,
    color: AppColors.primary,
    items: [
      IslamicInfoItem(
        title: 'Âl-i İmrân 18. Ayet (Şehidallâhu)',
        content:
            'شَهِدَ اللّٰهُ اَنَّهُ لَآ اِلٰهَ اِلَّا هُوَۙ وَالْمَلٰٓئِكَةُ وَاُو۬لُوا الْعِلْمِ قَآئِمًا بِالْقِسْطِۜ لَآ اِلٰهَ اِلَّا هُوَ الْعَز۪يزُ الْحَك۪يمُۜ\n\n'
            'Okunuşu: Şehidallâhu ennehû lâ ilâhe illâ huve, vel melâiketu ve ulûl ilmi kâimen bil kıst(kıstı), lâ ilâhe illâ huvel azîzul hakîm(hakîmu).\n\n'
            'Meali: Allah, melekler ve ilim sahipleri, ondan başka ilâh olmadığına adaletle şâhitlik ettiler. O\'ndan başka ilâh yoktur. O, mutlak güç sahibidir, hüküm ve hikmet sahibidir.',
      ),
      IslamicInfoItem(
        title: 'Âl-i İmrân 19. Ayet',
        content:
            'اِنَّ الدّ۪ينَ عِنْدَ اللّٰهِ الْاِسْلَامُۙ وَمَا اخْتَلَفَ الَّذ۪ينَ اُو۬تُوا الْكِتَابَ اِلَّا مِنْ بَعْدِ مَا جَآءَهُمُ الْعِلْمُ بَغْيًا بَيْنَهُمْۜ وَمَنْ يَكْفُرْ بِاٰيَاتِ اللّٰهِ فَاِنَّ اللّٰهَ سَر۪يعُ الْحِسَابِ\n\n'
            'Okunuşu: İnned dîne indâllâhil islâm(islâmu), ve mâhtelefellezîne ûtûl kitâbe illâ min ba’di mâ câehumul ilmu bagyen beynehum, ve men yekfur bi âyâtillâhi fe innallâhe serîul hısâb(hısâbu).\n\n'
            'Meali: Şüphesiz Allah katında din İslâm\'dır. Kitap verilmiş olanlar, kendilerine ilim geldikten sonra sırf aralarındaki ihtiras ve aşırılık yüzünden ayrılığa düştüler. Kim Allah\'ın âyetlerini inkâr ederse, bilsin ki Allah hesabı çok çabuk görendir.',
      ),
      IslamicInfoItem(
        title: 'Âl-i İmrân 27. Ayet (Rızık Ayeti)',
        content:
            'تُولِجُ الَّيْلَ فِي النَّهَارِ وَتُولِجُ النَّهَارَ فِي الَّيْلِ وَتُخْرِجُ الْحَيَّ مِنَ الْمَيِّتِ وَتُخْرِجُ الْمَيِّتَ مِنَ الْحَيِّ وَتَرْزُقُ مَنْ تَشَاءُ بِغَيْرِ حِسَابٍ\n\n'
            'Okunuşu: Tuillicul leyle fin nehari ve tulicun nehara fil leyl, ve tuhricul hayya minel meyyiti ve tuhricul meyyite minel hayy, ve terzuku men teşau bi gayri hısab.\n\n'
            'Meali: Geceyi gündüze dönüştürür, gündüzü de geceye dönüştürürsün. Diriyi, ölüden çıkarırsın, ölüyü de diriden çıkarırsın. Hak edene hesapsız rızık verirsin.',
      ),
      IslamicInfoItem(
        title: 'Ne Zaman Okunur?',
        content:
            'Yatsı namazından sonra Âl-i İmrân sûresinin 18–27. âyetleri okunur.',
      ),
      IslamicInfoItem(
        title: 'Sıratı Müstakim Üzere Olur',
        content:
            'Bu âyetleri düzenli okuyan kimse, Allah\'ın izniyle doğru yol üzere olma fazileti kazanır.',
      ),
      IslamicInfoItem(
        title: 'İmansız Ölmez',
        content:
            'Bu âyetleri okumanın en büyük faziletlerinden biri: kişi iman ile ahirete göç eder.',
      ),
      IslamicInfoItem(
        title: 'Rızık Sıkıntısı Çekmez',
        content:
            'Okumayı alışkanlık haline getiren kimse, geçim konusunda genişlik ve bereket bulur.',
      ),
      IslamicInfoItem(
        title: 'Bulunduğu Toplulukta İtibar Görür',
        content:
            'Bu âyetlere devam eden kimse, toplum içinde saygı ve değer görme fazileti elde eder.',
      ),
    ],
  ),
  IslamicInfo(
    title: 'Gece virdi-Yatmadan evvel okunulması gerekir',
    subtitle: 'Gece ve uyku öncesi okunacak zikir ve sureler',
    icon: Icons.nights_stay_rounded,
    color: AppColors.accent,
    items: [
      IslamicInfoItem(
        title: 'Euzu Besmele',
        content: 'Eûzübillâhimineşşeytânirracîmbismillâhirrahmânirrahîm',
        count: '21×',
      ),
      IslamicInfoItem(
        title: 'Hasbünallah ve Ni\'mel Vekîl',
        content: 'Hasbünallah ve ni\'mel vekîl',
        count: '10×',
      ),
      IslamicInfoItem(
        title: 'Sübhânallah Tesbihi',
        content: 'Sübhânallâhi ve bihimdihî\nSübhânallâhil\'azîm',
        count: '3×',
      ),
      IslamicInfoItem(
        title: 'İstiğfar',
        content: 'Estağfurullâhel azîm ve etûbu ileyh',
        count: '3×',
      ),
      IslamicInfoItem(
        title: 'Yunus (a.s.) Duası',
        content: 'Lâ ilâhe illâ ente sübhâneke innî küntü minezzâlimîn',
        count: '3×',
      ),
      IslamicInfoItem(
        title: 'Af Duası',
        content: 'Allâhümme inneke afüvvün kerîmün\ntühibbül afve fa\'fü annî',
        count: '3×',
      ),
      IslamicInfoItem(
        title: 'Kelime-i Şehadet',
        content:
            'Eşhedü en lâ ilâhe illallah\n'
            've eşhedü enne Muhammeden abduhü ve resûlüh',
        count: '1×',
      ),
      IslamicInfoItem(
        title: 'Kelime-i Tevhid',
        content: 'Lâ ilâhe illallah',
        count: '1×',
      ),
      IslamicInfoItem(
        title: 'Tevekkül Duası',
        content:
            'Hasbiyallâhu lâ ilâhe illâ hü\naleyhi tevekkeltü ve hüve rabbül arşil azîm',
        count: '1×',
      ),
      IslamicInfoItem(
        title: 'Evden Çıkarken Okunan Dua',
        content:
            'Bismillâhi, tevekkeltü alallâhi,\nlâ havle ve lâ kuvvete illâ billâh',
        count: '1×',
      ),
      IslamicInfoItem(
        title: 'Avuç İçine — Âyetel Kürsî',
        content: 'Bakara Sûresi 255. âyet.\nAvuç içine okunur.',
        count: '1×',
      ),
      IslamicInfoItem(
        title: 'Avuç İçine — Kâfirûn Sûresi',
        content: 'Avuç içine okunur.',
        count: '1×',
      ),
      IslamicInfoItem(
        title: 'Avuç İçine — İhlâs Sûresi',
        content: 'Avuç içine okunur.',
        count: '1×',
      ),
      IslamicInfoItem(
        title: 'Avuç İçine — Felak Sûresi',
        content: 'Avuç içine okunur.',
        count: '1×',
      ),
      IslamicInfoItem(
        title: 'Avuç İçine — Nâs Sûresi',
        content: 'Avuç içine okunur.',
        count: '1×',
      ),
      IslamicInfoItem(
        title: 'Avuç İçine — Kevser Sûresi',
        content: 'Avuç içine okunur.',
        count: '1×',
      ),
      IslamicInfoItem(
        title: 'Vird Sonu Notu',
        content:
            'Avuç içine üflenildikten sonra tüm vücut mesh edilecek ve yatılacak.',
      ),
    ],
  ),
  IslamicInfo(
    title: 'Sıkıntı Duası (Buhari)',
    subtitle: 'Azamet ve vakar sahibi Allah\'a iltica',
    icon: Icons.healing_rounded,
    color: Colors.indigo,
    items: [
      IslamicInfoItem(
        title: 'Sıkıntı Anında Okunacak Dua',
        content:
            'Lâilâhe illâllahül-azîmül-halîm. Lâilâhe illâllahu Rabbül-arşil-azîm. '
            'Lâilâhe illâllahu Rabbüs-semâvâti ve Rabbül-ardi ve Rabbül-arşil-kerîm\n\n'
            'Meali: "Azamet ve vakar sahibi Allah’tan başka, ibadete lâyık hiçbir ilâh yoktur. '
            'Arş-ı Âzam sahibi Allah’tan başka ibadete lâyık hiçbir ilâh yoktur. '
            'Göklerin ve yerin sahibi ve Arş-ı kerim’in mâliki Allah’tan başka ibadete lâyık hiçbir ilâh yoktur."',
      ),
    ],
  ),
  IslamicInfo(
    title: 'Nur Ayeti (Nur 35)',
    subtitle: 'Allah göklerin ve yerin nurudur',
    icon: Icons.light_mode_rounded,
    color: Color.fromARGB(255, 253, 144, 1),
    items: [
      IslamicInfoItem(
        title: 'Nur Suresi 35. Ayet',
        content:
            'اَللّٰهُ نُورُ السَّمٰوَاتِ وَالْاَرْضِۜ مَثَلُ نُورِه۪ كَمِشْكٰوةٍ ف۪يهَا مِصْبَاحٌۜ '
            'اَلْمِصْبَاحُ f۪ي زُجَاجَةٍۜ اَلزُّجَاجَةُ كَاَنَّهَا كَوْكَبٌ دُرِّيٌّ يُوقَدُ مِنْ شَجَرَةٍ مُبَارَكَةٍ '
            'زَيْتُونَةٍ لَا شَرْقِيَّةٍ وَلَا غَرْBِيَّةٍۙ يَكَادُ زَيْتُهَا يُض۪ٓيءُ وَلَوْ لَمْ تEMْسَسْهُ نَارٌۜ '
            'نُورٌ عَلٰى نُورٍۜ يَهْدِي اللّٰهُ لِنُورِه۪ مَنْ يَشَٓاءُۜ وَيَضْرِبُ اللّٰهُ الْاَمْثَالَ لِلنَّاسِۜ '
            'وَاللّٰهُ بِكُلِّ شَيْءٍ عَل۪يمٌۙ\n\n'
            'Okunuşu: Allahu nurus semavati vel ard, meselu nurihi ke mişkatin fiha mısbah, '
            'el mısbahu fi zucaceh, ez zucacetu ke enneha kevkebun durriyyun, yukadu min şeceratin '
            'mubaraketin zeytunetin la şarkiyetin ve la garbiyyetin, yekadu zeytuha yudiu ve lev lem '
            'temseshu nar, nurun ala nur, yehdillahu li nurihi men yeşau, ve yadribullahul emsale lin nas, '
            'vallahu bi kulli şey\'in alim.\n\n'
            'Meali: Allah, göklerin ve yeryüzünün aydınlığıdır. O\'nun aydınlığı, içinde ışık bulunan '
            'kandil yuvası gibidir. O kandil, bir fanus içindedir. O fanus, inciden bir yıldız gibidir. '
            'Doğuya da batıya da ait olmayan mübarek bir ağacın yağından yakılır. Onun yağı neredeyse '
            'kendisine ateş dokunmasa bile ışık verir. Aydınlık üstüne aydınlıktır. Allah, hak eden kimseyi '
            'aydınlığına iletir. Allah, insanlara örnekler verir. Allah, her şeyi bütün ayrıntılarıyla bilendir.',
      ),
    ],
  ),
  IslamicInfo(
    title: 'Hz. Nuh\'un Duası',
    subtitle: 'Tövbe ve merhamet talebi',
    icon: Icons.water_drop_rounded,
    color: Colors.teal,
    items: [
      IslamicInfoItem(
        title: 'Hud Suresi 47. Ayet',
        content:
            'قَالَ رَبِّ اِنّ۪ٓي اَعُوذُ بِكَ اَنْ اَسْـَٔلَكَ مَا لَيْسَ ل۪ي بِه۪ عِلْمٌۜ وَاِلَّا تَغْفِرْ ل۪ي '
            'وَاَتَرْحEMْن۪ٓي اَكُنْ مِنَ الْخَاسِر۪ينَ\n\n'
            'Meali: Nûh şöyle yalvardı: “Rabbim! Doğrusu ben, hakkında bilgim olmayan bir şeyi senden '
            'istemekten yine sana sığınırım. Eğer beni bağışlamaz ve bana merhamet etmezsen elbette '
            'ziyana uğrayanlardan olurum.”',
      ),
    ],
  ),
  IslamicInfo(
    title: 'On İki Meleğin Taşıdığı Zikir',
    subtitle: 'Meleklerin yükseltmek için yarıştığı müjde',
    icon: Icons.auto_awesome_rounded,
    color: Colors.deepPurple,
    items: [
      IslamicInfoItem(
        title: 'Müjdelenmiş Zikir',
        content:
            'Namaz kılarken nefes nefese bir adam gelip şöyle dedi:\n'
            '"Allahü ekber, Elhamdülillahi hamden kesiran, tayyiben, mübareken fihi."\n'
            '(Allah büyüktür, çok temiz ve mübarek hamdler Allah\'adır!)\n\n'
            'Resulullah (asm) namaz sonunda buyurdu ki: "Ben on iki melek gördüm. '
            'Her biri, bu kelimeleri (Allah\'ın huzuruna) kendisi yükseltmek için koşuşmuşlardı."',
      ),
      IslamicInfoItem(
        title: 'Ne Zaman Okunur?',
        content:
            'Bu zikir, namazda rükûdan doğrulurken "Rabbenâ lekel hamd" dedikten hemen sonra okunabilir.',
      ),
    ],
  ),
  IslamicInfo(
    title: 'Zikrin Edebi (Araf 205)',
    subtitle: 'Rabbini sabah akşam huşu ile zikret',
    icon: Icons.self_improvement_rounded,
    color: Color.fromARGB(255, 56, 142, 60),
    items: [
      IslamicInfoItem(
        title: 'Araf Suresi 205. Ayet',
        content:
            'Veżkur rabbeke fî nefsike tedarru’an veḣîfeten vedûnel cehri minel kavli '
            'bilġuduvvi vel-âsâli velâ tekun minel ġâfilîn…\n\n'
            'Meali: Rabbini sabah akşam içten içe, boyun büküp yalvara yakara, derin bir ürpertiyle '
            've ancak kendin işitebileceğin bir sesle zikret! Sakın gâfillerden olma!',
      ),
    ],
  ),
  IslamicInfo(
    title: 'Bedir Ehli ve Faziletleri',
    subtitle: 'Muradı olanlar için Bedir Ashâbı ve duaların kabulü',
    icon: Icons.military_tech_rounded,
    color: Color.fromARGB(255, 121, 85, 72),
    items: [
      IslamicInfoItem(
        title: 'Bedir Zaferi ve Fazileti',
        content:
            'Ramazan ayının 17. Gecesi Bedir zaferinin alındığı gecedir. Bugün, Enfal Suresi 41. Ayette geçen '
            'Hakla batılın ayrıldığı FURKAN Günüdür. Başta RASÛLULLAH (S.A.V.) ve 313 Arslan gibi '
            'Sahabe-i Kirâm ve Cebrail, Mikail, İsrafil (A.S.) komutasında 3000 melekle '
            'RABBİMİZİN yardımıyla kazanılan zafer gecesidir!\n\n'
            'Bu gece ne hayırlı muradımız varsa o niyetle Ashâb-ı Bedr\'in isimlerini tevessül ile okuyalım. '
            'Rabbimiz mutlaka kabul eder..!',
      ),
      IslamicInfoItem(
        title: 'Okuma Usulü ve Edebi',
        content:
            'Bu mübarek isimlerin okunuşu sırasında herbirinin adı söylenince, '
            '"Radıyallahü anh" (Allah ondan razı olsun) demek lazımdır.',
      ),
      IslamicInfoItem(
        title: 'Ashâb-ı Bedir İsim Listesi (1-331)',
        content:
            '01. Seyyidüna Muhammed (S.A.V.)\n02. Seyyidüna Ebû Bekir Sıddıyk (R.A.)\n'
            '03. Seyyidüna Ömer ibnü\'l-Hattab (R.A.)\n04. Seyyidüna Osman ibn-i Affan (R.A.)\n'
            '05. Seyyidüna Aliyy ibn-i Ebi Talib (R.A.)\n06. Seyyidüna Talha bin Ubeydullah (R.A.)\n'
            '07. Seyyidüna Zübeyr ibn-i Avvam (R.A.)\n08. Seyyidüna Abdurrahman bin Avf (R.A.)\n'
            '09. Seyyidüna Sa\'d bin Ebi Vakkas (R.A.)\n10. Seyyidüna Said ibn-i Zeyd (R.A.)\n'
            '11. Seyyidüna Ebu Ubeyde bin Cerrah (R.A.)\n12. Seyyidüna Übeyy ibn-i Ka\'b (R.A.)\n'
            '13. Seyyidüna el-Ahnes ibn-i Habib (R.A.)\n14. Seyyidüna el-Erkam ibn-i Erkam (R.A.)\n'
            '15. Seyyidüna Es\'ad ibn-i Yezîd (R.A.)\n16. Seyyidüna Enes Mevla Rasülillah (R.A.)\n'
            '17. Seyyidüna Enes ibn-i Muaz (R.A.)\n18. Seyyidüna Enes ibn-i Katadet\'el-Evsi (R.A.)\n'
            '19. Seyyidüna Evs ibn-i Sabit (R.A.)\n20. Seyyidüna Evs ibn-i Havli (R.A.)\n'
            '21. Seyyidüna İyas ibn-i Evs (R.A.)\n22. Seyyidüna İyas ibn\'il-Bükeyr (R.A.)\n'
            '23. Seyyidüna Büceyr ibn-i Ebi Büceyr (R.A.)\n24. Seyyidüna Bahhas ibn-i Sa\'lebe (R.A.)\n'
            '25. Seyyidüna el-Bera bin Ma\'rur (R.A.)\n26. Seyyidüna Besbese bin Amr (R.A.)\n'
            '27. Seyyidüna Bişr ibn\'il-Bera (R.A.)\n28. Seyyidüna Beşir ibn-i Said (R.A.)\n'
            '29. Seyyidüna Bilal ibn-i Rebah (R.A.)\n30. Seyyidüna Temim Mevla Hıraş (R.A.)\n'
            '31. Seyyidüna Temim Mevla Beni Ganem bin es-Silm (R.A.)\n32. Seyyidüna Temim ibn-i Yuar (R.A.)\n'
            '33. Seyyidüna Sabit ibn-i Akram (R.A.)\n34. Seyyidüna Sabit ibn-i Sa\'lebe (R.A.)\n'
            '35. Seyyidüna Sabit ibn-i Halid (R.A.)\n36. Seyyidüna Sabit ibn-i Amr (R.A.)\n'
            '37. Seyyidüna Sabit ibn-i Hezzal (R.A.)\n38. Seyyidüna Sa\'lebe bin Hatim (R.A.)\n'
            '39. Seyyidüna Sa\'lebe bin Amr (R.A.)\n40. Seyyidüna Sa\'lebe bin Aneme (R.A.)\n'
            '41. Seyyidüna Sıkf ibn-i Amr (R.A.)\n42. Seyyidüna Cabir ibn-i Abdullah bin Riyab (R.A.)\n'
            '43. Seyyidüna Cabir ibn-i Abdullah bin Amr (R.A.)\n44. Seyyidüna Cebbar ibn-i Sahr (R.A.)\n'
            '45. Seyyidüna Cübr ibn-i Atik (R.A.)\n46. Seyyidüna Cübeyr ibn-i İyas (R.A.)\n'
            '47. Seyyidüna Hamza bin Abd\'il-Muttalib (R.A.)\n48. Seyyidüna el-Haris ibn-i Enes (R.A.)\n'
            '49. Seyyidüna el-Haris ibn-i Evs bin Rafi\' (R.A.)\n50. Seyyidüna el-Haris ibn-i Evs bin Muaz (R.A.)\n'
            '51. Seyyidüna el-Haris ibn-i Hatib (R.A.)\n52. Seyyidüna el-Haris ibn-i Ebî Hazme (R.A.)\n'
            '53. Seyyidüna el-Haris ibn-i Hazme (R.A.)\n54. Seyyidüna el-Haris ibn-i Simme (R.A.)\n'
            '55. Seyyidüna el-Haris ibn-i Arfece (R.A.)\n56. Seyyidüna el-Haris ibn-i Kays (R.A.)\n'
            '57. Seyyidüna el-Haris ibn-i Kays (R.A.)\n58. Seyyidüna el-Haris ibn\'un-Nu\'man ibn-i Ümeyye (R.A.)\n'
            '59. Seyyidüna Harise bin Süraka (R.A.) (ŞEHİD)\n60. Seyyidüna Harise bin Nu\'man (R.A.)\n'
            '61. Seyyidüna Hatıb ibn-i Ebi Beltea (R.A.)\n62. Seyyidüna Hatıb ibn-i Amr (R.A.)\n'
            '63. Seyyidüna el-Hubab ibn-i Münzir (R.A.)\n64. Seyyidüna Habîb ibn-i Esved (R.A.)\n'
            '65. Seyyidüna Haram ibn-i Milhan (R.A.)\n66. Seyyidüna Hureys ibn-i Zeyd (R.A.)\n'
            '67. Seyyidüna el-Husayn ibn-i Haris (R.A.)\n68. Seyyidüna Hamza bin el-Mumeyyir (R.A.)\n'
            '69. Seyyidüna Harice bin Zeyd (R.A.)\n70. Seyyidüna Halid ibn-i el-Bükeyr (R.A.)\n'
            '71. Seyyidüna Halid ibn-i Kays (R.A.)\n72. Seyyidüna Habbab ibn\'ül-Eret (R.A.)\n'
            '73. Seyyidüna Habbab Mevla Utbe (R.A.)\n74. Seyyidüna Hubeyb ibn-i İsaf (R.A.)\n'
            '75. Seyyidüna Hıdaş ibn-i Katade (R.A.)\n76. Seyyidüna Hıraş ibn\'is-Sımme (R.A.)\n'
            '77. Seyyidüna Hureym ibn-i Fatik (R.A.)\n78. Seyyidüna Hallad ibn-i Rafi\' (R.A.)\n'
            '79. Seyyidüna Hallad ibn-i Süveyd (R.A.)\n80. Seyyidüna Hallad ibn-i Amr (R.A.)\n'
            '81. Seyyidüna Hallad ibn-i Kays (R.A.)\n82. Seyyidüna Huleyd ibn-i Kays (R.A.)\n'
            '83. Seyyidüna Halife bin Adiyy (R.A.)\n84. Seyyidüna Huneys ibn-i Hazafe (R.A.)\n'
            '85. Seyyidüna Havvat ibn-i Cübeyr (R.A.)\n86. Seyyidüna Havli bin Ebî Havli (R.A.)\n'
            '87. Seyyidüna Zekvan ibn-i Ubeyd (R.A.)\n88. Seyyidüna Zü\'ş-Şimaleyn ibn-i Abd Amr (R.A.) (ŞEHİD)\n'
            '89. Seyyidüna Raşid ibn-i Mualla (R.A.)\n90. Seyyidüna Rafi bin Haris (R.A.)\n'
            '91. Seyyidüna Rafi\' bin Ğunecde (R.A.)\n92. Seyyidüna Rafi\' bin Malik (R.A.)\n'
            '93. Seyyidüna Rafi\' ibn\'ül-Muall (R.A.) (ŞEHİD)\n94. Seyyidüna Rafi\' bin Yezîd (R.A.)\n'
            '95. Seyyidüna Rib\'ıy bin Rafi\' (R.A.)\n96. Seyyidüna er-Rebi\'ibn-ü İyas (R.A.)\n'
            '97. Seyyidüna Rabia bin Eksem (R.A.)\n98. Seyyidüna Ruhayle bin Sa\'lebe (R.A.)\n'
            '99. Seyyidüna Rifaa bin Haris (R.A.)\n100. Seyyidüna Rifaa bin Rafi\' (R.A.)\n'
            '101. Seyyidüna Rifaa bin Abd\'il Münzir (R.A.)\n102. Seyyidüna Rifaa bin Amr (R.A.)\n'
            '103. Seyyidüna Zübeyr ibn-i Avvam (R.A.)\n104. Seyyidüna Ziyad ibn\'is-Seken (R.A.)\n'
            '105. Seyyidüna Ziyad ibn-i Lebid (R.A.)\n106. Seyyidüna Ziyad ibn-i Amr (R.A.)\n'
            '107. Seyyidüna Zeyd ibn-i Eslem (R.A.)\n108. Seyyidüna Zeyd ibn-i Harise (R.A.)\n'
            '109. Seyyidüna Zeyd ibn\'ül-Hattab (R.A.)\n110. Seyyidüna Zeyd ibn\'ül-Müzeyyen (R.A.)\n'
            '111. Seyyidüna Zeyd ibn\'ül-Mualla (R.A.)\n112. Seyyidüna Zeyd ibn-i Vedia (R.A.)\n'
            '113. Seyyidüna Salim Mevla Ebî Huzeyfe (R.A.)\n114. Seyyidüna Salim ibn-i Umeyr (R.A.)\n'
            '115. Seyyidüna es-Saib ibn-i Osman (R.A)\n116. Seyyidüna Sebre bin Fatik (R.A.)\n'
            '117. Seyyidüna Süraka bin Amr (R.A.)\n118. Seyyidüna Süraka bin Ka\'b (R.A.)\n'
            '119. Seyyidüna Sa\'d Mevla Hatıb (R.A.)\n120. Seyyidüna Sa\'d ibn\'i Havle (R.A.)\n'
            '121. Seyyidüna Sa\'d ibn\'i Hayseme (R.A.) (ŞEHİD)\n122. Seyyidüna Sa\'d ibn\'ür-Rebi (R.A.)\n'
            '123. Seyyidüna Sa\'d ibn-i Zeyd (R.A.)\n124. Seyyidüna Sa\'d ibn-i Sa\'d (R.A.)\n'
            '125. Seyyidüna Sa\'d ibn-i Sehi (R.A.)\n126. Seyyidüna Sa\'d ibn-i Ubade (R.A.)\n'
            '127. Seyyidüna Sa\'d ibn-u Ubeyd (R.A.)\n128. Seyyidüna Sa\'d ibn-i Osman (R.A.)\n'
            '129. Seyyidüna Sa\'d ibn-i Muaz (R.A.)\n130. Seyyidüna Süflan ibn-i Bişr (R.A.)\n'
            '131. Seyyidüna Seleme bin Eslem (R.A.)\n132. Seyyidüna Süleym ibn-ül-Haris (R.A.)\n'
            '133. Seyyidüna Seleme bin Selame (R.A.)\n134. Seyyidüna Selît\' ibn-i Kays (R.A.)\n'
            '135. Seyyidüna Süleym ibn-ül Haris (R.A.)\n136. Seyyidüna Süleym ibn-i Kays (R.A.)\n'
            '137. Seyyidüna Süleym ibn-i Amr (R.A.)\n138. Seyyidüna Süleym ibn-i Milhan (R.A.)\n'
            '139. Seyyidüna Simak ibn-i Sa\'d (R.A.)\n140. Seyyidüna Sinan ibn-i Ebî Sinan (R.A.)\n'
            '141. Seyyidüna Sinan ibn-i Sayfi (R.A.)\n142. Seyyidüna Sehl ibn-i Huneyf (R.A.)\n'
            '143. Seyyidüna Sehl ibn-i Rafi\' (R.A.)\n144. Seyyidüna Sehl ibn-i Atik (R.A.)\n'
            '145. Seyyidüna Sehl ibn-i Kays (R.A.)\n146. Seyyidüna Sehl ibn-i Vehb (R.A.)\n'
            '147. Seyyidüna Sehl ibn-i Rafi\' (R.A.)\n148. Seyyidüna Sevad ibn-i Zerin (R.A.)\n'
            '149. Seyyiduna Sevad ibn-i Ğaziyye (R.A.)\n150. Seyyidüna Süveybıt ibn-i Harmele (R.A.)\n'
            '151. Seyyidüna Şüca\' ibn-i Ebi Vehb (R.A.)\n152. Seyyidüna Şerik ibn-i Enes (R.A.)\n'
            '153. Seyyidüna Şemmas ibn-i Osman (R.A.)\n154. Seyyiduna Sabiyh Mevla Eb\'l-As (R.A.)\n'
            '155. Seyyidüna Safvan ibn-i Vehb (R.A.) (ŞEHİD)\n156. Seyyidüna Şuheyb ibn-i Sinan (R.A.)\n'
            '157. Seyyidüna Sayfi bin Sevad (R.A.)\n158. Seyyidüna ed-Dahhak ibn-i Harise (R.A.)\n'
            '159. Seyyidüna ed-Dahhak ibn-i Abd-i Amr (R.A.)\n160. Seyyidüna Damre bin Amr (R.A.)\n'
            '161. Seyyidüna et-Tufeyl ibn-i Haris (R.A.)\n162. Seyyidüna et-Tufeyl ibn-i Malik (R.A.)\n'
            '163. Seyyidüna et-Tufeyl ibn-i Nu\'man (R.A.)\n164. Seyyidüna Tuleyb ibn-u Umeyr (R.A.)\n'
            '165. Seyyidüna Asım ibn-i Sabir (R.A.)\n166. Seyyidüna Asım ibn-i Adiyy (R.A.)\n'
            '167. Seyyidüna Asım ibn-i Ukeyr (R.A.)\n168. Seyyidüna Asım ibn-i Kays (R.A.)\n'
            '169. Seyyiduna Akıl ibn\'ül-Bükeyr (R.A.) (ŞEHİD)\n170. Seyyidüna Amir ibn-i Ümeyye (R.A.)\n'
            '171. Seyyidüna Amir ibn-i Bükeyr (R.A.)\n172. Seyyiduna Amir ibn-i Rebia (R.A.)\n'
            '173. Seyyidüna Amir ibn-i Sa\'d (R.A.)\n174. Seyyidüna Amir ibn-i Seleme (R.A.)\n'
            '175. Seyyidüna Amir ibn-i Füheyre (R.A.)\n176. Seyyidüna Amir ibn-i Muhalled (R.A.)\n'
            '177. Seyyidüna Amir ibn-i Yezîd (R.A.)\n178. Seyyidüna Ayiz ibn-i Maıs (R.A.)\n'
            '179. Seyyidüna Abbad ibn-i Bişr (R.A.)\n180. Seyyidüna Abbad ibn-i Kays (R.A.)\n'
            '181. Seyyidüna Ubade bin Samit (R.A.)\n182. Seyyidüna Abdullah ibn-i Sa\'lebe (R.A.)\n'
            '183. Seyyidüna Abdullah ibn-i Cübeyr (R.A.)\n184. Seyyidüna Abdullah ibn-i Çahş (R.A.)\n'
            '185. Seyyidüna Abdullah ibnü\'l-Ced (R.A.)\n186. Seyyidüna Abdullah ibn\'ül-Humeyyir (R.A.)\n'
            '187. Seyyiduna Abdullah ibn\'ür-Rebi (R.A.)\n188. Seyyidüna Abdullah ibn-i Revaha (R.A.)\n'
            '189. Seyyidüna Abdullah ibn-i Zeyd (R.A.)\n190. Seyyidüna Abdullah ibn-i Süraka (R.A.)\n'
            '191. Seyyidüna Abdullah ibn-i Seleme (R.A.)\n192. Seyyidüna Abdullah ibn-i Sehi (R.A.)\n'
            '193. Seyyidüna Abdullah ibn-i Süheyl (R.A.)\n194. Seyyidüna Abdullah ibn-i Şerik (R.A.)\n'
            '195. Seyyidüna Abdullah ibn-i Tarık (R.A.)\n196. Seyyidüna Abdullah ibn-i Amir (R.A.)\n'
            '197. Seyyidüna Abdullah ibn-i Abd-i Menaf (R.A.)\n198. Seyyidüna Abdullah ibn-i Urfuta (R.A.)\n'
            '199. Seyyidüna Abdullah ibn-i Amr (R.A.)\n200. Seyyidüna Abdullah ibn-i Ümeyir (R.A.)\n'
            '201. Seyyidüna Abdullah ibn-i Kays bin Halid (R.A.)\n202. Seyyiduna Abdullah ibn-i Kays bin Sayfi (R.A.)\n'
            '203. Seyyidüna Abdullah ibn-i Ka\'b (R.A.)\n204. Seyyidüna Abdullah ibn-i Mahreme (R.A.)\n'
            '205. Seyyidüna Abdullah ibn-i Mes\'ud (R.A.)\n206. Seyyidüna Abdullah ibn-i Maz\'un (R.A.)\n'
            '207. Seyyidüna Abdullah ibn-i Numan (R.A.)\n208. Seyyidüna Abd-i Rabb ibn-i Cebr (R.A.)\n'
            '209. Seyyiduna Abdurrahman ibn-i Cebr (R.A.)\n210. Seyyidüna Abdet\'el-Haşhaş (R.A.)\n'
            '211. Seyyidüna Abd ibn-i Amir (R.A.)\n212. Seyyidüna Ubeyd ibn\'ut-Teyyihan ey-Evsî (R.A.)\n'
            '213. Seyyidüna Ubeyd ibn-i Zeyd (R.A.)\n214. Seyyidüna Ubeyd ibn-i Ebî Ubeyd (R.A.)\n'
            '215. Seyyidüna Ubeyde bin Haris (R.A.)\n216. Seyyidüna Utban ibn-i Malik (R.A.)\n'
            '217. Seyyidüna Utbe bin Rebıa (R.A.)\n218. Seyyidüna Utbe bin Abdullah (R.A.)\n'
            '219. Seyyidüna Utbe bin Gazvan (R.A.)\n220. Seyyidüna Osman ibn-i Maz\'un (R.A.)\n'
            '221. Seyyidüna el-Aclan ibn\'ün Nu\'man (R.A.)\n222. Seyyidüna Adiyy ibn-i Ebi Zağba (R.A.)\n'
            '223. Seyyidüna İsmet\'übn\'ül-Husayn (R.A.)\n224. Seyyidüna Usaymet\'ül (R.A.)\n'
            '225. Seyyidüna Atıyye bin Nüveyre (R.A.)\n226. Seyyidüna Ukbe bin Amir (R.A.)\n'
            '227. Seyyidüna Ukbe bin Osman (R.A.)\n228. Seyyiduna Ukbe bin Vehb (R.A.)\n'
            '229. Seyyidüna Ukbe bin Vehb (R.A.)\n230. Seyyidüna Ukkaşe bin Mıhsan (R.A.)\n'
            '231. Seyyidüna Amman ibn-i Yasir (R.A.)\n232. Seyyidüna Umare bin Hazm (R.A.)\n'
            '233. Seyyidüna Umare bin Ziyad (R.A.)\n234. Seyyidüna Amr ibn-i İyas (R.A.)\n'
            '235. Seyyidüna Amr ibn-i Sa\'lebe (R.A.)\n236. Seyyidüna Amr ibn\'ül-Cemuh (R.A.)\n'
            '237. Seyyidüna Amr ibn\'ül-Haris (R.A.)\n238. Seyyidüna Amr ibn\'ül Haris (R.A.)\n'
            '239. Seyyidüna Amr ibn-i Süraka (R.A.)\n240. Seyyidüna Amr ibn-i Ebi Şerh (R.A.)\n'
            '241. Seyyidüna Amr ibn-i Talk (R.A.)\n242. Seyyidüna Amr ibn-i Kays (R.A.)\n'
            '243. Seyyidüna Amr ibn-i Muaz (R.A.)\n244. Seyyidüna Umeyr ibn-i Haram (R.A.)\n'
            '245. Seyyidüna Umeyr ibn\'ül Humam (R.A.) (ŞEHİD)\n246. Seyyidüna Umeyr ibn\'ül-Amir (R.A.)\n'
            '247. Seyyidüna Umeyr ibn-i Avf (R.A.)\n248. Seyyidüna Umeyr ibn-i Ma\'bed (R.A.)\n'
            '249. Seyyidüna Umeyr ibn-i Ebî Vakkas (R.A.) (ŞEHİD)\n250. Seyyidüna Avf ibn\'ül-Haris (R.A.)\n'
            '251. Seyyidüna Uveym ibn-i Saide (R.A.)\n252. Seyyidüna İyaz ibn-i Züheyr (R.A.)\n'
            '253. Seyyidüna Ğannam ibn-i Evs (R.A.)\n254. Seyyiduna el-Fakih ibn-i Bişr (R.A.)\n'
            '255. Seyyiduna Ferve bin Amr (R.A.)\n256. Seyyiduna Katade bin Numan (R.A.)\n'
            '257. Seyyidüna Kudame bin Maz\'un (R.A.)\n258. Seyyidüna Kutbe bin Amir (R.A.)\n'
            '259. Seyyidüna Kays ibn-i Mıhsan (R.A.)\n260. Seyyidüna Kays ibn-i Mıhsan (R.A.)\n'
            '261. Seyyidüna Kays ibn-i Muhalled (R.A.)\n262. Seyyidüna Ka\'b ibn-i Cemmez (R.A.)\n'
            '263. Seyyidüna Ka\'b ibn-i Zeyd (R.A.)\n264. Seyyidüna Malik ibn-i Ebi Havli (R.A.)\n'
            '265. Seyyidüna Malik ibn-i Ebi Havli (R.A.)\n266. Seyyidüna Malik ibn\'ud Duhşum (R.A.)\n'
            '267. Seyyidüna Malik ibn-i Rifaa (R.A.)\n268. Seyyidüna Malik ibn-i Rifaa (R.A.)\n'
            '269. Seyyidüna Malik ibn-i Amr (R.A.)\n270. Seyyidüna Malik ibn-i Kudame (R.A.)\n'
            '271. Seyyidüna Malik ibn-i Mes\'üd (R.A.)\n272. Seyyiduna Malik ibn-i Nümeyle (R.A.)\n'
            '273. Seyyidüna Malik Mübeşşir bin Abd\'il-Munzir (R.A.) (ŞEHİD)\n274. Seyyidüna Mücezzer ibn-i Ziyad (R.A.)\n'
            '275. Seyyidüna Muhriz ibn-i Amin (R.A.)\n276. Seyyidüna Muhriz ibn-i Nasle (R.A.)\n'
            '277. Seyyidüna Muhammed ibn-i Mesleme (R.A.)\n278. Seyyidüna Midlac ibn-i Amir (R.A.)\n'
            '279. Seyyidüna Mersed ibn-i Mersed (R.A.)\n280. Seyyiduna Mistah ibn-i Üsase (R.A.)\n'
            '281. Seyyidüna Mes\'üd ibn-i Evs (R.A.)\n282. Seyyidüna Mes\'üd ibn-i Halde (R.A.)\n'
            '283. Seyyidüna Mes\'üd ibn-i Rebia (R.A.)\n284. Seyyidüna Mes\'üd ibn-i Zeyd (R.A.)\n'
            '285. Seyyidüna Mes\'üd ibn-i Sa\'d (R.A.)\n286. Seyyidüna Mes\'üd ibn-i Sa\'d (R.A.)\n'
            '287. Seyyidüna Mus\'ab ibn-i Umeyr (R.A.)\n288. Seyyidüna Muaz ibn-i Cebel (R.A.)\n'
            '289. Seyyidüna Muaz ibn-i Haris (R.A.)\n290. Seyyidüna Muaz ibn-üs Sımme (R.A.)\n'
            '291. Seyyidüna Muaz ibn-i Amr (R.A.)\n292. Seyyidüna Muaz ibn-i Maıs (R.A.)\n'
            '293. Seyyidüna Ma\'bed ibn-i Abbad (R.A.)\n294. Seyyidüna Ma\'bed ibn-i Kays (R.A.)\n'
            '295. Seyyidüna Muattib ibn-i Ubeyd (R.A.)\n296. Seyyidüna Muattib ibn-i Avf (R.A.)\n'
            '297. Seyyidüna Muattib ibn-i Kuşeyr (R.A.)\n298. Seyyidüna Ma\'kıl ibn-i Munzir (R.A.)\n'
            '299. Seyyidüna Ma\'mer ibn-i Haris (R.A.)\n300. Seyyidüna Ma\'n ibn-i Adiyy (R.A.)\n'
            '301. Seyyidüna Ma\'n ibn-i Yezîd (R.A.)\n302. Seyyidüna Muavviz ibn-i Haris (R.A.)\n'
            '303. Seyyidüna Muavviz ibn-i Amr (R.A.)\n304. Seyyidüna Mikdad ibn\'ül-Esved (R.A.)\n'
            '305. Seyyidüna Muleyl ibn-i Vebre (R.A.)\n306. Seyyidüna Münzir ibn-i Amr (R.A.)\n'
            '307. Seyyiduna Münzir ibn-i Kudame (R.A.)\n308. Seyyidüna Münzir ibn-i Muhammed (R.A.)\n'
            '309. Seyyidüna Mıhça\' ibn\'üs-Salih (R.A.) (ŞEHİD)\n310. Seyyidüna Nadr ibn-i Haris (R.A.)\n'
            '311. Seyyidüna Nu\'man ibn-i el-A\'rac (R.A.)\n312. Seyyidüna Nu\'man ibn-i Ebi Hazme (R.A.)\n'
            '313. Seyyidüna Nu\'man ibn-i Sinan (R.A.)\n314. Seyyidüna Nu\'man ibn-i Abd-i Amr (R.A.)\n'
            '315. Seyyidüna Nu\'man ibn-i Amr (R.A)\n316. Seyyidüna Nu\'man ibn-i Malik (R.A.)\n'
            '317. Seyyidüna Nevfel ibn-i Abdullah (R.A.)\n318. Seyyidüna Vakıd ibn-i Abdullah (R.A.)\n'
            '319. Seyyidüna Varaka bin İyas (R.A)\n320. Seyyidüna Vedia bin Amr (R.A.)\n'
            '321. Seyyiduna Vehb ibn-i Ebî Şerh (R.A.)\n322. Seyyidüna Vehb ibn-i Sa\'d (R.A.)\n'
            '323. Seyyidüna Hanî\'bin\'Niyar (R.A.)\n324. Seyyidüna Hübeyl ibn-i Vebre (R.A.)\n'
            '325. Seyyidüna Hilal ibn-i Mualla (R.A.)\n326. Seyyidüna Yezid ibn-i el-Ahnes (R.A.)\n'
            '327. Seyyidüna Yezîd ibn-i Rukayş (R.A.)\n328. Seyyidüna Yezidi ibn-i Haram (R.A.)\n'
            '329. Seyyidüna Yezîd ibn\'ül-Haris (R.A.)\n330. Seyyidüna Yezîd ibn\'üs-Seken (R.A.)\n'
            '331. Seyyidüna Yezid ibn\'ül-Münzir (R.A.)\n\n(RADIYALLAHU ANHUM ECMAİN)',
      ),
      IslamicInfoItem(
        title: 'Müjde ve Vasiyet',
        content:
            'Cafer b. Abdullah şöyle diyor: "Babam bana Peygamber (asm)\'in bütün ashabını sevmemi '
            'vasiyet eder ve şunu ilave ederdi: \'Ey canım yavrum, Bedir ashabının adı zikr edilince '
            'duâ kabul olunur, bu mübarek isimleri zikreden kulu, ilâhi rahmet; bereket gufran ve '
            'rızâ-ı İlâhî kuşatır. Bu isimleri okuyarak hacetde bulunanın dileği mutlaka yerine getirilir...\' "',
      ),
    ],
  ),
  IslamicInfo(
    title: 'Abdest Alırken Okunacak Dualar',
    subtitle: 'Her uzvu yıkarken okunacak manevi muhafaza duaları',
    icon: Icons.water_drop_rounded,
    color: Colors.blueAccent,
    items: [
      IslamicInfoItem(
        title: 'Eller Yıkanırken',
        content:
            'Ya Rabbi! Hasetlikten, cimrilikten ve bahillikten beni muhafaza eyle.',
      ),
      IslamicInfoItem(
        title: 'Ağız Yıkanırken (Mazmaza)',
        content:
            'Ya Rabbi! Dedikodudan, gıybetten ve kötü sözden beni muhafaza eyle.',
      ),
      IslamicInfoItem(
        title: 'Burun Yıkanırken (İstinşak)',
        content: 'Ya Rabbi! Gururdan, kibirden ve riyadan beni muhafaza eyle.',
      ),
      IslamicInfoItem(
        title: 'Yüz Yıkanırken',
        content:
            'Ya Rabbi! Kimi yüzlerin kararacağı günde sen yüzümü aydınlat.',
      ),
      IslamicInfoItem(
        title: 'Sağ Kol Yıkanırken',
        content: 'Ya Rabbi! Beni kitabını sağından alanlardan eyle.',
      ),
      IslamicInfoItem(
        title: 'Sol Kol Yıkanırken',
        content:
            'Ya Rabbi! Beni kitabını solundan ve arkasından alanlardan eyleme.',
      ),
      IslamicInfoItem(
        title: 'Baş Mesh Edilirken',
        content:
            'Ya Rabbi! Güneş bir mızrak indiğinde, gölgende serinleteceğin 7 zümreden birine girebilmeyi bana nasib eyle.',
      ),
      IslamicInfoItem(
        title: 'Kulaklar Mesh Edilirken',
        content: 'Ya Rabbi! Duyduklarımla amel edebilmeyi nasib eyle.',
      ),
      IslamicInfoItem(
        title: 'Boyun Mesh Edilirken',
        content:
            'Ya Rabbi! Sen bize şah damarımızdan daha yakınsın, bunun idrakine varabilmeyi bana nasib eyle.',
      ),
      IslamicInfoItem(
        title: 'Ayaklar Yıkanırken',
        content:
            'Ya Rabbi! Beni Sırât-ı Müstakîm’den ayırma, sırat köprüsünde ayağımı kaydırma, ayağımı sabit eyle.',
      ),
      IslamicInfoItem(
        title: 'Sakallar Hilallenirken',
        content: 'Allah’ım! Abdestimi nur eyle.',
      ),
    ],
  ),
  IslamicInfo(
    title: 'Cüveyriye Vâlidemiz\'in Zikri',
    subtitle: 'Sevabı sabah zikirlerine bedel dört cümle',
    icon: Icons.timer_rounded,
    color: Colors.lightBlue,
    items: [
      IslamicInfoItem(
        title: 'Hayırlı Bir Tartılma',
        content:
            'Peygamber Efendimiz, Cüveyriye vâlidemize şöyle buyurdu: "Yanından ayrıldıktan sonra üç defa söylediğim şu dört cümle, senin sabahtan beri söylediğin zikirlerle tartılacak olsa, sevap bakımından onlara eşit olur:\n\n'
            'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ عَدَدَ خَلْقِهِ وَرِضَا نَفْسِهِ وَزِنَةَ عَرْشِهِ وَمِدَادَ كَلِمَاتِهِ\n\n'
            'Meali: Mahlûkâtı sayısınca, kendisinin hoşnud olacağı kadar, Arş\'ının ağırlığınca ve bitip tükenmeyen kelimeleri adedince Allâh\'ı ulûhiyet makâmına yakışmayan bütün noksan sıfatlardan tenzîh eder ve O\'na hamd ederim."',
      ),
    ],
  ),
  IslamicInfo(
    title: 'Cennet Müjdeli Günlük Tesbih',
    subtitle: 'Cennetteki yerini görmeden vefat etmeme müjdesi',
    icon: Icons.stars_rounded,
    color: Color.fromARGB(255, 255, 193, 7),
    items: [
      IslamicInfoItem(
        title: 'Güzel Bir Müjde',
        content:
            'Bir kimse her gün bir kere:\n\n'
            '"Subhanellahil kaimid daim, Subhanellahil hayyil kayyum, Subhanellahil Hayyillezi Lâ yemûtu, Subhanellahil azimi bi hamdihi, Subbûhun, kuddûsun Rabbül Melaiketi verruhi, Subhanel aliyyil a\'la, subhanehu ve teala"\n\n'
            'derse Cennetten yerini görmeden veya onun için başkası görmeden vefat etmez.\n\n'
            '(Ramuz el e-hadis, 436. sayfa, 4. hadis)',
      ),
    ],
  ),
  IslamicInfo(
    title: 'Nuh Aleyhisselam’ın Duası ve İstiğfar',
    subtitle: 'Rızık, bolluk ve mağfiret ayetleri',
    icon: Icons.roofing_rounded,
    color: Colors.purple,
    items: [
      IslamicInfoItem(
        title: 'İstiğfarın Bereketi (Nuh 10-12)',
        content:
            'فَقُلْتُ اسْتَغْفِرُوا رَبَّكُمْ اِنَّهُ كَانَ غَفَّارًا ﴿١٠﴾ يُرْسِلِ السَّمَاءَ عَلَيْكُمْ مِدْرَارًا ﴿١١﴾ وَيُمْدِدْكُمْ بِاَمْوَالٍ وَبَن۪ينَ وَيَجْعELْ لَكُمْ جَنَّاتٍ وَيَجْعَلْ لَكُمْ اَنْهَارًا ﴿١٢﴾\n\n'
            'Okunuşu:\n'
            '10. "Fekultü-stagfirû rabbeküm innehû kâne gaffârâ(n)."\n'
            '11. "Yursili-ssemâe \'aleyküm midrârâ(n)."\n'
            '12. "Ve yumdidküm bi-emvâlin ve benîne ve yec\'al leküm cennâtin ve yec\'al leküm enhârâ(n)."\n\n'
            'Meali: 10: Onlara dedim ki: "Rabbinizden bağışlanma dileyin! Çünkü O, günahları çokça bağışlayıcıdır."\n'
            '11: "Bağışlanma dileyin ki üzerinize bol bol yağmur yağdırsın."\n'
            '12: "Mallarınızı, evlatlarınızı çoğaltsın, size bağlar, bahçeler versin, sizin için ırmaklar akıtsın."',
      ),
      IslamicInfoItem(
        title: 'Nuh Suresi 28. Ayet (Ev Duası)',
        content:
            'رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ وَلِمَنْ دَخَلَ بَيْتِيَ مُؤْمِناً وَلِلْمُؤْمِنِينَ وَالْمُؤْمِنَاتِ وَلَا تَزِدِ الظَّالِمِينَ إِلَّا تَبَاراً\n\n'
            'Okunuşu: "Rabbigfirlî ve li vâlideyye ve li men dehale beytiye mu’minen ve lil mu’minîne vel mu’minât ve lâ tezidiz zâlimîne illâ tebârâ."\n\n'
            'Anlamı: "Rabbim! Beni, ana-babamı, iman etmiş olarak evime girenleri, iman eden erkekleri ve iman eden kadınları bağışla, zalimlerin de ancak helâkini arttır."',
      ),
    ],
  ),
  IslamicInfo(
    title: 'Kehf Suresi 2. Ayet (Müjde)',
    subtitle: 'Müminler için güzel bir karşılık müjdesi',
    icon: Icons.bookmark_added_rounded,
    color: Colors.teal,
    items: [
      IslamicInfoItem(
        title: 'Kehf Suresi 2. Ayet',
        content:
            'قَيِّمًا لِيُنْذِرَ بَأْسًا شَدِيدًا مِنْ لَدُنْهُ وَيُبَشِّرَ الْمُؤْمِنِينَ الَّذِينَ يَعْمَلُونَ الصَّالِحَاتِ أَنَّ لَهُمْ أَجْرًا حَسَنًا\n\n'
            'Okunuşu: Kayyimen li yunzire be\'sen şediden min ledunhu ve yubeşşirel mu\'mininnellezine ya\'melunes salihati enne lehum ecren hasena.\n\n'
            'Meali: Dosdoğru bir gözetici olarak; şiddetli azaba karşı uyarmak, erdemli ve doğru davranışlarda bulunan Mü\'minlere, en iyi karşılığın onların olduğunu müjdelemek için katından indirdi.',
      ),
    ],
  ),
  IslamicInfo(
    title: 'Seyyidü’l-İstiğfar',
    subtitle: 'Tövbelerin efendisi ve en kapsamlı af duası',
    icon: Icons.security_rounded,
    color: Colors.teal,
    items: [
      IslamicInfoItem(
        title: 'İstiğfarların Efendisi',
        content:
            'اللَّهُمَّ أَنْتَ رَبِّي لاَ إِلَهَ إِلاَّ أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ mih مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِيمَتِكَ عَلَيَّ، وَأَبُوءُ لَكَ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لاَ يَغْفِرُ الذُّنُوبَ إِلاَّ أَنْتَ\n\n'
            'Okunuşu: "Allâhümme ente Rabbî lâ ilâhe illâ ente halaktenî ve ene abdüke ve ene alâ ahdike ve vâ\'dike mesteda\'tü eûzü bike min şerri mâ sana\'tü ebû ü leke bi-ni\'metike aleyye ve ebû ü bi zenbî fağfirlî fe innehû lâ yağfiruz-zünûbe illâ ente."\n\n'
            'Anlamı: «Allah’ım! Sen benim Rabbimsin. Sen’den başka ibâdete lâyık ilâh yoktur. Beni Sen yarattın. Ben Sen’in kulunum. Ezelde Sana verdiğim sözümde ve vaadimde hâlâ gücüm yettiğince durmaktayım. İşlediğim kusurların şerrinden Sana sığınırım. Bana lutfettiğin nîmetleri yüce huzûrunda minnetle anar, günâhımı îtirâf ederim. Beni affet, şüphe yok ki günahları Sen’den başka affedecek yoktur.»',
      ),
    ],
  ),
  IslamicInfo(
    title: 'Mahlukatın Şerrinden Korunma (Ev Duası)',
    subtitle: 'Gidilen yerlerde ve müstakil alanlarda okunacak muhafaza',
    icon: Icons.home_rounded,
    color: Colors.deepOrange,
    items: [
      IslamicInfoItem(
        title: 'Konaklama ve Muhafaza Duası',
        content:
            'Peygamber Efendimiz (S.A.V.), mahlukatın şerrinden (zararlı hayvanlar, görünür-görünmez tehlikeler) korunmak için bu duayı tavsiye etmiştir:\n\n'
            'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ\n\n'
            'Okunuşu: "Euzü bi kelimatillahit-tammati min şerri ma halak"\n\n'
            'Anlamı: "Yarattığı şeylerin şerrinden Allah’ın tam olan kelimelerine sığınırım."',
      ),
    ],
  ),
];

// ── Ana Sayfa (Liste Kartları) ─────────────────────────────────────────────

class IslamicInfoPage extends StatefulWidget {
  const IslamicInfoPage({super.key});

  @override
  State<IslamicInfoPage> createState() => _IslamicInfoPageState();
}

class _IslamicInfoPageState extends State<IslamicInfoPage> {
  String _query = '';
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  List<IslamicInfo> get _filtered {
    final q = _query.toLowerCase().trim();
    if (q.isEmpty) return _infos;
    return _infos.where((info) {
      return info.title.toLowerCase().contains(q) ||
          info.subtitle.toLowerCase().contains(q) ||
          info.items.any(
            (item) =>
                item.title.toLowerCase().contains(q) ||
                item.content.toLowerCase().contains(q),
          );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    setState(() => _query = '');
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return GestureDetector(
      onTap: _focusNode.unfocus,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          title: Text(
            "Sohbet Notları & İslami Bilgiler",
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.accent,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
        ),
        body: Column(
          children: [
            // Arama Kutusu
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: (v) => setState(() => _query = v),
                  style: AppTextStyles.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Bilgi veya konu ara…',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textHint,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: AppColors.textSecondary,
                              size: 18,
                            ),
                            onPressed: _clearSearch,
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            Expanded(
              child: filtered.isEmpty
                  ? _EmptyState(query: _query)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => _MainMenuCard(info: filtered[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Liste Kartı ─────────────────────────────────────────────────────────────

class _MainMenuCard extends StatelessWidget {
  const _MainMenuCard({required this.info});
  final IslamicInfo info;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => _IslamicInfoDetailPage(info: info),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: info.color.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: info.color.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: info.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(info.icon, color: info.color, size: 28),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(info.title, style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 4),
                  Text(
                    info.subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: info.color.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Detay Sayfası (Tek Parça Hali) ───────────────────────────────────────────

class _IslamicInfoDetailPage extends StatefulWidget {
  const _IslamicInfoDetailPage({required this.info});
  final IslamicInfo info;

  @override
  State<_IslamicInfoDetailPage> createState() => _IslamicInfoDetailPageState();
}

class _IslamicInfoDetailPageState extends State<_IslamicInfoDetailPage> {
  String _query = '';
  late final TextEditingController _controller;

  List<IslamicInfoItem> get _filteredItems {
    if (_query.isEmpty) return widget.info.items;
    return widget.info.items.where((item) {
      return item.title.toLowerCase().contains(_query.toLowerCase()) ||
          item.content.toLowerCase().contains(_query.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Gelişmiş Header
          SliverAppBar(
            expandedHeight: 100, // 120'den düşürüldü
            floating: false,
            pinned: true,
            backgroundColor: AppColors.surface,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                widget.info.title,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: widget.info.color,
                ),
              ),
            ),
          ),

          // Arama Çubuğu
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: TextField(
                  controller: _controller,
                  onChanged: (v) => setState(() => _query = v),
                  style: AppTextStyles.bodyMedium,
                  decoration: const InputDecoration(
                    hintText: 'Başlık veya içerik ara…',
                    prefixIcon: Icon(Icons.search_rounded, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ),

          // Tek Parça İçerik Bloğu
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Column(
                  children: List.generate(filtered.length, (index) {
                    final item = filtered[index];
                    final isLast = index == filtered.length - 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.md, // xl'den md'ye düşürüldü
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (item.count != null) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: widget.info.color.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        item.count!,
                                        style: AppTextStyles.labelSmall
                                            .copyWith(
                                              color: widget.info.color,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                  ],
                                  Expanded(
                                    child: _HighlightText(
                                      text: item.title,
                                      query: _query,
                                      style: AppTextStyles.headlineSmall
                                          .copyWith(
                                            color: widget.info.color,
                                            fontWeight: FontWeight.w700,
                                          ),
                                      highlightColor: widget.info.color,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: AppSpacing.sm,
                              ), // lg'den sm'ye düşürüldü
                              _HighlightText(
                                text: item.content,
                                query: _query,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  height: 1.6,
                                  color: AppColors.onBackground.withValues(
                                    alpha: 0.85,
                                  ),
                                ),
                                highlightColor: widget.info.color,
                              ),
                            ],
                          ),
                        ),
                        if (!isLast)
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.border.withValues(alpha: 0.5),
                            indent: AppSpacing.lg,
                            endIndent: AppSpacing.lg,
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
        ],
      ),
    );
  }
}

// ── Diğer Yardımcı Widget'lar ───────────────────────────────────────────────

class _HighlightText extends StatelessWidget {
  const _HighlightText({
    required this.text,
    required this.query,
    required this.style,
    required this.highlightColor,
  });

  final String text;
  final String query;
  final TextStyle style;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    if (query.trim().isEmpty) return Text(text, style: style);

    final q = query.toLowerCase().trim();
    final lower = text.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final idx = lower.indexOf(q, start);
      if (idx == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx)));
      }
      spans.add(
        TextSpan(
          text: text.substring(idx, idx + q.length),
          style: TextStyle(
            backgroundColor: highlightColor.withValues(alpha: 0.2),
            color: highlightColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      start = idx + q.length;
    }

    return RichText(
      text: TextSpan(style: style, children: spans),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '"$query" için sonuç bulunamadı.',
            style: AppTextStyles.bodyLarge,
          ),
        ],
      ),
    );
  }
}
