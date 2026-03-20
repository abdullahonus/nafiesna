import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../product/constants/app_spacing.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/widget/quran/quran_text_view.dart';

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
  IslamicInfoItem({required this.title, required this.content, this.count});

  final String title;
  final String content;
  final String? count;
}

// ── Ana Sayfa (Liste Kartları) ─────────────────────────────────────────────

class IslamicInfoPage extends StatefulWidget {
  const IslamicInfoPage({super.key});

  @override
  State<IslamicInfoPage> createState() => _IslamicInfoPageState();

  static List<IslamicInfo> getIslamicInfos(BuildContext context) {
    return [
      IslamicInfo(
        title: 'Âl-i İmrân 18–27',
        subtitle: 'Yatsı sonrası okunan âyetler ve faziletleri',
        icon: Icons.menu_book_rounded,
        color: context.colors.primary,
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
                'اِنَّ الدّ۪ينَ عِنْدَ اللّٰهِ الْاِسْلَامُۙ وَمَا اخْتَلَفَ ELَّذ۪ينَ اُو۬تُوا الْكِتَابَ اِلَّا مِنْ بَعْدِ مَا جَآءَهُمُ الْعِلْمُ بَغْيًا بَيْنَهُمْۜ وَمَنْ يَكْفُرْ بِاٰيَاتِ اللّٰهِ فَاِنَّ اللّٰهَ سَر۪يعُ الْحِسَابِ\n\n'
                'Okunuşu: İnned dîne indâllâhil islâm(islâmu), ve mâhtelefellezîne ûtûl kitâbe illâ min ba’di mâ câehumul ilmu bagyen beynehum, ve men yekfur bi âyâtillâhi fe innallâhe serîul hısâb(hısâbu).\n\n'
                'Meali: Şüphesiz Allah katında din İslâm\'dır. Kitap verilmiş olanlar, kendilerine ilim geldikten sonra sırf aralarındaki ihtiras ve aşırılık yüzünden ayrılığa düştüler. Kim Allah\'ın âyetlerini inkâr ederse, bilsin ki Allah hesabı çok çabuk görendir.',
          ),
          IslamicInfoItem(
            title: 'Âl-i İmrân 27. Ayet (Rızık Ayeti)',
            content:
                'تُولِجُ الَّيْلَ فِي النَّهَارِ وَتُولِجُ النَّهَارَ فِي الَّيْلِ وَتُخْرِجُ الْحَيَّ مِنَ الْمَيِّتِ وَتُخْرِجُ الْمَيِّتَ مِنَ الْحيِّ وَتَرْزُقُ مَنْ تَشَاءُ بِغَيْرِ حِسَابٍ\n\n'
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
        color: context.colors.accent,
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
            content:
                'Allâhümme inneke afüvvün kerîmün\ntühibbül afve fa\'fü annî',
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
        color: const Color.fromARGB(255, 253, 144, 1),
        items: [
          IslamicInfoItem(
            title: 'Nur Suresi 35. Ayet',
            content:
                'اَللّٰهُ نُورُ السَّمٰوَاتِ وَالْاَرْضِۜ مَثَلُ نُورِه۪ كَمِشْكٰوةٍ ف۪يهَا مِصْبَاحٌۜ '
                'اَلْمِصْبَاحُ f۪ي زُجَاجَةٍۜ اَلزُّجَاجَةُ كَاَنَّهَا كَوْكَبٌ دُرِّيٌّ يُوقَدُ مِنْ شَجَرَةٍ مُBَارَكَةٍ '
                'زَيْتُونَةٍ لَا شَرْقِيَّةٍ وَلَا غَرْBِيَّةٍۙ يَكَادُ زَيْتُهَا يُض۪ٓيءُ وَلَوْ لEMْ تEMْسَسْهُ نَارٌۜ '
                'نُورٌ عَلٰى نُورٍۜ يَهْدِي اللّٰهُ لِنُورِه۪ مَنْ يَشَٓاءُۜ وَيَضْرِبُ اللّٰهُ الْاَمْثَالَ لِلNَّاسِۜ '
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
                'قَالَ رَبِّ اِنّ۪ٓي اَعُوذُ بِكَ اَنْ اَسْـَٔلَكَ مَا لَيْسَ ل۪ي بِه۪ عِلMٌۜ وَاِلَّا تَغْفِرْ ل۪ي '
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
        color: const Color.fromARGB(255, 56, 142, 60),
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
        color: const Color.fromARGB(255, 121, 85, 72),
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
            content: 'İsimler buraya gelecek...',
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
        color: const Color.fromARGB(255, 255, 193, 7),
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
                'فَقُلْتُ اسْتَغْفِرُوا رَبَّكُمْ اِنَّهُ كَانَ غَفَّارًا ﴿١٠﴾ يُرْسِلِ السَّمَاءَ عَلَيْكُمْ مِدْرَارًا ﴿١١﴾ وَيMْدِدْكُمْ بِاEMْوَALٍ وَبEN۪ينَ وَيَجْعELْ لَكُمْ جَنَّاتٍ وَيَجْعَلْ لَكُمْ اَنْهَارًا ﴿١٢﴾\n\n'
                'Okunuşu:\n10. "Fekultü-stagfirû rabbeküm innehû kâne gaffârâ(n)."\n11. "Yursili-ssemâe \'aleyküm midrârâ(n)."\n12. "Ve yumdidküm bi-emvâlin ve benîne ve yec\'al leküm cennâtin ve yec\'al leküm enhârâ(n)."\n\n'
                'Meali: 10: Onlara dedim ki: "Rabbinizden bağışlanma dileyin! Çünkü O, günahları çokça bağışlayıcıdır."\n11: "Bağışlanma dileyin ki üzerinize bol bol yağmur yağdırsın."\n12: "Mallarınızı, evlatlarınızı çoğaltsın, size bağlar, bahçeler versin, sizin için ırmaklar akıtsın."',
          ),
          IslamicInfoItem(
            title: 'Nuh Suresi 28. Ayet (Ev Duası)',
            content:
                'رَبِّ اغْفِرْ لِي وَلِوَALِدَيَّ وَلِمَنْ دَخَلَ بَيْتِيَ مُؤْمِناً وَلِلْمُؤْمِنِينَ وَالْمُؤْمِنَاتِ وَلَا تَزِدِ الظَّالِمِينَ إِلَّا تَبَاراً\n\n'
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
                'اللَّهُمَّ أَنْتَ رَبِّي لاَ إِلَهَ إِلاَّ أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعTÜ، أَعُوذُ بِكَ مِنْ شَرِّ mih مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِيمَتِكَ عَلَيَّ، وَأَبُوءُ لَكَ بِذَنْBِي فَاغْفِرْ لِي فَاِنَّهُ لاَ يَغْفِرُ الذُّنُOBَ إِلاَّ أَنْتَ\n\n'
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
  }
}

class _IslamicInfoPageState extends State<IslamicInfoPage> {
  String _query = '';
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  List<IslamicInfo> get _filtered {
    final infos = IslamicInfoPage.getIslamicInfos(context);
    final q = _query.toLowerCase().trim();
    if (q.isEmpty) return infos;
    return infos.where((info) {
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
        backgroundColor: context.colors.background,
        appBar: AppBar(
          backgroundColor: context.colors.surface,
          elevation: 0.5,
          title: Text(
            "Sohbet Notları & İslami Bilgiler",
            style: context.textTheme.headlineSmall?.copyWith(
              color: context.colors.accent,
              fontWeight: FontWeight.bold,
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
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: context.colors.border, width: 0.5),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: (v) => setState(() => _query = v),
                  style: context.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Bilgi veya konu ara…',
                    hintStyle: context.textTheme.bodyMedium?.copyWith(
                      color: context.colors.textHint,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: context.colors.textSecondary,
                      size: 20,
                    ),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: context.colors.textSecondary,
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

class _MainMenuCard extends StatelessWidget {
  const _MainMenuCard({required this.info});
  final IslamicInfo info;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      color: context.colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(color: context.colors.border, width: 0.5),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => _IslamicInfoDetailPage(info: info),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: info.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(info.icon, color: info.color, size: 24),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.title,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      info.subtitle,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: context.colors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IslamicInfoDetailPage extends StatefulWidget {
  const _IslamicInfoDetailPage({required this.info});
  final IslamicInfo info;

  @override
  State<_IslamicInfoDetailPage> createState() => _IslamicInfoDetailPageState();
}

class _IslamicInfoDetailPageState extends State<_IslamicInfoDetailPage> {
  String _query = '';

  List<IslamicInfoItem> get _filteredItems {
    final q = _query.toLowerCase().trim();
    if (q.isEmpty) return widget.info.items;
    return widget.info.items.where((item) {
      return item.title.toLowerCase().contains(q) ||
          item.content.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: widget.info.color,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.info.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            color: widget.info.color,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'İçerikte ara...',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _InfoItemCard(
                  item: item,
                  color: widget.info.color,
                  searchQuery: _query,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItemCard extends StatelessWidget {
  const _InfoItemCard({
    required this.item,
    required this.color,
    required this.searchQuery,
  });

  final IslamicInfoItem item;
  final Color color;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      color: context.colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(color: context.colors.border, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _HighlightText(
                    text: item.title,
                    query: searchQuery,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    highlightColor: color.withValues(alpha: 0.2),
                  ),
                ),
                if (item.count != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.count!,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const Divider(height: 24),
            _HighlightText(
              text: item.content,
              query: searchQuery,
              style: context.textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: context.colors.onBackground,
              ),
              highlightColor: color.withValues(alpha: 0.2),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightText extends StatelessWidget {
  const _HighlightText({
    required this.text,
    required this.query,
    required this.style,
    required this.highlightColor,
  });

  final String text;
  final String query;
  final TextStyle? style;
  final Color highlightColor;

  bool _isArabic(String text) {
    if (text.isEmpty) return false;
    // Arapça karakter aralığı (yaygın kullanılanlar)
    final arabicRegExp = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]');
    return arabicRegExp.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    // 1. Yazıyı satırlara veya bölümlere ayırabiliriz.
    // Ancak daha basiti: Eğer satır tamamen Arapça ise veya Arapça baskınsa o kısmı özel işle.
    // IslamicInfo içindeki içerikler genellikle: [Arapça] \n\n [Okunuşu] \n\n [Meali] şeklinde.
    
    final lines = text.split('\n');
    final allSpans = <InlineSpan>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.trim().isEmpty) {
        allSpans.add(const TextSpan(text: '\n'));
        continue;
      }

      if (_isArabic(line)) {
        // Arapça Satırı - Scholarly Style
        final arabicStyle = GoogleFonts.scheherazadeNew(
          fontSize: (style?.fontSize ?? 14) * 1.5,
          height: 1.8,
          color: style?.color ?? context.colors.onBackground,
        );
        allSpans.addAll(processArabicText(line, arabicStyle));
      } else {
        // Normal Satır - Highlight Logic
        allSpans.addAll(_getHighlightedSpans(line, query, style, highlightColor));
      }

      if (i < lines.length - 1) {
        allSpans.add(const TextSpan(text: '\n'));
      }
    }

    return RichText(
      textAlign: _isArabic(text) ? TextAlign.right : TextAlign.left,
      textDirection: _isArabic(text) ? TextDirection.rtl : TextDirection.ltr,
      text: TextSpan(children: allSpans, style: style),
    );
  }

  List<TextSpan> _getHighlightedSpans(
    String text,
    String query,
    TextStyle? style,
    Color highlightColor,
  ) {
    if (query.isEmpty) return [TextSpan(text: text, style: style)];

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    var start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start), style: style));
        break;
      }

      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index), style: style));
      }

      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: (style ?? const TextStyle()).copyWith(backgroundColor: highlightColor),
      ));

      start = index + query.length;
    }
    return spans;
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
          Icon(Icons.search_off_rounded, size: 64, color: context.colors.textHint),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Sonuç bulunamadı',
            style: context.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            '"$query" ifadesine uygun bilgi bulunamadı.',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
