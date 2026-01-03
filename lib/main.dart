import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  // 私は、初期化エラーを防ぐためにあえてシンプルな起動順序にしました
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SpanishMasterApp());
}

class Word {
  final int id;
  final String sp;
  final String jp;
  final IconData icon;
  final String category;
  Word(
      {required this.id,
      required this.sp,
      required this.jp,
      required this.icon,
      required this.category});
}

class SpanishMasterApp extends StatelessWidget {
  const SpanishMasterApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spanish Master 1000',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CategorySelectScreen(),
    );
  }
}

// --- 私は「カテゴリ選択画面」を作成しました（検索機能付き） ---
class CategorySelectScreen extends StatefulWidget {
  const CategorySelectScreen({super.key});
  @override
  State<CategorySelectScreen> createState() => _CategorySelectScreenState();
}

class _CategorySelectScreenState extends State<CategorySelectScreen> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // 私は、重複を除いたカテゴリリストを取得します
    final allCategories = myWords.map((e) => e.category).toSet().toList();
    // 私は、検索ワードに合うカテゴリだけを表示します
    final filteredCategories =
        allCategories.where((c) => c.contains(_searchQuery)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías (カテゴリ選択)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'カテゴリを検索...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.folder, color: Colors.deepPurple),
                  title: Text(filteredCategories[index]),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WordListScreen(category: filteredCategories[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WordListScreen extends StatefulWidget {
  final String category;
  const WordListScreen({super.key, required this.category});
  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  final FlutterTts _tts = FlutterTts();
  final Set<int> _favorites = {};
  final Set<int> _revealedIds = {};

  @override
  void initState() {
    super.initState();
    _setupTts();
  }

  void _setupTts() async {
    await _tts.setLanguage("es-ES");
    await _tts.setSpeechRate(1.0); // 私は、ご要望通り2倍速（1.0）に設定しました
  }

  void _speakAndReveal(Word word) async {
    setState(() => _revealedIds.add(word.id));
    await _tts.speak(word.sp);
  }

  @override
  Widget build(BuildContext context) {
    final displayWords =
        myWords.where((w) => w.category == widget.category).toList();

    return Scaffold(
      appBar: AppBar(title: Text('${widget.category} 練習')),
      body: ListView.builder(
        itemCount: displayWords.length,
        itemBuilder: (context, index) {
          final word = displayWords[index];
          final isRevealed = _revealedIds.contains(word.id);
          final isFav = _favorites.contains(word.id);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Icon(word.icon, size: 35, color: Colors.deepPurple),
              title: Text(
                isRevealed ? word.sp : "タップして発音を表示", // 私は最初は隠します
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isRevealed ? Colors.deepPurple : Colors.grey[400]),
              ),
              subtitle: Text(word.jp), // 私は日本語を露出させます
              trailing: IconButton(
                icon: Icon(isFav ? Icons.star : Icons.star_border,
                    color: isFav ? Colors.orange : null),
                onPressed: () => setState(() => isFav
                    ? _favorites.remove(word.id)
                    : _favorites.add(word.id)),
              ),
              onTap: () => _speakAndReveal(word),
            ),
          );
        },
      ),
    );
  }
}

// --- 💡 私は、ここにデータを貼り付けてください！ ---
final List<Word> myWords = [
  Word(id: 1, sp: "Hola", jp: "こんにちは", icon: Icons.waving_hand, category: "挨拶"),
  Word(id: 2, sp: "Gracias", jp: "ありがとう", icon: Icons.thumb_up, category: "挨拶"),
  Word(
      id: 3, sp: "Adiós", jp: "さようなら", icon: Icons.exit_to_app, category: "挨拶"),
  Word(id: 4, sp: "Sí", jp: "はい", icon: Icons.check_circle, category: "基本"),
  Word(id: 5, sp: "No", jp: "いいえ", icon: Icons.cancel, category: "基本"),
  Word(
      id: 6,
      sp: "Perdón",
      jp: "ごめんなさい",
      icon: Icons.sentiment_dissatisfied,
      category: "挨拶"),
  Word(
      id: 7,
      sp: "Por favor",
      jp: "お願いします",
      icon: Icons.volunteer_activism,
      category: "基本"),
  Word(id: 8, sp: "Agua", jp: "水", icon: Icons.local_drink, category: "飲食"),
  Word(id: 9, sp: "Pan", jp: "パン", icon: Icons.bakery_dining, category: "飲食"),
  Word(id: 10, sp: "Café", jp: "コーヒー", icon: Icons.coffee, category: "飲食"),
  Word(id: 11, sp: "Leche", jp: "牛乳", icon: Icons.water_drop, category: "飲食"),
  Word(id: 12, sp: "Arroz", jp: "お米", icon: Icons.rice_bowl, category: "飲食"),
  Word(id: 13, sp: "Carne", jp: "肉", icon: Icons.kebab_dining, category: "飲食"),
  Word(id: 14, sp: "Pescado", jp: "魚", icon: Icons.set_meal, category: "飲食"),
  Word(id: 15, sp: "Fruta", jp: "果物", icon: Icons.apple, category: "飲食"),
  Word(id: 16, sp: "Reloj", jp: "時計", icon: Icons.watch_later, category: "生活"),
  Word(id: 17, sp: "Libro", jp: "本", icon: Icons.menu_book, category: "生活"),
  Word(id: 18, sp: "Silla", jp: "椅子", icon: Icons.chair, category: "生活"),
  Word(
      id: 19,
      sp: "Mesa",
      jp: "机",
      icon: Icons.table_restaurant,
      category: "生活"),
  Word(id: 20, sp: "Cama", jp: "ベッド", icon: Icons.bed, category: "生活"),
  Word(id: 21, sp: "Llave", jp: "鍵", icon: Icons.vpn_key, category: "生活"),
  Word(id: 22, sp: "Dinero", jp: "お金", icon: Icons.payments, category: "生活"),
  Word(id: 23, sp: "Sol", jp: "太陽", icon: Icons.wb_sunny, category: "自然"),
  Word(
      id: 24,
      sp: "Luna",
      jp: "月",
      icon: Icons.nightlight_round,
      category: "自然"),
  Word(id: 25, sp: "Casa", jp: "家", icon: Icons.home, category: "場所"),
  Word(id: 26, sp: "Escuela", jp: "学校", icon: Icons.school, category: "場所"),
  Word(id: 27, sp: "Tienda", jp: "店", icon: Icons.storefront, category: "場所"),
  Word(id: 28, sp: "Avión", jp: "飛行機", icon: Icons.flight, category: "交通"),
  Word(id: 29, sp: "Tren", jp: "電車", icon: Icons.train, category: "交通"),
  Word(
      id: 30, sp: "Coche", jp: "車", icon: Icons.directions_car, category: "交通"),
  Word(id: 31, sp: "Comer", jp: "食べる", icon: Icons.restaurant, category: "動詞"),
  Word(id: 32, sp: "Beber", jp: "飲む", icon: Icons.local_bar, category: "動詞"),
  Word(id: 33, sp: "Dormir", jp: "眠る", icon: Icons.hotel, category: "動詞"),
  Word(
      id: 34,
      sp: "Hablar",
      jp: "話す",
      icon: Icons.record_voice_over,
      category: "動詞"),
  Word(id: 35, sp: "Leer", jp: "読む", icon: Icons.auto_stories, category: "動詞"),
  Word(id: 36, sp: "Escribir", jp: "書く", icon: Icons.edit_note, category: "動詞"),
  Word(id: 37, sp: "Ver", jp: "見る", icon: Icons.visibility, category: "動詞"),
  Word(id: 38, sp: "Escuchar", jp: "聞く", icon: Icons.hearing, category: "動詞"),
  Word(
      id: 39,
      sp: "Caminar",
      jp: "歩く",
      icon: Icons.directions_walk,
      category: "動詞"),
  Word(
      id: 40,
      sp: "Correr",
      jp: "走る",
      icon: Icons.directions_run,
      category: "動詞"),
  Word(
      id: 41,
      sp: "Feliz",
      jp: "幸せ",
      icon: Icons.sentiment_very_satisfied,
      category: "感情"),
  Word(
      id: 42,
      sp: "Triste",
      jp: "悲しい",
      icon: Icons.sentiment_very_dissatisfied,
      category: "感情"),
  Word(id: 43, sp: "Enojado", jp: "怒った", icon: Icons.mood_bad, category: "感情"),
  Word(
      id: 44,
      sp: "Cansado",
      jp: "疲れた",
      icon: Icons.battery_alert,
      category: "状態"),
  Word(id: 45, sp: "Bien", jp: "良い", icon: Icons.thumb_up_alt, category: "状態"),
  Word(id: 46, sp: "Mal", jp: "悪い", icon: Icons.thumb_down_alt, category: "状態"),
  Word(id: 47, sp: "Padre", jp: "父", icon: Icons.person, category: "家族"),
  Word(id: 48, sp: "Madre", jp: "母", icon: Icons.person_3, category: "家族"),
  Word(id: 49, sp: "Hermano", jp: "兄弟", icon: Icons.group, category: "家族"),
  Word(id: 50, sp: "Hermana", jp: "姉妹", icon: Icons.group, category: "家族"),
  Word(id: 51, sp: "Amigo", jp: "友達", icon: Icons.face, category: "家族"),
  Word(id: 52, sp: "Ojo", jp: "目", icon: Icons.remove_red_eye, category: "体"),
  Word(id: 53, sp: "Boca", jp: "口", icon: Icons.sensor_occupied, category: "体"),
  Word(id: 54, sp: "Mano", jp: "手", icon: Icons.back_hand, category: "体"),
  Word(
      id: 55,
      sp: "Pie",
      jp: "足",
      icon: Icons.pest_control_rodent,
      category: "体"),
  Word(
      id: 56,
      sp: "Cabeza",
      jp: "頭",
      icon: Icons.face_retouching_natural,
      category: "体"),
  Word(id: 57, sp: "Hoy", jp: "今日", icon: Icons.today, category: "時"),
  Word(id: 58, sp: "Ayer", jp: "昨日", icon: Icons.history, category: "時"),
  Word(id: 59, sp: "Mañana", jp: "明日", icon: Icons.wb_twilight, category: "時"),
  Word(id: 60, sp: "Ahora", jp: "今", icon: Icons.alarm_on, category: "時"),
  Word(id: 61, sp: "Manzana", jp: "りんご", icon: Icons.apple, category: "飲食"),
  Word(id: 62, sp: "Huevo", jp: "卵", icon: Icons.egg, category: "飲食"),
  Word(id: 63, sp: "Sal", jp: "塩", icon: Icons.grain, category: "飲食"),
  Word(
      id: 64, sp: "Azúcar", jp: "砂糖", icon: Icons.bubble_chart, category: "飲食"),
  Word(id: 65, sp: "Ropa", jp: "服", icon: Icons.checkroom, category: "衣服"),
  Word(
      id: 66,
      sp: "Zapatos",
      jp: "靴",
      icon: Icons.nordic_walking,
      category: "衣服"),
  Word(
      id: 67,
      sp: "Sombrero",
      jp: "帽子",
      icon: Icons.theater_comedy,
      category: "衣服"),
  Word(
      id: 68,
      sp: "Teléfono",
      jp: "電話",
      icon: Icons.phone_android,
      category: "生活"),
  Word(
      id: 69,
      sp: "Computadora",
      jp: "コンピュータ",
      icon: Icons.computer,
      category: "生活"),
  Word(id: 70, sp: "Ventana", jp: "窓", icon: Icons.window, category: "生活"),
  Word(
      id: 71,
      sp: "Grande",
      jp: "大きい",
      icon: Icons.zoom_out_map,
      category: "形容詞"),
  Word(id: 72, sp: "Pequeño", jp: "小さい", icon: Icons.zoom_in, category: "形容詞"),
  Word(id: 73, sp: "Nuevo", jp: "新しい", icon: Icons.fiber_new, category: "形容詞"),
  Word(id: 74, sp: "Viejo", jp: "古い", icon: Icons.restore, category: "形容詞"),
  Word(id: 75, sp: "Caliente", jp: "熱い", icon: Icons.whatshot, category: "形容詞"),
  Word(id: 76, sp: "Frío", jp: "冷たい", icon: Icons.ac_unit, category: "形容詞"),
  Word(
      id: 77, sp: "Caro", jp: "高い(値段)", icon: Icons.money_off, category: "形容詞"),
  Word(id: 78, sp: "Barato", jp: "安い", icon: Icons.savings, category: "形容詞"),
  Word(id: 79, sp: "Largo", jp: "長い", icon: Icons.straighten, category: "形容詞"),
  Word(
      id: 80,
      sp: "Corto",
      jp: "短い",
      icon: Icons.horizontal_rule,
      category: "形容詞"),
  Word(id: 81, sp: "Rojo", jp: "赤", icon: Icons.circle, category: "色"),
  Word(id: 82, sp: "Azul", jp: "青", icon: Icons.circle, category: "色"),
  Word(
      id: 83,
      sp: "Blanco",
      jp: "白",
      icon: Icons.circle_outlined,
      category: "色"),
  Word(id: 84, sp: "Negro", jp: "黒", icon: Icons.circle, category: "色"),
  Word(id: 85, sp: "Amarillo", jp: "黄色", icon: Icons.circle, category: "色"),
  Word(id: 86, sp: "Verde", jp: "緑", icon: Icons.circle, category: "色"),
  Word(id: 87, sp: "Lluvia", jp: "雨", icon: Icons.umbrella, category: "天気"),
  Word(
      id: 88, sp: "Nieve", jp: "雪", icon: Icons.cloudy_snowing, category: "天気"),
  Word(id: 89, sp: "Viento", jp: "風", icon: Icons.air, category: "天気"),
  Word(id: 90, sp: "Nube", jp: "雲", icon: Icons.cloud, category: "天気"),
  Word(
      id: 91,
      sp: "Lunes",
      jp: "月曜日",
      icon: Icons.calendar_view_day,
      category: "曜日"),
  Word(
      id: 92,
      sp: "Martes",
      jp: "火曜日",
      icon: Icons.calendar_view_day,
      category: "曜日"),
  Word(
      id: 93,
      sp: "Miércoles",
      jp: "水曜日",
      icon: Icons.calendar_view_day,
      category: "曜日"),
  Word(
      id: 94,
      sp: "Jueves",
      jp: "木曜日",
      icon: Icons.calendar_view_day,
      category: "曜日"),
  Word(
      id: 95,
      sp: "Viernes",
      jp: "金曜日",
      icon: Icons.calendar_view_day,
      category: "曜日"),
  Word(
      id: 96,
      sp: "Sábado",
      jp: "土曜日",
      icon: Icons.calendar_view_day,
      category: "曜日"),
  Word(
      id: 97,
      sp: "Domingo",
      jp: "日曜日",
      icon: Icons.calendar_month,
      category: "曜日"),
  Word(id: 98, sp: "Uno", jp: "1", icon: Icons.looks_one, category: "数"),
  Word(id: 99, sp: "Dos", jp: "2", icon: Icons.looks_two, category: "数"),
  Word(id: 100, sp: "Tres", jp: "3", icon: Icons.looks_3, category: "数"),
  Word(id: 101, sp: "Cuatro", jp: "4", icon: Icons.looks_4, category: "数"),
  Word(id: 102, sp: "Cinco", jp: "5", icon: Icons.looks_5, category: "数"),
  Word(id: 103, sp: "Diez", jp: "10", icon: Icons.numbers, category: "数"),
  Word(id: 104, sp: "Cien", jp: "100", icon: Icons.plus_one, category: "数"),
  Word(id: 105, sp: "Flor", jp: "花", icon: Icons.local_florist, category: "自然"),
  Word(id: 106, sp: "Árbol", jp: "木", icon: Icons.park, category: "自然"),
  Word(id: 107, sp: "Mar", jp: "海", icon: Icons.waves, category: "自然"),
  Word(id: 108, sp: "Montaña", jp: "山", icon: Icons.terrain, category: "自然"),
  Word(id: 109, sp: "Rio", jp: "川", icon: Icons.water, category: "自然"),
  Word(id: 110, sp: "Nombre", jp: "名前", icon: Icons.badge, category: "基本"),
  Word(id: 111, sp: "País", jp: "国", icon: Icons.public, category: "場所"),
  Word(
      id: 112,
      sp: "Ciudad",
      jp: "街/都市",
      icon: Icons.location_city,
      category: "場所"),
  Word(id: 113, sp: "Trabajo", jp: "仕事", icon: Icons.work, category: "生活"),
  Word(
      id: 114,
      sp: "Tiempo",
      jp: "時間/天気",
      icon: Icons.access_time,
      category: "時"),
  Word(
      id: 115,
      sp: "Puerta",
      jp: "ドア",
      icon: Icons.meeting_room,
      category: "家・部屋"),
  Word(
      id: 116, sp: "Cocina", jp: "キッチン", icon: Icons.kitchen, category: "家・部屋"),
  Word(
      id: 117, sp: "Baño", jp: "トイレ/風呂", icon: Icons.bathtub, category: "家・部屋"),
  Word(id: 118, sp: "Pared", jp: "壁", icon: Icons.border_all, category: "家・部屋"),
  Word(id: 119, sp: "Piso", jp: "床/階", icon: Icons.layers, category: "家・部屋"),
  Word(
      id: 120,
      sp: "Cuchara",
      jp: "スプーン",
      icon: Icons.restaurant,
      category: "台所用品"),
  Word(
      id: 121,
      sp: "Tenedor",
      jp: "フォーク",
      icon: Icons.restaurant,
      category: "台所用品"),
  Word(
      id: 122,
      sp: "Cuchillo",
      jp: "ナイフ",
      icon: Icons.restaurant,
      category: "台所用品"),
  Word(id: 123, sp: "Plato", jp: "皿", icon: Icons.flatware, category: "台所用品"),
  Word(id: 124, sp: "Vaso", jp: "コップ", icon: Icons.local_bar, category: "台所用品"),
  Word(
      id: 125,
      sp: "Hospital",
      jp: "病院",
      icon: Icons.local_hospital,
      category: "施設"),
  Word(
      id: 126,
      sp: "Banco",
      jp: "銀行",
      icon: Icons.account_balance,
      category: "施設"),
  Word(
      id: 127,
      sp: "Correo",
      jp: "郵便局",
      icon: Icons.local_post_office,
      category: "施設"),
  Word(id: 128, sp: "Parque", jp: "公園", icon: Icons.forest, category: "施設"),
  Word(
      id: 129,
      sp: "Aeropuerto",
      jp: "空港",
      icon: Icons.local_airport,
      category: "施設"),
  Word(id: 130, sp: "Ir", jp: "行く", icon: Icons.trending_flat, category: "動詞"),
  Word(id: 131, sp: "Venir", jp: "来る", icon: Icons.login, category: "動詞"),
  Word(id: 132, sp: "Salir", jp: "出る", icon: Icons.logout, category: "動詞"),
  Word(
      id: 133,
      sp: "Entrar",
      jp: "入る",
      icon: Icons.meeting_room,
      category: "動詞"),
  Word(id: 134, sp: "Poner", jp: "置く", icon: Icons.input, category: "動詞"),
  Word(
      id: 135,
      sp: "Tomar",
      jp: "取る/飲む",
      icon: Icons.front_hand,
      category: "動詞"),
  Word(id: 136, sp: "Dar", jp: "与える", icon: Icons.redeem, category: "動詞"),
  Word(id: 137, sp: "Hacer", jp: "する/作る", icon: Icons.build, category: "動詞"),
  Word(id: 138, sp: "Saber", jp: "知る", icon: Icons.psychology, category: "動詞"),
  Word(id: 139, sp: "Poder", jp: "できる", icon: Icons.task_alt, category: "動詞"),
  Word(id: 140, sp: "Perro", jp: "犬", icon: Icons.pets, category: "動物"),
  Word(id: 141, sp: "Gato", jp: "猫", icon: Icons.pets, category: "動物"),
  Word(
      id: 142, sp: "Pájaro", jp: "鳥", icon: Icons.flutter_dash, category: "動物"),
  Word(
      id: 143,
      sp: "Caballo",
      jp: "馬",
      icon: Icons.cruelty_free,
      category: "動物"),
  Word(id: 144, sp: "Vaca", jp: "牛", icon: Icons.agriculture, category: "動物"),
  Word(
      id: 145,
      sp: "Médico",
      jp: "医者",
      icon: Icons.medical_services,
      category: "職業"),
  Word(id: 146, sp: "Profesor", jp: "先生", icon: Icons.person, category: "職業"),
  Word(id: 147, sp: "Estudiante", jp: "学生", icon: Icons.school, category: "職業"),
  Word(
      id: 148,
      sp: "Policía",
      jp: "警察",
      icon: Icons.local_police,
      category: "職業"),
  Word(
      id: 149,
      sp: "Cocinero",
      jp: "料理人",
      icon: Icons.soup_kitchen,
      category: "職業"),
  Word(id: 150, sp: "Papel", jp: "紙", icon: Icons.description, category: "文房具"),
  Word(
      id: 151, sp: "Bolígrafo", jp: "ボールペン", icon: Icons.edit, category: "文房具"),
  Word(id: 152, sp: "Lápiz", jp: "鉛筆", icon: Icons.edit, category: "文房具"),
  Word(
      id: 153,
      sp: "Cuaderno",
      jp: "ノート",
      icon: Icons.menu_book,
      category: "文房具"),
  Word(
      id: 154,
      sp: "Goma",
      jp: "消しゴム",
      icon: Icons.cleaning_services,
      category: "文房具"),
  Word(
      id: 155, sp: "Cuerpo", jp: "体", icon: Icons.accessibility, category: "体"),
  Word(id: 156, sp: "Salud", jp: "健康", icon: Icons.favorite, category: "状態"),
  Word(
      id: 157,
      sp: "Problema",
      jp: "問題",
      icon: Icons.report_problem,
      category: "基本"),
  Word(id: 158, sp: "Pregunta", jp: "質問", icon: Icons.help, category: "基本"),
  Word(
      id: 159,
      sp: "Respuesta",
      jp: "答え",
      icon: Icons.chat_bubble,
      category: "基本"),
  Word(
      id: 160,
      sp: "Deporte",
      jp: "スポーツ",
      icon: Icons.sports_soccer,
      category: "娯楽"),
  Word(id: 161, sp: "Música", jp: "音楽", icon: Icons.music_note, category: "娯楽"),
  Word(id: 162, sp: "Película", jp: "映画", icon: Icons.movie, category: "娯楽"),
  Word(id: 163, sp: "Viaje", jp: "旅行", icon: Icons.card_travel, category: "娯楽"),
  Word(
      id: 164,
      sp: "Fiesta",
      jp: "パーティー",
      icon: Icons.celebration,
      category: "娯楽"),
  Word(
      id: 165,
      sp: "Primavera",
      jp: "春",
      icon: Icons.local_florist,
      category: "季節"),
  Word(id: 166, sp: "Verano", jp: "夏", icon: Icons.sunny, category: "季節"),
  Word(id: 167, sp: "Otoño", jp: "秋", icon: Icons.park, category: "季節"),
  Word(id: 168, sp: "Invierno", jp: "冬", icon: Icons.ac_unit, category: "季節"),
  Word(id: 169, sp: "Mes", jp: "月", icon: Icons.calendar_month, category: "時"),
  Word(id: 170, sp: "Yo", jp: "私", icon: Icons.person, category: "代名詞"),
  Word(
      id: 171,
      sp: "Tú",
      jp: "あなた",
      icon: Icons.person_outline,
      category: "代名詞"),
  Word(id: 172, sp: "Él", jp: "彼", icon: Icons.male, category: "代名詞"),
  Word(id: 173, sp: "Ella", jp: "彼女", icon: Icons.female, category: "代名詞"),
  Word(id: 174, sp: "Esto", jp: "これ", icon: Icons.ads_click, category: "代名詞"),
  Word(id: 175, sp: "Eso", jp: "それ", icon: Icons.ads_click, category: "代名詞"),
  Word(
      id: 176, sp: "Aquello", jp: "あれ", icon: Icons.ads_click, category: "代名詞"),
  Word(
      id: 177,
      sp: "Hermoso",
      jp: "美しい",
      icon: Icons.auto_awesome,
      category: "形容詞"),
  Word(
      id: 178,
      sp: "Feo",
      jp: "醜い",
      icon: Icons.sentiment_very_dissatisfied,
      category: "形容詞"),
  Word(id: 179, sp: "Fácil", jp: "簡単な", icon: Icons.bolt, category: "形容詞"),
  Word(
      id: 180,
      sp: "Difícil",
      jp: "難しい",
      icon: Icons.psychology,
      category: "形容詞"),
  Word(id: 181, sp: "Rápido", jp: "速い", icon: Icons.speed, category: "形容詞"),
  Word(id: 182, sp: "Lento", jp: "遅い", icon: Icons.moped, category: "形容詞"),
  Word(
      id: 183,
      sp: "Fuerte",
      jp: "強い",
      icon: Icons.fitness_center,
      category: "形容詞"),
  Word(id: 184, sp: "Débil", jp: "弱い", icon: Icons.vibration, category: "形容詞"),
  Word(
      id: 185,
      sp: "Amable",
      jp: "親切な",
      icon: Icons.favorite_border,
      category: "感情"),
  Word(
      id: 186,
      sp: "Inteligente",
      jp: "賢い",
      icon: Icons.lightbulb,
      category: "感情"),
  Word(id: 187, sp: "Divertido", jp: "楽しい", icon: Icons.mood, category: "感情"),
  Word(
      id: 188,
      sp: "Aburrido",
      jp: "退屈な",
      icon: Icons.sentiment_neutral,
      category: "感情"),
  Word(
      id: 189,
      sp: "Miedo",
      jp: "怖い",
      icon: Icons.warning_amber,
      category: "感情"),
  Word(id: 190, sp: "Vino", jp: "ワイン", icon: Icons.wine_bar, category: "飲食"),
  Word(
      id: 191,
      sp: "Cerveza",
      jp: "ビール",
      icon: Icons.sports_bar,
      category: "飲食"),
  Word(
      id: 192, sp: "Jugo", jp: "ジュース", icon: Icons.local_drink, category: "飲食"),
  Word(
      id: 193, sp: "Sopa", jp: "スープ", icon: Icons.soup_kitchen, category: "飲食"),
  Word(id: 194, sp: "Ensalada", jp: "サラダ", icon: Icons.eco, category: "飲食"),
  Word(
      id: 195,
      sp: "Queso",
      jp: "チーズ",
      icon: Icons.workspace_premium,
      category: "飲食"),
  Word(id: 196, sp: "Gris", jp: "灰色", icon: Icons.circle, category: "色"),
  Word(id: 197, sp: "Naranja", jp: "オレンジ", icon: Icons.circle, category: "色"),
  Word(id: 198, sp: "Rosa", jp: "ピンク", icon: Icons.circle, category: "色"),
  Word(id: 199, sp: "Marrón", jp: "茶色", icon: Icons.circle, category: "色"),
  Word(
      id: 200,
      sp: "Bolsa",
      jp: "バッグ/袋",
      icon: Icons.shopping_bag,
      category: "生活"),
  Word(id: 201, sp: "Caja", jp: "箱", icon: Icons.inventory_2, category: "生活"),
  Word(id: 202, sp: "Papel", jp: "紙", icon: Icons.description, category: "生活"),
  Word(id: 203, sp: "Luz", jp: "光/電気", icon: Icons.light, category: "生活"),
  Word(id: 204, sp: "Mundo", jp: "世界", icon: Icons.public, category: "場所"),
  Word(id: 205, sp: "Gente", jp: "人々", icon: Icons.groups, category: "基本"),
  Word(id: 206, sp: "Vida", jp: "人生/命", icon: Icons.favorite, category: "基本"),
  Word(
      id: 207, sp: "Razón", jp: "理由", icon: Icons.info_outline, category: "基本"),
  Word(
      id: 208,
      sp: "Idea",
      jp: "アイデア",
      icon: Icons.lightbulb_outline,
      category: "基本"),
  Word(id: 209, sp: "Paz", jp: "平和", icon: Icons.front_hand, category: "基本"),
  Word(id: 210, sp: "Paquete", jp: "小包", icon: Icons.inventory, category: "生活"),

  // --- ここからが211番以降の「追加分」です ---
  Word(
      id: 211,
      sp: "Hombro",
      jp: "肩",
      icon: Icons.accessibility_new,
      category: "体"),
  Word(id: 212, sp: "Brazo", jp: "腕", icon: Icons.handyman, category: "体"),
  Word(id: 213, sp: "Dedo", jp: "指", icon: Icons.front_hand, category: "体"),
  Word(
      id: 214,
      sp: "Pierna",
      jp: "脚",
      icon: Icons.directions_walk,
      category: "体"),
  Word(
      id: 215,
      sp: "Rodilla",
      jp: "膝",
      icon: Icons.airline_seat_legroom_extra,
      category: "体"),
  Word(id: 216, sp: "Corazón", jp: "心臓/心", icon: Icons.favorite, category: "体"),
  Word(id: 217, sp: "Sangre", jp: "血", icon: Icons.water_drop, category: "体"),
  Word(
      id: 218,
      sp: "Optimista",
      jp: "楽観的な",
      icon: Icons.wb_sunny,
      category: "性格"),
  Word(id: 219, sp: "Pesimista", jp: "悲観的な", icon: Icons.cloud, category: "性格"),
  Word(
      id: 220,
      sp: "Paciente",
      jp: "忍耐強い",
      icon: Icons.hourglass_full,
      category: "性格"),
  Word(
      id: 221,
      sp: "Tímido",
      jp: "内気な",
      icon: Icons.face_retouching_natural,
      category: "性格"),
  Word(id: 222, sp: "Valiente", jp: "勇敢な", icon: Icons.shield, category: "性格"),
  Word(id: 223, sp: "Estrella", jp: "星", icon: Icons.star, category: "自然"),
  Word(id: 224, sp: "Planeta", jp: "惑星", icon: Icons.public, category: "自然"),
  Word(id: 225, sp: "Tierra", jp: "地球/地面", icon: Icons.public, category: "自然"),
  Word(
      id: 226,
      sp: "Fuego",
      jp: "火",
      icon: Icons.local_fire_department,
      category: "自然"),
  Word(id: 227, sp: "Aire", jp: "空気", icon: Icons.air, category: "自然"),
  Word(id: 228, sp: "Piedra", jp: "石", icon: Icons.landscape, category: "自然"),
  Word(id: 229, sp: "Arena", jp: "砂", icon: Icons.grain, category: "自然"),
  Word(
      id: 230,
      sp: "Edificio",
      jp: "ビル/建物",
      icon: Icons.apartment,
      category: "場所"),
  Word(id: 231, sp: "Oficina", jp: "事務所", icon: Icons.work, category: "場所"),
  Word(
      id: 232,
      sp: "Biblioteca",
      jp: "図書館",
      icon: Icons.local_library,
      category: "場所"),
  Word(id: 233, sp: "Museo", jp: "美術館", icon: Icons.museum, category: "場所"),
  Word(id: 234, sp: "Cine", jp: "映画館", icon: Icons.movie, category: "場所"),
  Word(id: 235, sp: "Estación", jp: "駅", icon: Icons.train, category: "場所"),
  Word(
      id: 236,
      sp: "Espejo",
      jp: "鏡",
      icon: Icons.crop_portrait,
      category: "生活"),
  Word(id: 237, sp: "Jabón", jp: "石鹸", icon: Icons.clean_hands, category: "生活"),
  Word(id: 238, sp: "Toalla", jp: "タオル", icon: Icons.texture, category: "生活"),
  Word(id: 239, sp: "Cepillo", jp: "ブラシ", icon: Icons.brush, category: "生活"),
  Word(
      id: 240,
      sp: "Pasta de dientes",
      jp: "歯磨き粉",
      icon: Icons.cleaning_services,
      category: "生活"),
  Word(id: 241, sp: "Y", jp: "〜と（and）", icon: Icons.add, category: "基本"),
  Word(id: 242, sp: "O", jp: "または（or）", icon: Icons.alt_route, category: "基本"),
  Word(
      id: 243,
      sp: "Pero",
      jp: "しかし（but）",
      icon: Icons.priority_high,
      category: "基本"),
  Word(
      id: 244,
      sp: "Porque",
      jp: "なぜなら",
      icon: Icons.question_answer,
      category: "基本"),
  Word(id: 245, sp: "Muy", jp: "とても", icon: Icons.speed, category: "基本"),
  Word(id: 246, sp: "Mucho", jp: "たくさん", icon: Icons.reorder, category: "基本"),
  Word(id: 247, sp: "Poco", jp: "少し", icon: Icons.minimize, category: "基本"),
  Word(
      id: 248,
      sp: "Siempre",
      jp: "いつも",
      icon: Icons.all_inclusive,
      category: "時"),
  Word(id: 249, sp: "Nunca", jp: "決して〜ない", icon: Icons.block, category: "時"),
  Word(id: 250, sp: "A veces", jp: "時々", icon: Icons.update, category: "時"),
  Word(id: 251, sp: "Verdad", jp: "真実", icon: Icons.verified, category: "基本"),
  Word(
      id: 252,
      sp: "Mentira",
      jp: "嘘",
      icon: Icons.wrong_location,
      category: "基本"),
  Word(
      id: 253, sp: "Suerte", jp: "運", icon: Icons.auto_awesome, category: "基本"),
  Word(
      id: 254, sp: "Éxito", jp: "成功", icon: Icons.emoji_events, category: "基本"),
  Word(id: 255, sp: "Peligro", jp: "危険", icon: Icons.warning, category: "基本"),
  Word(
      id: 256, sp: "Seguridad", jp: "安全", icon: Icons.security, category: "基本"),
  Word(id: 257, sp: "Ayuda", jp: "助け", icon: Icons.help_center, category: "基本"),
  Word(
      id: 258,
      sp: "Sueño",
      jp: "夢/眠気",
      icon: Icons.nights_stay,
      category: "基本"),
  Word(id: 259, sp: "Pregunta", jp: "質問", icon: Icons.help, category: "基本"),
  Word(
      id: 260,
      sp: "Respuesta",
      jp: "答え",
      icon: Icons.chat_bubble,
      category: "基本"), // --- 追加パック：No.261〜310（計50単語） ---
  Word(
      id: 261, sp: "Cena", jp: "夕食", icon: Icons.dinner_dining, category: "飲食"),
  Word(
      id: 262,
      sp: "Desayuno",
      jp: "朝食",
      icon: Icons.breakfast_dining,
      category: "飲食"),
  Word(
      id: 263,
      sp: "Almuerzo",
      jp: "昼食",
      icon: Icons.lunch_dining,
      category: "飲食"),
  Word(id: 264, sp: "Fruta", jp: "果物", icon: Icons.apple, category: "飲食"),
  Word(id: 265, sp: "Verdura", jp: "野菜", icon: Icons.eco, category: "飲食"),
  Word(id: 266, sp: "Carne", jp: "肉", icon: Icons.kebab_dining, category: "飲食"),
  Word(id: 267, sp: "Pescado", jp: "魚", icon: Icons.set_meal, category: "飲食"),
  Word(id: 268, sp: "Pollo", jp: "鶏肉", icon: Icons.restaurant, category: "飲食"),
  Word(id: 269, sp: "Postre", jp: "デザート", icon: Icons.icecream, category: "飲食"),
  Word(id: 270, sp: "Dulce", jp: "甘い/お菓子", icon: Icons.cake, category: "飲食"),

  // --- 動作・アクション ---
  Word(
      id: 271,
      sp: "Mirar",
      jp: "じっと見る",
      icon: Icons.remove_red_eye,
      category: "動詞"),
  Word(id: 272, sp: "Buscar", jp: "探す", icon: Icons.search, category: "動詞"),
  Word(
      id: 273,
      sp: "Encontrar",
      jp: "見つける",
      icon: Icons.location_searching,
      category: "動詞"),
  Word(
      id: 274,
      sp: "Esperar",
      jp: "待つ",
      icon: Icons.hourglass_bottom,
      category: "動詞"),
  Word(
      id: 275,
      sp: "Llamar",
      jp: "呼ぶ/電話する",
      icon: Icons.add_call,
      category: "動詞"),
  Word(
      id: 276,
      sp: "Ayudar",
      jp: "助ける",
      icon: Icons.volunteer_activism,
      category: "動詞"),
  Word(
      id: 277,
      sp: "Llevar",
      jp: "運ぶ/持っていく",
      icon: Icons.local_shipping,
      category: "動詞"),
  Word(id: 278, sp: "Traer", jp: "持ってくる", icon: Icons.input, category: "動詞"),
  Word(
      id: 279,
      sp: "Comprar",
      jp: "買う",
      icon: Icons.shopping_cart,
      category: "動詞"),
  Word(id: 280, sp: "Pagar", jp: "支払う", icon: Icons.payments, category: "動詞"),

  // --- 衣服・ファッション ---
  Word(id: 281, sp: "Camisa", jp: "シャツ", icon: Icons.checkroom, category: "衣服"),
  Word(
      id: 282,
      sp: "Pantalones",
      jp: "ズボン",
      icon: Icons.accessibility,
      category: "衣服"),
  Word(
      id: 283,
      sp: "Vestido",
      jp: "ドレス/ワンピース",
      icon: Icons.straighten,
      category: "衣服"),
  Word(id: 284, sp: "Falda", jp: "スカート", icon: Icons.layers, category: "衣服"),
  Word(
      id: 285,
      sp: "Abrigo",
      jp: "コート/上着",
      icon: Icons.dry_cleaning,
      category: "衣服"),
  Word(
      id: 286,
      sp: "Calcetines",
      jp: "靴下",
      icon: Icons.fiber_manual_record,
      category: "衣服"),
  Word(
      id: 287,
      sp: "Gorra",
      jp: "キャップ帽",
      icon: Icons.theater_comedy,
      category: "衣服"),
  Word(
      id: 288, sp: "Bolsillo", jp: "ポケット", icon: Icons.fmd_bad, category: "衣服"),

  // --- 場所・インフラ ---
  Word(id: 289, sp: "Calle", jp: "通り/道", icon: Icons.add_road, category: "場所"),
  Word(id: 290, sp: "Plaza", jp: "広場", icon: Icons.crop_square, category: "場所"),
  Word(
      id: 291, sp: "Puente", jp: "橋", icon: Icons.architecture, category: "場所"),
  Word(id: 292, sp: "Esquina", jp: "角", icon: Icons.turn_right, category: "場所"),
  Word(
      id: 293,
      sp: "Parada",
      jp: "停留所",
      icon: Icons.departure_board,
      category: "場所"),
  Word(
      id: 294,
      sp: "Gasolinera",
      jp: "ガソリンスタンド",
      icon: Icons.local_gas_station,
      category: "場所"),
  Word(
      id: 295,
      sp: "Farmacia",
      jp: "薬局",
      icon: Icons.local_pharmacy,
      category: "場所"),

  // --- 自然・天体 ---
  Word(id: 296, sp: "Cielo", jp: "空", icon: Icons.cloud_queue, category: "自然"),
  Word(id: 297, sp: "Mar", jp: "海", icon: Icons.waves, category: "自然"),
  Word(
      id: 298,
      sp: "Playa",
      jp: "海岸/砂浜",
      icon: Icons.beach_access,
      category: "自然"),
  Word(id: 299, sp: "Isla", jp: "島", icon: Icons.landscape, category: "自然"),
  Word(id: 300, sp: "Bosque", jp: "森", icon: Icons.forest, category: "自然"),
  Word(id: 301, sp: "Hielo", jp: "氷", icon: Icons.ac_unit, category: "自然"),

  // --- 時間の表現 ---
  Word(id: 302, sp: "Minuto", jp: "分", icon: Icons.timer_10, category: "時"),
  Word(id: 303, sp: "Hora", jp: "時間", icon: Icons.access_time, category: "時"),
  Word(id: 304, sp: "Semana", jp: "週", icon: Icons.view_week, category: "時"),
  Word(id: 305, sp: "Año", jp: "年", icon: Icons.calendar_today, category: "時"),
  Word(id: 306, sp: "Siglo", jp: "世紀", icon: Icons.history_edu, category: "時"),
  Word(id: 307, sp: "Pronto", jp: "すぐに", icon: Icons.bolt, category: "時"),
  Word(
      id: 308,
      sp: "Tarde",
      jp: "遅い/午後",
      icon: Icons.wb_twilight,
      category: "時"),
  Word(id: 309, sp: "Temprano", jp: "早い", icon: Icons.wb_sunny, category: "時"),
  Word(
      id: 310,
      sp: "Futuro",
      jp: "未来",
      icon: Icons.rocket_launch,
      category: "時"), // --- 追加パック：No.311〜360（計50単語） ---
  // --- 感情・性格の深掘り ---
  Word(id: 311, sp: "Orgulloso", jp: "誇らしい", icon: Icons.stars, category: "感情"),
  Word(
      id: 312,
      sp: "Celoso",
      jp: "嫉妬深い",
      icon: Icons.visibility_off,
      category: "感情"),
  Word(
      id: 313,
      sp: "Sorprendido",
      jp: "驚いた",
      icon: Icons.auto_awesome,
      category: "感情"),
  Word(
      id: 314,
      sp: "Asustado",
      jp: "怖がっている",
      icon: Icons.scuba_diving,
      category: "感情"),
  Word(
      id: 315,
      sp: "Tranquilo",
      jp: "穏やかな",
      icon: Icons.self_improvement,
      category: "感情"),
  Word(
      id: 316,
      sp: "Preocupado",
      jp: "心配な",
      icon: Icons.psychology_alt,
      category: "感情"),
  Word(
      id: 317,
      sp: "Emocionado",
      jp: "わくわくした",
      icon: Icons.celebration,
      category: "感情"),
  Word(
      id: 318,
      sp: "Abierto",
      jp: "開放的な",
      icon: Icons.meeting_room,
      category: "性格"),
  Word(id: 319, sp: "Cerrado", jp: "閉鎖的な", icon: Icons.lock, category: "性格"),
  Word(id: 320, sp: "Generoso", jp: "寛大な", icon: Icons.redeem, category: "性格"),
  Word(id: 321, sp: "Tacaño", jp: "けちな", icon: Icons.money_off, category: "性格"),

  // --- 動作・生活 ---
  Word(
      id: 322,
      sp: "Despertar",
      jp: "目覚める",
      icon: Icons.wb_sunny,
      category: "動詞"),
  Word(
      id: 323,
      sp: "Levantarse",
      jp: "起き上がる",
      icon: Icons.accessibility_new,
      category: "動詞"),
  Word(
      id: 324,
      sp: "Ducharse",
      jp: "シャワーを浴びる",
      icon: Icons.shower,
      category: "動詞"),
  Word(id: 325, sp: "Lavarse", jp: "洗う", icon: Icons.wash, category: "動詞"),
  Word(
      id: 326,
      sp: "Vestirse",
      jp: "服を着る",
      icon: Icons.checkroom,
      category: "動詞"),
  Word(
      id: 327,
      sp: "Desayunar",
      jp: "朝食をとる",
      icon: Icons.coffee,
      category: "動詞"),
  Word(
      id: 328,
      sp: "Cocinar",
      jp: "料理する",
      icon: Icons.soup_kitchen,
      category: "動詞"),
  Word(
      id: 329,
      sp: "Limpiar",
      jp: "掃除する",
      icon: Icons.cleaning_services,
      category: "動詞"),
  Word(id: 330, sp: "Descansar", jp: "休む", icon: Icons.weekend, category: "動詞"),
  Word(
      id: 331,
      sp: "Viajar",
      jp: "旅行する",
      icon: Icons.flight_takeoff,
      category: "動詞"),

  // --- オフィス・学校・文房具 ---
  Word(id: 332, sp: "Reunión", jp: "会議", icon: Icons.groups, category: "生活"),
  Word(
      id: 333,
      sp: "Documento",
      jp: "書類",
      icon: Icons.description,
      category: "生活"),
  Word(id: 334, sp: "Correo", jp: "郵便/メール", icon: Icons.email, category: "生活"),
  Word(id: 335, sp: "Pantalla", jp: "画面", icon: Icons.monitor, category: "生活"),
  Word(
      id: 336,
      sp: "Teclado",
      jp: "キーボード",
      icon: Icons.keyboard,
      category: "生活"),
  Word(id: 337, sp: "Ratón", jp: "マウス", icon: Icons.mouse, category: "生活"),
  Word(id: 338, sp: "Carpeta", jp: "フォルダ", icon: Icons.folder, category: "生活"),
  Word(
      id: 339,
      sp: "Tijeras",
      jp: "はさみ",
      icon: Icons.content_cut,
      category: "生活"),
  Word(id: 340, sp: "Regla", jp: "定規", icon: Icons.straighten, category: "生活"),

  // --- 都市・建物・乗り物 ---
  Word(id: 341, sp: "Hotel", jp: "ホテル", icon: Icons.hotel, category: "場所"),
  Word(
      id: 342,
      sp: "Restaurante",
      jp: "レストラン",
      icon: Icons.restaurant,
      category: "場所"),
  Word(id: 343, sp: "Bar", jp: "バー", icon: Icons.local_bar, category: "場所"),
  Word(id: 344, sp: "Cine", jp: "映画館", icon: Icons.movie, category: "場所"),
  Word(
      id: 345,
      sp: "Teatro",
      jp: "劇場",
      icon: Icons.theater_comedy,
      category: "場所"),
  Word(
      id: 346,
      sp: "Gimnasio",
      jp: "ジム",
      icon: Icons.fitness_center,
      category: "場所"),
  Word(id: 347, sp: "Piscina", jp: "プール", icon: Icons.pool, category: "場所"),
  Word(
      id: 348,
      sp: "Bicicleta",
      jp: "自転車",
      icon: Icons.pedal_bike,
      category: "交通"),
  Word(id: 349, sp: "Moto", jp: "バイク", icon: Icons.motorcycle, category: "交通"),
  Word(
      id: 350,
      sp: "Barco",
      jp: "船",
      icon: Icons.directions_boat,
      category: "交通"),

  // --- 抽象概念・基本表現 ---
  Word(
      id: 351,
      sp: "Diferente",
      jp: "異なる",
      icon: Icons.difference,
      category: "基本"),
  Word(id: 352, sp: "Igual", jp: "同じ", icon: Icons.reorder, category: "基本"),
  Word(
      id: 353,
      sp: "Importante",
      jp: "重要な",
      icon: Icons.priority_high,
      category: "基本"),
  Word(
      id: 354,
      sp: "Necesario",
      jp: "必要な",
      icon: Icons.report_problem,
      category: "基本"),
  Word(id: 355, sp: "Posible", jp: "可能な", icon: Icons.task_alt, category: "基本"),
  Word(id: 356, sp: "Imposible", jp: "不可能な", icon: Icons.block, category: "基本"),
  Word(id: 357, sp: "Especial", jp: "特別な", icon: Icons.stars, category: "基本"),
  Word(
      id: 358,
      sp: "Seguro",
      jp: "確信している/安全な",
      icon: Icons.verified_user,
      category: "基本"),
  Word(id: 359, sp: "Libre", jp: "自由な", icon: Icons.child_care, category: "基本"),
  Word(
      id: 360,
      sp: "Público",
      jp: "公共の",
      icon: Icons.public,
      category: "基本"), // --- 追加パック：No.361〜410（計50単語） ---
  // --- 自然・地理・宇宙の続き ---
  Word(
      id: 361,
      sp: "Universo",
      jp: "宇宙",
      icon: Icons.auto_awesome,
      category: "自然"),
  Word(
      id: 362,
      sp: "Galaxia",
      jp: "銀河",
      icon: Icons.brightness_low,
      category: "自然"),
  Word(
      id: 363, sp: "Selva", jp: "ジャングル/密林", icon: Icons.forest, category: "自然"),
  Word(id: 364, sp: "Desierto", jp: "砂漠", icon: Icons.wb_sunny, category: "自然"),
  Word(id: 365, sp: "Valle", jp: "谷", icon: Icons.terrain, category: "自然"),
  Word(id: 366, sp: "Colina", jp: "丘", icon: Icons.landscape, category: "自然"),
  Word(
      id: 367,
      sp: "Cueva",
      jp: "洞窟",
      icon: Icons.door_back_door,
      category: "自然"),
  Word(
      id: 368, sp: "Costa", jp: "海岸", icon: Icons.beach_access, category: "自然"),
  Word(id: 369, sp: "Océano", jp: "大洋", icon: Icons.waves, category: "自然"),
  Word(id: 370, sp: "Lago", jp: "湖", icon: Icons.water, category: "自然"),

  // --- 道具・材料・機械 ---
  Word(id: 371, sp: "Herramienta", jp: "道具", icon: Icons.build, category: "生活"),
  Word(id: 372, sp: "Martillo", jp: "ハンマー", icon: Icons.gavel, category: "生活"),
  Word(id: 373, sp: "Clavo", jp: "釘", icon: Icons.push_pin, category: "生活"),
  Word(id: 374, sp: "Tornillo", jp: "ネジ", icon: Icons.settings, category: "生活"),
  Word(id: 375, sp: "Madera", jp: "木材", icon: Icons.park, category: "生活"),
  Word(
      id: 376,
      sp: "Metal",
      jp: "金属",
      icon: Icons.precision_manufacturing,
      category: "生活"),
  Word(
      id: 377,
      sp: "Plástico",
      jp: "プラスチック",
      icon: Icons.recycling,
      category: "生活"),
  Word(id: 378, sp: "Vidrio", jp: "ガラス", icon: Icons.window, category: "生活"),
  Word(
      id: 379,
      sp: "Batería",
      jp: "電池",
      icon: Icons.battery_full,
      category: "生活"),
  Word(
      id: 380,
      sp: "Cable",
      jp: "ケーブル",
      icon: Icons.settings_input_component,
      category: "生活"),

  // --- 体の状態・医学 ---
  Word(id: 381, sp: "Dolor", jp: "痛み", icon: Icons.mood_bad, category: "体"),
  Word(id: 382, sp: "Fiebre", jp: "熱", icon: Icons.thermostat, category: "体"),
  Word(
      id: 383,
      sp: "Gripe",
      jp: "インフルエンザ/風邪",
      icon: Icons.health_and_safety,
      category: "体"),
  Word(id: 384, sp: "Medicina", jp: "薬", icon: Icons.medication, category: "体"),
  Word(
      id: 385,
      sp: "Pastilla",
      jp: "錠剤",
      icon: Icons.medication_liquid,
      category: "体"),
  Word(
      id: 386,
      sp: "Receta",
      jp: "処方箋/レシピ",
      icon: Icons.receipt_long,
      category: "基本"),
  Word(id: 387, sp: "Sangre", jp: "血液", icon: Icons.bloodtype, category: "体"),
  Word(id: 388, sp: "Hueso", jp: "骨", icon: Icons.accessibility, category: "体"),
  Word(id: 389, sp: "Piel", jp: "肌", icon: Icons.back_hand, category: "体"),
  Word(
      id: 390,
      sp: "Músculo",
      jp: "筋肉",
      icon: Icons.fitness_center,
      category: "体"),

  // --- より高度な動詞 ---
  Word(
      id: 391, sp: "Pensar", jp: "考える", icon: Icons.psychology, category: "動詞"),
  Word(
      id: 392,
      sp: "Recordar",
      jp: "覚えている/思い出す",
      icon: Icons.history,
      category: "動詞"),
  Word(
      id: 393,
      sp: "Olvidar",
      jp: "忘れる",
      icon: Icons.delete_sweep,
      category: "動詞"),
  Word(id: 394, sp: "Aprender", jp: "学ぶ", icon: Icons.school, category: "動詞"),
  Word(
      id: 395,
      sp: "Enseñar",
      jp: "教える",
      icon: Icons.record_voice_over,
      category: "動詞"),
  Word(
      id: 396,
      sp: "Entender",
      jp: "理解する",
      icon: Icons.lightbulb,
      category: "動詞"),
  Word(
      id: 397,
      sp: "Esperar",
      jp: "希望する/待つ",
      icon: Icons.volunteer_activism,
      category: "動詞"),
  Word(
      id: 398,
      sp: "Prometer",
      jp: "約束する",
      icon: Icons.handshake,
      category: "動詞"),
  Word(id: 399, sp: "Decidir", jp: "決める", icon: Icons.gavel, category: "動詞"),
  Word(id: 400, sp: "Intentar", jp: "試みる", icon: Icons.refresh, category: "動詞"),

  // --- その他・副詞など ---
  Word(
      id: 401,
      sp: "Quizás",
      jp: "おそらく",
      icon: Icons.help_outline,
      category: "基本"),
  Word(
      id: 402,
      sp: "Tal vez",
      jp: "たぶん",
      icon: Icons.question_mark,
      category: "基本"),
  Word(
      id: 403,
      sp: "Casi",
      jp: "ほとんど",
      icon: Icons.shutter_speed,
      category: "基本"),
  Word(
      id: 404,
      sp: "Demasiado",
      jp: "〜すぎる",
      icon: Icons.warning,
      category: "基本"),
  Word(
      id: 405,
      sp: "Suficiente",
      jp: "十分な",
      icon: Icons.thumb_up,
      category: "基本"),
  Word(id: 406, sp: "Rápido", jp: "速く", icon: Icons.speed, category: "形容詞"),
  Word(id: 407, sp: "Lento", jp: "ゆっくり", icon: Icons.moped, category: "形容詞"),
  Word(
      id: 408,
      sp: "Fuerte",
      jp: "強く",
      icon: Icons.fitness_center,
      category: "形容詞"),
  Word(
      id: 409,
      sp: "Despacio",
      jp: "おそく",
      icon: Icons.directions_walk,
      category: "形容詞"),
  Word(
      id: 410,
      sp: "A menudo",
      jp: "しばしば",
      icon: Icons.repeat,
      category: "時"), // --- 追加パック：No.411〜460（計50単語） ---
  // --- 感情・精神状態 ---
  Word(
      id: 411,
      sp: "Orgullo",
      jp: "誇り",
      icon: Icons.emoji_events,
      category: "感情"),
  Word(
      id: 412,
      sp: "Envidia",
      jp: "うらやみ/嫉妬",
      icon: Icons.visibility_off,
      category: "感情"),
  Word(
      id: 413,
      sp: "Paciencia",
      jp: "忍耐",
      icon: Icons.hourglass_empty,
      category: "感情"),
  Word(
      id: 414,
      sp: "Confianza",
      jp: "信頼",
      icon: Icons.handshake,
      category: "感情"),
  Word(id: 415, sp: "Duda", jp: "疑い", icon: Icons.help_center, category: "感情"),
  Word(
      id: 416, sp: "Miedo", jp: "恐怖", icon: Icons.scuba_diving, category: "感情"),
  Word(id: 417, sp: "Sorpresa", jp: "驚き", icon: Icons.bolt, category: "感情"),
  Word(
      id: 418,
      sp: "Vergüenza",
      jp: "恥",
      icon: Icons.face_retouching_natural,
      category: "感情"),
  Word(
      id: 419, sp: "Odio", jp: "憎しみ", icon: Icons.heart_broken, category: "感情"),
  Word(id: 420, sp: "Cariño", jp: "愛情", icon: Icons.favorite, category: "感情"),

  // --- 自然・災害・環境 ---
  Word(
      id: 421,
      sp: "Tormenta",
      jp: "嵐",
      icon: Icons.thunderstorm,
      category: "自然"),
  Word(id: 422, sp: "Rayo", jp: "雷", icon: Icons.flash_on, category: "自然"),
  Word(
      id: 423,
      sp: "Terremoto",
      jp: "地震",
      icon: Icons.vibration,
      category: "自然"),
  Word(id: 424, sp: "Inundación", jp: "洪水", icon: Icons.flood, category: "自然"),
  Word(
      id: 425,
      sp: "Fuego",
      jp: "火災/火",
      icon: Icons.local_fire_department,
      category: "自然"),
  Word(id: 426, sp: "Humo", jp: "煙", icon: Icons.cloud, category: "自然"),
  Word(id: 427, sp: "Onda", jp: "波", icon: Icons.waves, category: "自然"),
  Word(id: 428, sp: "Clima", jp: "気候", icon: Icons.wb_sunny, category: "自然"),
  Word(id: 429, sp: "Ambiente", jp: "環境", icon: Icons.eco, category: "自然"),
  Word(id: 430, sp: "Tierra", jp: "土/地球", icon: Icons.public, category: "自然"),

  // --- 建物の中・家具 ---
  Word(id: 431, sp: "Pasillo", jp: "廊下", icon: Icons.straight, category: "場所"),
  Word(id: 432, sp: "Escalera", jp: "階段", icon: Icons.stairs, category: "場所"),
  Word(
      id: 433,
      sp: "Ascensor",
      jp: "エレベーター",
      icon: Icons.elevator,
      category: "場所"),
  Word(id: 434, sp: "Techo", jp: "天井/屋根", icon: Icons.roofing, category: "場所"),
  Word(id: 435, sp: "Suelo", jp: "床/地面", icon: Icons.layers, category: "場所"),
  Word(
      id: 436,
      sp: "Alfombra",
      jp: "カーペット",
      icon: Icons.texture,
      category: "生活"),
  Word(
      id: 437,
      sp: "Cortina",
      jp: "カーテン",
      icon: Icons.grid_view,
      category: "生活"),
  Word(
      id: 438,
      sp: "Espejo",
      jp: "鏡",
      icon: Icons.crop_portrait,
      category: "生活"),
  Word(id: 439, sp: "Lámpara", jp: "ランプ", icon: Icons.light, category: "生活"),
  Word(id: 440, sp: "Mueble", jp: "家具", icon: Icons.chair, category: "生活"),

  // --- 動詞（コミュニケーションと社会） ---
  Word(id: 441, sp: "Preguntar", jp: "尋ねる", icon: Icons.quiz, category: "動詞"),
  Word(
      id: 442,
      sp: "Contestar",
      jp: "答える",
      icon: Icons.question_answer,
      category: "動詞"),
  Word(id: 443, sp: "Discutir", jp: "議論する", icon: Icons.forum, category: "動詞"),
  Word(id: 444, sp: "Gritar", jp: "叫ぶ", icon: Icons.campaign, category: "動詞"),
  Word(
      id: 445,
      sp: "Reír",
      jp: "笑う",
      icon: Icons.sentiment_very_satisfied,
      category: "動詞"),
  Word(
      id: 446,
      sp: "Llorar",
      jp: "泣く",
      icon: Icons.sentiment_very_dissatisfied,
      category: "動詞"),
  Word(
      id: 447,
      sp: "Sonreír",
      jp: "ほほえむ",
      icon: Icons.sentiment_satisfied,
      category: "動詞"),
  Word(
      id: 448,
      sp: "Saludar",
      jp: "挨拶する",
      icon: Icons.front_hand,
      category: "動詞"),
  Word(id: 449, sp: "Abrazar", jp: "抱きしめる", icon: Icons.people, category: "動詞"),
  Word(id: 450, sp: "Besar", jp: "キスする", icon: Icons.favorite, category: "動詞"),

  // --- 抽象概念 ---
  Word(id: 451, sp: "Justicia", jp: "正義", icon: Icons.gavel, category: "基本"),
  Word(
      id: 452,
      sp: "Libertad",
      jp: "自由",
      icon: Icons.child_care,
      category: "基本"),
  Word(id: 453, sp: "Paz", jp: "平和", icon: Icons.back_hand, category: "基本"),
  Word(id: 454, sp: "Guerra", jp: "戦争", icon: Icons.report, category: "基本"),
  Word(
      id: 455, sp: "Historia", jp: "歴史", icon: Icons.menu_book, category: "基本"),
  Word(id: 456, sp: "Cultura", jp: "文化", icon: Icons.museum, category: "基本"),
  Word(
      id: 457,
      sp: "Religión",
      jp: "宗教",
      icon: Icons.church,
      category: "基本"), // --- 追加パック：No.461〜510（計50単語） ---
  // --- 娯楽・趣味・レジャー ---
  Word(id: 461, sp: "Dibujo", jp: "絵/図", icon: Icons.brush, category: "娯楽"),
  Word(
      id: 462,
      sp: "Pintura",
      jp: "絵画/ペンキ",
      icon: Icons.format_paint,
      category: "娯楽"),
  Word(
      id: 463,
      sp: "Fotografía",
      jp: "写真",
      icon: Icons.camera_alt,
      category: "娯楽"),
  Word(id: 464, sp: "Canto", jp: "歌", icon: Icons.mic, category: "娯楽"),
  Word(
      id: 465,
      sp: "Baile",
      jp: "ダンス",
      icon: Icons.accessibility_new,
      category: "娯楽"),
  Word(
      id: 466,
      sp: "Juego",
      jp: "遊び/ゲーム",
      icon: Icons.videogame_asset,
      category: "娯楽"),
  Word(
      id: 467,
      sp: "Juguete",
      jp: "おもちゃ",
      icon: Icons.smart_toy,
      category: "生活"),
  Word(
      id: 468,
      sp: "Colección",
      jp: "コレクション",
      icon: Icons.collections_bookmark,
      category: "娯楽"),
  Word(
      id: 469,
      sp: "Espectáculo",
      jp: "ショー/見せ物",
      icon: Icons.theater_comedy,
      category: "娯楽"),
  Word(
      id: 470,
      sp: "Entrada",
      jp: "チケット/入口",
      icon: Icons.confirmation_number,
      category: "娯楽"),

  // --- 職業・社会的な役割 ---
  Word(id: 471, sp: "Jefe", jp: "上司", icon: Icons.person, category: "職業"),
  Word(id: 472, sp: "Empleado", jp: "従業員", icon: Icons.badge, category: "職業"),
  Word(
      id: 473,
      sp: "Cliente",
      jp: "顧客",
      icon: Icons.person_outline,
      category: "職業"),
  Word(
      id: 474,
      sp: "Secretario",
      jp: "秘書",
      icon: Icons.assignment_ind,
      category: "職業"),
  Word(
      id: 475,
      sp: "Ingeniero",
      jp: "エンジニア",
      icon: Icons.engineering,
      category: "職業"),
  Word(id: 476, sp: "Abogado", jp: "弁護士", icon: Icons.gavel, category: "職業"),
  Word(
      id: 477,
      sp: "Conductor",
      jp: "運転手",
      icon: Icons.directions_car,
      category: "職業"),
  Word(id: 478, sp: "Vendedor", jp: "販売員", icon: Icons.sell, category: "職業"),
  Word(
      id: 479,
      sp: "Bombero",
      jp: "消防士",
      icon: Icons.fire_truck,
      category: "職業"),
  Word(
      id: 480,
      sp: "Soldado",
      jp: "兵士",
      icon: Icons.military_tech,
      category: "職業"),

  // --- 経済・ビジネス ---
  Word(id: 481, sp: "Precio", jp: "価格", icon: Icons.sell, category: "基本"),
  Word(
      id: 482,
      sp: "Costo",
      jp: "費用",
      icon: Icons.request_quote,
      category: "基本"),
  Word(id: 483, sp: "Gasto", jp: "出費", icon: Icons.money_off, category: "基本"),
  Word(
      id: 484,
      sp: "Ganancia",
      jp: "利益",
      icon: Icons.trending_up,
      category: "基本"),
  Word(id: 485, sp: "Impuesto", jp: "税金", icon: Icons.receipt, category: "基本"),
  Word(
      id: 486,
      sp: "Factura",
      jp: "請求書",
      icon: Icons.description,
      category: "基本"),
  Word(
      id: 487,
      sp: "Cuenta",
      jp: "口座/勘定",
      icon: Icons.account_balance_wallet,
      category: "基本"),
  Word(
      id: 488,
      sp: "Tarjeta",
      jp: "カード",
      icon: Icons.credit_card,
      category: "生活"),
  Word(id: 489, sp: "Empresa", jp: "企業", icon: Icons.business, category: "場所"),
  Word(id: 490, sp: "Mercado", jp: "市場", icon: Icons.store, category: "場所"),

  // --- 道具・キッチン・電化製品 ---
  Word(id: 491, sp: "Nevera", jp: "冷蔵庫", icon: Icons.kitchen, category: "生活"),
  Word(
      id: 492,
      sp: "Horno",
      jp: "オーブン",
      icon: Icons.outdoor_grill,
      category: "生活"),
  Word(
      id: 493,
      sp: "Microondas",
      jp: "電子レンジ",
      icon: Icons.settings_input_component,
      category: "生活"),
  Word(
      id: 494,
      sp: "Lavadora",
      jp: "洗濯機",
      icon: Icons.local_laundry_service,
      category: "生活"),
  Word(id: 495, sp: "Plancha", jp: "アイロン", icon: Icons.iron, category: "生活"),
  Word(id: 496, sp: "Secador", jp: "ドライヤー", icon: Icons.air, category: "生活"),
  Word(
      id: 497,
      sp: "Aspiradora",
      jp: "掃除機",
      icon: Icons.cleaning_services,
      category: "生活"),
  Word(id: 498, sp: "Enchufe", jp: "コンセント", icon: Icons.power, category: "生活"),
  Word(
      id: 499,
      sp: "Interruptor",
      jp: "スイッチ",
      icon: Icons.toggle_on,
      category: "生活"),
  Word(id: 500, sp: "Cable", jp: "電線/コード", icon: Icons.cable, category: "生活"),

  // --- 動詞（変化・成長・状態） ---
  Word(
      id: 501,
      sp: "Cambiar",
      jp: "変える",
      icon: Icons.published_with_changes,
      category: "動詞"),
  Word(
      id: 502,
      sp: "Crecer",
      jp: "成長する",
      icon: Icons.trending_up,
      category: "動詞"),
  Word(
      id: 503,
      sp: "Nacer",
      jp: "生まれる",
      icon: Icons.child_friendly,
      category: "動詞"),
  Word(id: 504, sp: "Morir", jp: "死ぬ", icon: Icons.person_off, category: "動詞"),
  Word(
      id: 505, sp: "Vivir", jp: "生きる/住む", icon: Icons.favorite, category: "動詞"),
  Word(
      id: 506,
      sp: "Mejorar",
      jp: "改善する",
      icon: Icons.auto_graph,
      category: "動詞"),
  Word(
      id: 507,
      sp: "Empeorar",
      jp: "悪化する",
      icon: Icons.trending_down,
      category: "動詞"),
  Word(
      id: 508,
      sp: "Continuar",
      jp: "続ける",
      icon: Icons.play_arrow,
      category: "動詞"),
  Word(id: 509, sp: "Terminar", jp: "終わる", icon: Icons.stop, category: "動詞"),
  Word(
      id: 510,
      sp: "Empezar",
      jp: "始める",
      icon: Icons.play_circle_fill,
      category: "動詞"), // --- 追加パック：No.511〜560（計50単語） ---
  // --- 形・性質・量 ---
  Word(id: 511, sp: "Círculo", jp: "円/丸", icon: Icons.circle, category: "基本"),
  Word(
      id: 512,
      sp: "Cuadrado",
      jp: "四角",
      icon: Icons.crop_square,
      category: "基本"),
  Word(
      id: 513,
      sp: "Triángulo",
      jp: "三角",
      icon: Icons.change_history,
      category: "基本"),
  Word(
      id: 514,
      sp: "Línea",
      jp: "線",
      icon: Icons.horizontal_rule,
      category: "基本"),
  Word(
      id: 515,
      sp: "Punto",
      jp: "点",
      icon: Icons.fiber_manual_record,
      category: "基本"),
  Word(id: 516, sp: "Mitad", jp: "半分", icon: Icons.contrast, category: "基本"),
  Word(id: 517, sp: "Doble", jp: "2倍の", icon: Icons.filter_2, category: "基本"),
  Word(
      id: 518,
      sp: "Vacío",
      jp: "空の",
      icon: Icons.check_box_outline_blank,
      category: "形容詞"),
  Word(id: 519, sp: "Lleno", jp: "満杯の", icon: Icons.square, category: "形容詞"),
  Word(
      id: 520,
      sp: "Pesado",
      jp: "重い",
      icon: Icons.fitness_center,
      category: "形容詞"),
  Word(id: 521, sp: "Ligero", jp: "軽い", icon: Icons.air, category: "形容詞"),

  // --- コミュニケーション・関係性 ---
  Word(
      id: 522,
      sp: "Pareja",
      jp: "パートナー/カップル",
      icon: Icons.favorite,
      category: "家族"),
  Word(id: 523, sp: "Novio", jp: "彼氏/新郎", icon: Icons.man, category: "家族"),
  Word(id: 524, sp: "Novia", jp: "彼女/新婦", icon: Icons.woman, category: "家族"),
  Word(id: 525, sp: "Vecino", jp: "隣人", icon: Icons.home_work, category: "人"),
  Word(
      id: 526, sp: "Compañero", jp: "仲間/同僚", icon: Icons.groups, category: "人"),
  Word(id: 527, sp: "Enemigo", jp: "敵", icon: Icons.dangerous, category: "人"),
  Word(id: 528, sp: "Líder", jp: "リーダー", icon: Icons.star, category: "人"),
  Word(id: 529, sp: "Famoso", jp: "有名な", icon: Icons.stars, category: "形容詞"),
  Word(
      id: 530,
      sp: "Extraño",
      jp: "奇妙な/見知らぬ",
      icon: Icons.question_mark,
      category: "形容詞"),

  // --- 動詞（精神・思考） ---
  Word(
      id: 531,
      sp: "Imaginar",
      jp: "想像する",
      icon: Icons.auto_fix_high,
      category: "動詞"),
  Word(
      id: 532,
      sp: "Creer",
      jp: "信じる",
      icon: Icons.volunteer_activism,
      category: "動詞"),
  Word(
      id: 533, sp: "Dudar", jp: "疑う", icon: Icons.help_outline, category: "動詞"),
  Word(
      id: 534,
      sp: "Preferir",
      jp: "〜を好む",
      icon: Icons.thumb_up,
      category: "動詞"),
  Word(
      id: 535,
      sp: "Parecer",
      jp: "〜のように見える",
      icon: Icons.visibility,
      category: "動詞"),
  Word(
      id: 536, sp: "Sentir", jp: "感じる", icon: Icons.front_hand, category: "動詞"),
  Word(
      id: 537,
      sp: "Esperar",
      jp: "期待する/待つ",
      icon: Icons.hourglass_empty,
      category: "動詞"),
  Word(id: 538, sp: "Aceptar", jp: "受け入れる", icon: Icons.check, category: "動詞"),
  Word(
      id: 539,
      sp: "Rechazar",
      jp: "断る/拒絶する",
      icon: Icons.close,
      category: "動詞"),
  Word(id: 540, sp: "Elegir", jp: "選ぶ", icon: Icons.touch_app, category: "動詞"),

  // --- 日用品・身の回りの物 ---
  Word(
      id: 541, sp: "Sombrilla", jp: "日傘", icon: Icons.wb_sunny, category: "生活"),
  Word(id: 542, sp: "Gafas", jp: "メガネ", icon: Icons.visibility, category: "生活"),
  Word(
      id: 543,
      sp: "Anillo",
      jp: "指輪",
      icon: Icons.panorama_fish_eye,
      category: "生活"),
  Word(id: 544, sp: "Reloj", jp: "腕時計/時計", icon: Icons.watch, category: "生活"),
  Word(id: 545, sp: "Moneda", jp: "硬貨", icon: Icons.toll, category: "生活"),
  Word(
      id: 546,
      sp: "Billete",
      jp: "紙幣/チケット",
      icon: Icons.payments,
      category: "生活"),
  Word(
      id: 547,
      sp: "Cartera",
      jp: "財布",
      icon: Icons.account_balance_wallet,
      category: "生活"),
  Word(id: 548, sp: "Paraguas", jp: "傘", icon: Icons.umbrella, category: "生活"),
  Word(
      id: 549,
      sp: "Cinturón",
      jp: "ベルト",
      icon: Icons.horizontal_split,
      category: "生活"),
  Word(id: 550, sp: "Pañuelo", jp: "ハンカチ", icon: Icons.layers, category: "生活"),

  // --- 場所・交通の続き ---
  Word(id: 551, sp: "Avenida", jp: "大通り", icon: Icons.add_road, category: "場所"),
  Word(
      id: 552,
      sp: "Puerto",
      jp: "港",
      icon: Icons.directions_boat,
      category: "場所"),
  Word(
      id: 553,
      sp: "Frontera",
      jp: "国境",
      icon: Icons.door_back_door,
      category: "場所"),
  Word(id: 554, sp: "Turismo", jp: "観光", icon: Icons.map, category: "生活"),
  Word(id: 555, sp: "Mapa", jp: "地図", icon: Icons.map, category: "生活"),
  Word(
      id: 556,
      sp: "Guía",
      jp: "案内人/ガイドブック",
      icon: Icons.explore,
      category: "人"),
  Word(id: 557, sp: "Vuelo", jp: "飛行便", icon: Icons.flight, category: "交通"),
  Word(
      id: 558,
      sp: "Maleta",
      jp: "スーツケース",
      icon: Icons.business_center,
      category: "生活"),
  Word(
      id: 559,
      sp: "Aduana",
      jp: "税関",
      icon: Icons.assignment_turned_in,
      category: "場所"),
  Word(
      id: 560,
      sp: "Destino",
      jp: "目的地",
      icon: Icons.flag,
      category: "場所"), // --- 追加パック：No.561〜610（計50単語） ---
  // --- 学問・教育・技術 ---
  Word(id: 561, sp: "Ciencia", jp: "科学", icon: Icons.science, category: "基本"),
  Word(
      id: 562, sp: "Tecnología", jp: "技術", icon: Icons.biotech, category: "基本"),
  Word(
      id: 563,
      sp: "Matemáticas",
      jp: "数学",
      icon: Icons.functions,
      category: "基本"),
  Word(
      id: 564,
      sp: "Historia",
      jp: "歴史",
      icon: Icons.history_edu,
      category: "基本"),
  Word(id: 565, sp: "Geografía", jp: "地理", icon: Icons.public, category: "基本"),
  Word(id: 566, sp: "Idioma", jp: "言語", icon: Icons.translate, category: "基本"),
  Word(id: 567, sp: "Examen", jp: "試験", icon: Icons.quiz, category: "生活"),
  Word(
      id: 568,
      sp: "Diploma",
      jp: "卒業証書/免状",
      icon: Icons.card_membership,
      category: "生活"),
  Word(
      id: 569,
      sp: "Lección",
      jp: "レッスン/授業",
      icon: Icons.menu_book,
      category: "生活"),
  Word(
      id: 570,
      sp: "Tarea",
      jp: "宿題/課題",
      icon: Icons.assignment,
      category: "生活"),

  // --- 法律・政治・社会 ---
  Word(
      id: 571,
      sp: "Gobierno",
      jp: "政府",
      icon: Icons.account_balance,
      category: "場所"),
  Word(id: 572, sp: "Estado", jp: "国家/状態", icon: Icons.flag, category: "場所"),
  Word(id: 573, sp: "Voto", jp: "投票", icon: Icons.how_to_vote, category: "基本"),
  Word(
      id: 574,
      sp: "Elección",
      jp: "選挙/選択",
      icon: Icons.how_to_reg,
      category: "基本"),
  Word(
      id: 575,
      sp: "Pueblo",
      jp: "村/人々",
      icon: Icons.holiday_village,
      category: "場所"),
  Word(id: 576, sp: "Ley", jp: "法律", icon: Icons.gavel, category: "基本"),
  Word(id: 577, sp: "Cárcel", jp: "刑務所", icon: Icons.lock, category: "場所"),
  Word(
      id: 578,
      sp: "Pena",
      jp: "罰/悲しみ",
      icon: Icons.report_problem,
      category: "基本"),
  Word(id: 579, sp: "Crimen", jp: "犯罪", icon: Icons.dangerous, category: "基本"),
  Word(
      id: 580, sp: "Víctima", jp: "犠牲者", icon: Icons.person_off, category: "人"),

  // --- 動詞（日常生活・社会生活） ---
  Word(
      id: 581,
      sp: "Ahorrar",
      jp: "貯金する/節約する",
      icon: Icons.savings,
      category: "動詞"),
  Word(id: 582, sp: "Gastar", jp: "費やす", icon: Icons.money_off, category: "動詞"),
  Word(
      id: 583,
      sp: "Ganar",
      jp: "勝つ/稼ぐ",
      icon: Icons.emoji_events,
      category: "動詞"),
  Word(
      id: 584,
      sp: "Perder",
      jp: "負ける/失う",
      icon: Icons.thumb_down,
      category: "動詞"),
  Word(id: 585, sp: "Vender", jp: "売る", icon: Icons.sell, category: "動詞"),
  Word(id: 586, sp: "Prestar", jp: "貸す", icon: Icons.handshake, category: "動詞"),
  Word(
      id: 587,
      sp: "Alquilar",
      jp: "借りる/レンタルする",
      icon: Icons.key,
      category: "動詞"),
  Word(id: 588, sp: "Firmar", jp: "署名する", icon: Icons.draw, category: "動詞"),
  Word(id: 589, sp: "Enviar", jp: "送る", icon: Icons.send, category: "動詞"),
  Word(
      id: 590,
      sp: "Recibir",
      jp: "受け取る",
      icon: Icons.move_to_inbox,
      category: "動詞"),

  // --- 建物・施設の詳細 ---
  Word(
      id: 591,
      sp: "Fábrica",
      jp: "工場",
      icon: Icons.precision_manufacturing,
      category: "場所"),
  Word(
      id: 592, sp: "Granja", jp: "農場", icon: Icons.agriculture, category: "場所"),
  Word(
      id: 593,
      sp: "Puerto",
      jp: "港",
      icon: Icons.directions_boat,
      category: "場所"),
  Word(
      id: 594, sp: "Estadio", jp: "スタジアム", icon: Icons.stadium, category: "場所"),
  Word(id: 595, sp: "Catedral", jp: "大聖堂", icon: Icons.church, category: "場所"),
  Word(id: 596, sp: "Palacio", jp: "宮殿", icon: Icons.castle, category: "場所"),
  Word(
      id: 597,
      sp: "Centro comercial",
      jp: "ショッピングセンター",
      icon: Icons.local_mall,
      category: "場所"),
  Word(
      id: 598,
      sp: "Supermercado",
      jp: "スーパーマーケット",
      icon: Icons.shopping_cart,
      category: "場所"),
  Word(
      id: 599,
      sp: "Farmacia",
      jp: "薬局",
      icon: Icons.local_pharmacy,
      category: "場所"),
  Word(
      id: 600,
      sp: "Panadería",
      jp: "パン屋",
      icon: Icons.bakery_dining,
      category: "場所"),

  // --- 性質・状態（形容詞） ---
  Word(
      id: 601,
      sp: "Lleno",
      jp: "満杯の",
      icon: Icons.battery_full,
      category: "形容詞"),
  Word(
      id: 602,
      sp: "Vacío",
      jp: "空っぽの",
      icon: Icons.battery_alert,
      category: "形容詞"),
  Word(id: 603, sp: "Rico", jp: "豊かな/美味しい", icon: Icons.euro, category: "形容詞"),
  Word(
      id: 604,
      sp: "Pobre",
      jp: "貧しい",
      icon: Icons.volunteer_activism,
      category: "形容詞"),
  Word(
      id: 605,
      sp: "Suave",
      jp: "滑らかな/柔らかい",
      icon: Icons.texture,
      category: "形容詞"),
  Word(id: 606, sp: "Duro", jp: "硬い", icon: Icons.handyman, category: "形容詞"),
  Word(
      id: 607,
      sp: "Limpio",
      jp: "清潔な",
      icon: Icons.clean_hands,
      category: "形容詞"),
  Word(
      id: 608,
      sp: "Sucio",
      jp: "汚い",
      icon: Icons.report_problem,
      category: "形容詞"),
  Word(id: 609, sp: "Famoso", jp: "有名な", icon: Icons.stars, category: "形容詞"),
  Word(
      id: 610,
      sp: "Peligroso",
      jp: "危険な",
      icon: Icons.warning,
      category: "形容詞"), // --- 追加パック：No.611〜660（計50単語） ---
  // --- メディア・通信・情報 ---
  Word(
      id: 611,
      sp: "Noticia",
      jp: "ニュース",
      icon: Icons.newspaper,
      category: "生活"),
  Word(id: 612, sp: "Artículo", jp: "記事", icon: Icons.article, category: "生活"),
  Word(
      id: 613,
      sp: "Revista",
      jp: "雑誌",
      icon: Icons.auto_stories,
      category: "生活"),
  Word(id: 614, sp: "Radio", jp: "ラジオ", icon: Icons.radio, category: "生活"),
  Word(
      id: 615,
      sp: "Anuncio",
      jp: "広告/告知",
      icon: Icons.campaign,
      category: "生活"),
  Word(
      id: 616,
      sp: "Cámara",
      jp: "カメラ",
      icon: Icons.photo_camera,
      category: "生活"),
  Word(
      id: 617,
      sp: "Señal",
      jp: "信号/電波",
      icon: Icons.signal_cellular_alt,
      category: "基本"),
  Word(id: 618, sp: "Red", jp: "ネットワーク/網", icon: Icons.lan, category: "基本"),
  Word(
      id: 619,
      sp: "Contraseña",
      jp: "パスワード",
      icon: Icons.password,
      category: "基本"),
  Word(id: 620, sp: "Enlace", jp: "リンク/縁", icon: Icons.link, category: "基本"),

  // --- 感情・心の状態（さらに詳しく） ---
  Word(
      id: 621,
      sp: "Alivio",
      jp: "安心",
      icon: Icons.sentiment_satisfied,
      category: "感情"),
  Word(
      id: 622,
      sp: "Aburrimiento",
      jp: "退屈",
      icon: Icons.sentiment_neutral,
      category: "感情"),
  Word(
      id: 623,
      sp: "Confusión",
      jp: "混乱",
      icon: Icons.psychology_alt,
      category: "感情"),
  Word(
      id: 624, sp: "Esperanza", jp: "希望", icon: Icons.wb_sunny, category: "感情"),
  Word(
      id: 625,
      sp: "Miedo",
      jp: "恐怖",
      icon: Icons.warning_amber,
      category: "感情"),
  Word(
      id: 626,
      sp: "Pena",
      jp: "恥ずかしさ/残念な気持ち",
      icon: Icons.face,
      category: "感情"),
  Word(
      id: 627, sp: "Envidia", jp: "羨望", icon: Icons.visibility, category: "感情"),
  Word(
      id: 628,
      sp: "Orgullo",
      jp: "プライド/誇り",
      icon: Icons.military_tech,
      category: "感情"),
  Word(
      id: 629, sp: "Odio", jp: "憎しみ", icon: Icons.heart_broken, category: "感情"),
  Word(id: 630, sp: "Pasión", jp: "情熱", icon: Icons.whatshot, category: "感情"),

  // --- 家事・日常の動作 ---
  Word(
      id: 631,
      sp: "Barrer",
      jp: "掃く",
      icon: Icons.cleaning_services,
      category: "動詞"),
  Word(
      id: 632,
      sp: "Planchar",
      jp: "アイロンをかける",
      icon: Icons.iron,
      category: "動詞"),
  Word(id: 633, sp: "Coser", jp: "縫う", icon: Icons.content_cut, category: "動詞"),
  Word(
      id: 634,
      sp: "Arreglar",
      jp: "整理する/修理する",
      icon: Icons.build,
      category: "動詞"),
  Word(
      id: 635,
      sp: "Quitar",
      jp: "取り除く",
      icon: Icons.remove_circle_outline,
      category: "動詞"),
  Word(
      id: 636,
      sp: "Añadir",
      jp: "加える",
      icon: Icons.add_circle_outline,
      category: "動詞"),
  Word(id: 637, sp: "Mezclar", jp: "混ぜる", icon: Icons.blender, category: "動詞"),
  Word(
      id: 638, sp: "Cortar", jp: "切る", icon: Icons.content_cut, category: "動詞"),
  Word(
      id: 639,
      sp: "Llenar",
      jp: "満たす",
      icon: Icons.format_color_fill,
      category: "動詞"),
  Word(
      id: 640,
      sp: "Vaciar",
      jp: "空にする",
      icon: Icons.delete_outline,
      category: "動詞"),

  // --- 性質・評価（形容詞） ---
  Word(
      id: 641,
      sp: "Increíble",
      jp: "信じられない",
      icon: Icons.auto_awesome,
      category: "形容詞"),
  Word(
      id: 642,
      sp: "Normal",
      jp: "普通の",
      icon: Icons.check_box_outline_blank,
      category: "形容詞"),
  Word(
      id: 643,
      sp: "Raro",
      jp: "珍しい/変な",
      icon: Icons.question_mark,
      category: "形容詞"),
  Word(
      id: 644,
      sp: "Perfecto",
      jp: "完璧な",
      icon: Icons.task_alt,
      category: "形容詞"),
  Word(
      id: 645,
      sp: "Horrible",
      jp: "恐ろしい/ひどい",
      icon: Icons.mood_bad,
      category: "形容詞"),
  Word(
      id: 646,
      sp: "Útil",
      jp: "役に立つ",
      icon: Icons.thumb_up_alt,
      category: "形容詞"),
  Word(
      id: 647,
      sp: "Inútil",
      jp: "役に立たない",
      icon: Icons.thumb_down_alt,
      category: "形容詞"),
  Word(
      id: 648,
      sp: "Propio",
      jp: "自身の/独自の",
      icon: Icons.person,
      category: "形容詞"),
  Word(
      id: 649,
      sp: "Ajeno",
      jp: "他人の",
      icon: Icons.people_outline,
      category: "形容詞"),
  Word(
      id: 650,
      sp: "Sencillo",
      jp: "シンプルな",
      icon: Icons.circle_outlined,
      category: "形容詞"),

  // --- その他・副詞的な表現 ---
  Word(id: 651, sp: "Además", jp: "さらに", icon: Icons.add, category: "基本"),
  Word(
      id: 652,
      sp: "Entonces",
      jp: "その時/それでは",
      icon: Icons.redo,
      category: "基本"),
  Word(
      id: 653,
      sp: "Cualquiera",
      jp: "誰でも/どれでも",
      icon: Icons.all_inclusive,
      category: "基本"),
  Word(
      id: 654,
      sp: "Incluso",
      jp: "〜でさえ",
      icon: Icons.priority_high,
      category: "基本"),
  Word(
      id: 655,
      sp: "Apenas",
      jp: "かろうじて",
      icon: Icons.shutter_speed,
      category: "基本"),
  Word(id: 656, sp: "Cerca", jp: "近くに", icon: Icons.near_me, category: "基本"),
  Word(
      id: 657, sp: "Lejos", jp: "遠くに", icon: Icons.explore_off, category: "基本"),
  Word(
      id: 658,
      sp: "Debajo",
      jp: "〜の下に",
      icon: Icons.arrow_downward,
      category: "基本"),
  Word(
      id: 659,
      sp: "Encima",
      jp: "〜の上に",
      icon: Icons.arrow_upward,
      category: "基本"),
  Word(
      id: 660,
      sp: "Dentro",
      jp: "中に",
      icon: Icons.input,
      category: "基本"), // --- 追加パック：No.661〜710（計50単語） ---
  // --- 自然・動物・虫 ---
  Word(id: 661, sp: "Animal", jp: "動物", icon: Icons.pets, category: "自然"),
  Word(id: 662, sp: "Perro", jp: "犬", icon: Icons.pets, category: "自然"),
  Word(id: 663, sp: "Gato", jp: "猫", icon: Icons.pets, category: "自然"),
  Word(
      id: 664,
      sp: "Caballo",
      jp: "馬",
      icon: Icons.cruelty_free,
      category: "自然"),
  Word(id: 665, sp: "Vaca", jp: "牛", icon: Icons.agriculture, category: "自然"),
  Word(id: 666, sp: "Cerdo", jp: "豚", icon: Icons.savings, category: "自然"),
  Word(id: 667, sp: "Oveja", jp: "羊", icon: Icons.cloud, category: "自然"),
  Word(
      id: 668,
      sp: "León",
      jp: "ライオン",
      icon: Icons.emoji_nature,
      category: "自然"),
  Word(
      id: 669, sp: "Pájaro", jp: "鳥", icon: Icons.flutter_dash, category: "自然"),
  Word(id: 670, sp: "Pescado", jp: "魚", icon: Icons.set_meal, category: "自然"),
  Word(id: 671, sp: "Insecto", jp: "虫", icon: Icons.bug_report, category: "自然"),
  Word(id: 672, sp: "Abeja", jp: "蜂", icon: Icons.api, category: "自然"),
  Word(
      id: 673,
      sp: "Mariposa",
      jp: "蝶",
      icon: Icons.flutter_dash,
      category: "自然"),

  // --- 材料・物質 ---
  Word(id: 674, sp: "Oro", jp: "金", icon: Icons.stars, category: "基本"),
  Word(
      id: 675,
      sp: "Plata",
      jp: "銀",
      icon: Icons.monetization_on,
      category: "基本"),
  Word(id: 676, sp: "Hierro", jp: "鉄", icon: Icons.hardware, category: "基本"),
  Word(id: 677, sp: "Piedra", jp: "石", icon: Icons.landscape, category: "基本"),
  Word(id: 678, sp: "Arena", jp: "砂", icon: Icons.grain, category: "基本"),
  Word(
      id: 679,
      sp: "Gas",
      jp: "ガス",
      icon: Icons.local_fire_department,
      category: "基本"),
  Word(id: 680, sp: "Aceite", jp: "油", icon: Icons.opacity, category: "基本"),

  // --- 身体の動き・五感 ---
  Word(
      id: 681,
      sp: "Tocar",
      jp: "触れる/弾く",
      icon: Icons.touch_app,
      category: "動詞"),
  Word(
      id: 682,
      sp: "Oler",
      jp: "においを嗅ぐ",
      icon: Icons.clean_hands,
      category: "動詞"),
  Word(
      id: 683,
      sp: "Probar",
      jp: "味わう/試す",
      icon: Icons.restaurant,
      category: "動詞"),
  Word(
      id: 684,
      sp: "Morder",
      jp: "噛む",
      icon: Icons.restaurant_menu,
      category: "動詞"),
  Word(id: 685, sp: "Tragar", jp: "飲み込む", icon: Icons.south, category: "動詞"),
  Word(id: 686, sp: "Respirar", jp: "呼吸する", icon: Icons.air, category: "動詞"),
  Word(
      id: 687, sp: "Sudar", jp: "汗をかく", icon: Icons.water_drop, category: "動詞"),
  Word(
      id: 688, sp: "Temblar", jp: "震える", icon: Icons.vibration, category: "動詞"),
  Word(id: 689, sp: "Saltar", jp: "跳ぶ", icon: Icons.north, category: "動詞"),
  Word(id: 690, sp: "Girar", jp: "回る/曲がる", icon: Icons.cached, category: "動詞"),

  // --- 状態・評価（形容詞） ---
  Word(
      id: 691,
      sp: "Ancho",
      jp: "幅が広い",
      icon: Icons.straighten,
      category: "形容詞"),
  Word(
      id: 692,
      sp: "Estrecho",
      jp: "幅が狭い",
      icon: Icons.compress,
      category: "形容詞"),
  Word(id: 693, sp: "Profundo", jp: "深い", icon: Icons.south, category: "形容詞"),
  Word(
      id: 694,
      sp: "Bajo",
      jp: "低い",
      icon: Icons.arrow_downward,
      category: "形容詞"),
  Word(
      id: 695,
      sp: "Alto",
      jp: "高い/背が高い",
      icon: Icons.arrow_upward,
      category: "形容詞"),
  Word(id: 696, sp: "Rápido", jp: "速い", icon: Icons.bolt, category: "形容詞"),
  Word(
      id: 697,
      sp: "Lento",
      jp: "遅い",
      icon: Icons.directions_walk,
      category: "形容詞"),
  Word(
      id: 698,
      sp: "Duro",
      jp: "硬い",
      icon: Icons.fitness_center,
      category: "形容詞"),
  Word(
      id: 699,
      sp: "Blando",
      jp: "柔らかい",
      icon: Icons.cloud_queue,
      category: "形容詞"),
  Word(
      id: 700,
      sp: "Áspero",
      jp: "ざらざらした",
      icon: Icons.texture,
      category: "形容詞"),

  // --- その他・基本的な語彙 ---
  Word(id: 701, sp: "Parte", jp: "部分", icon: Icons.pie_chart, category: "基本"),
  Word(id: 702, sp: "Todo", jp: "全部", icon: Icons.square, category: "基本"),
  Word(
      id: 703,
      sp: "Nada",
      jp: "何もない",
      icon: Icons.not_interested,
      category: "基本"),
  Word(id: 704, sp: "Algo", jp: "何か", icon: Icons.help_outline, category: "基本"),
  Word(
      id: 705,
      sp: "Alguien",
      jp: "誰か",
      icon: Icons.person_add_alt,
      category: "基本"),
  Word(
      id: 706,
      sp: "Nadie",
      jp: "誰も〜ない",
      icon: Icons.person_off,
      category: "基本"),
  Word(id: 707, sp: "Jamás", jp: "一度も〜ない", icon: Icons.block, category: "基本"),
  Word(
      id: 708,
      sp: "Todavía",
      jp: "まだ",
      icon: Icons.pending_actions,
      category: "基本"),
  Word(id: 709, sp: "Ya", jp: "すでに/もう", icon: Icons.done_all, category: "基本"),
  Word(
      id: 710,
      sp: "Casi",
      jp: "ほとんど",
      icon: Icons.hourglass_bottom,
      category: "基本"), // --- 追加パック：No.711〜780（計70単語） ---
  // --- 天候・自然のさらなる詳細 ---
  Word(id: 711, sp: "Niebla", jp: "霧", icon: Icons.cloud, category: "自然"),
  Word(
      id: 712,
      sp: "Trueno",
      jp: "雷鳴",
      icon: Icons.thunderstorm,
      category: "自然"),
  Word(id: 713, sp: "Sombra", jp: "影", icon: Icons.wb_shade, category: "自然"),
  Word(
      id: 714,
      sp: "Brillo",
      jp: "輝き",
      icon: Icons.auto_awesome,
      category: "自然"),
  Word(
      id: 715, sp: "Humedad", jp: "湿度", icon: Icons.water_drop, category: "自然"),
  Word(id: 716, sp: "Sequía", jp: "干ばつ", icon: Icons.wb_sunny, category: "自然"),
  Word(
      id: 717,
      sp: "Terreno",
      jp: "土地/地面",
      icon: Icons.landscape,
      category: "自然"),
  Word(id: 718, sp: "Polvo", jp: "埃/粉末", icon: Icons.grain, category: "自然"),

  // --- IT・デジタル・テクノロジー ---
  Word(
      id: 719,
      sp: "Red",
      jp: "ネットワーク",
      icon: Icons.network_check,
      category: "生活"),
  Word(
      id: 720,
      sp: "Perfil",
      jp: "プロフィール",
      icon: Icons.account_circle,
      category: "生活"),
  Word(
      id: 721,
      sp: "Archivo",
      jp: "ファイル",
      icon: Icons.insert_drive_file,
      category: "生活"),
  Word(id: 722, sp: "Buzón", jp: "受信箱/ポスト", icon: Icons.mail, category: "生活"),
  Word(
      id: 723,
      sp: "Carga",
      jp: "充電/負荷",
      icon: Icons.battery_charging_full,
      category: "生活"),
  Word(id: 724, sp: "Enlace", jp: "リンク", icon: Icons.add_link, category: "生活"),
  Word(id: 725, sp: "Nube", jp: "クラウド", icon: Icons.cloud_done, category: "生活"),
  Word(id: 726, sp: "Sitio", jp: "サイト/場所", icon: Icons.web, category: "生活"),
  Word(
      id: 727,
      sp: "Pantalla",
      jp: "画面/スクリーン",
      icon: Icons.screenshot,
      category: "生活"),
  Word(id: 728, sp: "Sonido", jp: "音", icon: Icons.volume_up, category: "生活"),

  // --- 社会・政治・経済の深掘り ---
  Word(id: 729, sp: "Sociedad", jp: "社会", icon: Icons.public, category: "基本"),
  Word(
      id: 730,
      sp: "Ciudadano",
      jp: "市民",
      icon: Icons.person_pin,
      category: "人"),
  Word(id: 731, sp: "Derechos", jp: "権利", icon: Icons.balance, category: "基本"),
  Word(id: 732, sp: "Justicia", jp: "正義", icon: Icons.gavel, category: "基本"),
  Word(
      id: 733,
      sp: "Campaña",
      jp: "キャンペーン",
      icon: Icons.campaign,
      category: "基本"),
  Word(
      id: 734,
      sp: "Inversión",
      jp: "投資",
      icon: Icons.trending_up,
      category: "基本"),
  Word(id: 735, sp: "Deuda", jp: "借金", icon: Icons.money_off, category: "基本"),
  Word(
      id: 736,
      sp: "Riqueza",
      jp: "富",
      icon: Icons.monetization_on,
      category: "基本"),
  Word(
      id: 737,
      sp: "Pobreza",
      jp: "貧困",
      icon: Icons.volunteer_activism,
      category: "基本"),
  Word(id: 738, sp: "Crisis", jp: "危機", icon: Icons.report, category: "基本"),

  // --- 高度な動詞（議論・思考・社会生活） ---
  Word(id: 739, sp: "Discutir", jp: "議論する", icon: Icons.forum, category: "動詞"),
  Word(
      id: 740,
      sp: "Convencer",
      jp: "説得する",
      icon: Icons.record_voice_over,
      category: "動詞"),
  Word(
      id: 741,
      sp: "Sugerir",
      jp: "提案する",
      icon: Icons.lightbulb,
      category: "動詞"),
  Word(
      id: 742,
      sp: "Resolver",
      jp: "解決する",
      icon: Icons.check_circle,
      category: "動詞"),
  Word(
      id: 743, sp: "Descubrir", jp: "発見する", icon: Icons.search, category: "動詞"),
  Word(
      id: 744,
      sp: "Inventar",
      jp: "発明する",
      icon: Icons.psychology,
      category: "動詞"),
  Word(
      id: 745,
      sp: "Construir",
      jp: "建設する",
      icon: Icons.architecture,
      category: "動詞"),
  Word(
      id: 746,
      sp: "Destruir",
      jp: "破壊する",
      icon: Icons.delete_forever,
      category: "動詞"),
  Word(id: 747, sp: "Aumentar", jp: "増やす", icon: Icons.add, category: "動詞"),
  Word(id: 748, sp: "Reducir", jp: "減らす", icon: Icons.remove, category: "動詞"),
  Word(
      id: 749, sp: "Permitir", jp: "許可する", icon: Icons.vpn_key, category: "動詞"),
  Word(id: 750, sp: "Prohibir", jp: "禁止する", icon: Icons.block, category: "動詞"),

  // --- 性質・評価（形容詞） ---
  Word(
      id: 751, sp: "Moderno", jp: "現代的な", icon: Icons.devices, category: "形容詞"),
  Word(
      id: 752,
      sp: "Antiguo",
      jp: "古い/古代の",
      icon: Icons.history,
      category: "形容詞"),
  Word(
      id: 753, sp: "Privado", jp: "個人の/私的な", icon: Icons.lock, category: "形容詞"),
  Word(id: 754, sp: "Público", jp: "公共の", icon: Icons.group, category: "形容詞"),
  Word(
      id: 755,
      sp: "Siguiente",
      jp: "次の",
      icon: Icons.skip_next,
      category: "基本"),
  Word(
      id: 756,
      sp: "Anterior",
      jp: "前の",
      icon: Icons.skip_previous,
      category: "基本"),
  Word(
      id: 757,
      sp: "Falso",
      jp: "偽の",
      icon: Icons.wrong_location,
      category: "形容詞"),
  Word(
      id: 758,
      sp: "Verdadero",
      jp: "真実の",
      icon: Icons.verified,
      category: "形容詞"),
  Word(
      id: 759,
      sp: "Positivo",
      jp: "肯定的な",
      icon: Icons.add_task,
      category: "形容詞"),
  Word(
      id: 760,
      sp: "Negativo",
      jp: "否定的な",
      icon: Icons.do_not_disturb_on,
      category: "形容詞"),

  // --- 抽象概念・副詞・接続詞 ---
  Word(id: 761, sp: "Opinión", jp: "意見", icon: Icons.comment, category: "基本"),
  Word(
      id: 762,
      sp: "Idea",
      jp: "アイデア",
      icon: Icons.tips_and_updates,
      category: "基本"),
  Word(
      id: 763,
      sp: "Motivo",
      jp: "理由/動機",
      icon: Icons.help_center,
      category: "基本"),
  Word(id: 764, sp: "Efecto", jp: "効果", icon: Icons.blur_on, category: "基本"),
  Word(
      id: 765,
      sp: "Resultado",
      jp: "結果",
      icon: Icons.assessment,
      category: "基本"),
  Word(id: 766, sp: "Situación", jp: "状況", icon: Icons.reorder, category: "基本"),
  Word(id: 767, sp: "Aunque", jp: "〜だけれども", icon: Icons.loop, category: "基本"),
  Word(
      id: 768,
      sp: "Mientras",
      jp: "〜の間",
      icon: Icons.pause_circle_filled,
      category: "基本"),
  Word(
      id: 769,
      sp: "Hacia",
      jp: "〜の方へ",
      icon: Icons.trending_flat,
      category: "基本"),
  Word(
      id: 770, sp: "Sobre", jp: "〜について/の上に", icon: Icons.topic, category: "基本"),

  // --- 日常の物・細部 ---
  Word(id: 771, sp: "Llave", jp: "鍵", icon: Icons.vpn_key, category: "生活"),
  Word(
      id: 772,
      sp: "Cerradura",
      jp: "錠前",
      icon: Icons.lock_open,
      category: "生活"),
  Word(id: 773, sp: "Caja", jp: "箱", icon: Icons.inventory_2, category: "生活"),
  Word(id: 774, sp: "Bolsa", jp: "袋", icon: Icons.shopping_bag, category: "生活"),
  Word(id: 775, sp: "Botella", jp: "瓶", icon: Icons.liquor, category: "生活"),
  Word(
      id: 776,
      sp: "Tapa",
      jp: "蓋",
      icon: Icons.vertical_align_bottom,
      category: "生活"),
  Word(id: 777, sp: "Cuerda", jp: "紐/ロープ", icon: Icons.gesture, category: "生活"),
  Word(id: 778, sp: "Papel", jp: "紙", icon: Icons.note, category: "生活"),
  Word(
      id: 779, sp: "Cartón", jp: "段ボール", icon: Icons.all_inbox, category: "生活"),
  Word(
      id: 780,
      sp: "Pegamento",
      jp: "糊",
      icon: Icons.layers_clear,
      category: "生活"), // --- 追加パック：No.781〜850（計70単語） ---
  // --- 芸術・文化・イベント ---
  Word(id: 781, sp: "Cultura", jp: "文化", icon: Icons.museum, category: "娯楽"),
  Word(id: 782, sp: "Poesía", jp: "詩", icon: Icons.history_edu, category: "娯楽"),
  Word(
      id: 783,
      sp: "Literatura",
      jp: "文学",
      icon: Icons.menu_book,
      category: "娯楽"),
  Word(
      id: 784,
      sp: "Escultura",
      jp: "彫刻",
      icon: Icons.architecture,
      category: "娯楽"),
  Word(
      id: 785,
      sp: "Concierto",
      jp: "コンサート",
      icon: Icons.music_note,
      category: "娯楽"),
  Word(
      id: 786, sp: "Pintura", jp: "絵画/塗装", icon: Icons.palette, category: "娯楽"),
  Word(
      id: 787,
      sp: "Danza",
      jp: "ダンス",
      icon: Icons.accessibility_new,
      category: "娯楽"),
  Word(id: 788, sp: "Cine", jp: "映画", icon: Icons.movie, category: "娯楽"),
  Word(
      id: 789,
      sp: "Fiesta",
      jp: "パーティー/祭",
      icon: Icons.celebration,
      category: "娯楽"),
  Word(
      id: 790, sp: "Premio", jp: "賞", icon: Icons.emoji_events, category: "娯楽"),

  // --- スポーツ・運動 ---
  Word(
      id: 791,
      sp: "Deporte",
      jp: "スポーツ",
      icon: Icons.sports_soccer,
      category: "娯楽"),
  Word(
      id: 792,
      sp: "Pelota",
      jp: "ボール",
      icon: Icons.sports_baseball,
      category: "娯楽"),
  Word(id: 793, sp: "Equipo", jp: "チーム/設備", icon: Icons.groups, category: "娯楽"),
  Word(
      id: 794,
      sp: "Carrera",
      jp: "レース/経歴",
      icon: Icons.directions_run,
      category: "娯楽"),
  Word(
      id: 795,
      sp: "Entrenamiento",
      jp: "トレーニング",
      icon: Icons.fitness_center,
      category: "娯楽"),
  Word(
      id: 796,
      sp: "Victoria",
      jp: "勝利",
      icon: Icons.military_tech,
      category: "娯楽"),
  Word(
      id: 797, sp: "Derrota", jp: "敗北", icon: Icons.thumb_down, category: "娯楽"),
  Word(
      id: 798,
      sp: "Campeón",
      jp: "チャンピオン",
      icon: Icons.workspace_premium,
      category: "娯楽"),
  Word(
      id: 799, sp: "Estadio", jp: "スタジアム", icon: Icons.stadium, category: "場所"),

  // --- 高度な動詞（状態変化・心理） ---
  Word(
      id: 800,
      sp: "Mejorar",
      jp: "改善する",
      icon: Icons.auto_graph,
      category: "動詞"),
  Word(
      id: 801,
      sp: "Empeorar",
      jp: "悪化する",
      icon: Icons.trending_down,
      category: "動詞"),
  Word(id: 802, sp: "Aumentar", jp: "増やす", icon: Icons.add, category: "動詞"),
  Word(id: 803, sp: "Disminuir", jp: "減らす", icon: Icons.remove, category: "動詞"),
  Word(
      id: 804,
      sp: "Aparecer",
      jp: "現れる",
      icon: Icons.visibility,
      category: "動詞"),
  Word(
      id: 805,
      sp: "Desaparecer",
      jp: "消える",
      icon: Icons.visibility_off,
      category: "動詞"),
  Word(
      id: 806,
      sp: "Reconocer",
      jp: "認める/識別する",
      icon: Icons.face,
      category: "動詞"),
  Word(
      id: 807,
      sp: "Convencer",
      jp: "納得させる",
      icon: Icons.record_voice_over,
      category: "動詞"),
  Word(id: 808, sp: "Sorprender", jp: "驚かせる", icon: Icons.bolt, category: "動詞"),
  Word(
      id: 809,
      sp: "Prometer",
      jp: "約束する",
      icon: Icons.handshake,
      category: "動詞"),
  Word(
      id: 810,
      sp: "Agradecer",
      jp: "感謝する",
      icon: Icons.volunteer_activism,
      category: "動詞"),

  // --- 性質・感覚（形容詞） ---
  Word(
      id: 811,
      sp: "Brillante",
      jp: "輝かしい",
      icon: Icons.wb_sunny,
      category: "形容詞"),
  Word(id: 812, sp: "Oscuro", jp: "暗い", icon: Icons.bedtime, category: "形容詞"),
  Word(
      id: 813,
      sp: "Húmedo",
      jp: "湿った",
      icon: Icons.water_drop,
      category: "形容詞"),
  Word(
      id: 814,
      sp: "Seco",
      jp: "乾いた",
      icon: Icons.wb_sunny_outlined,
      category: "形容詞"),
  Word(id: 815, sp: "Frío", jp: "冷たい", icon: Icons.ac_unit, category: "形容詞"),
  Word(
      id: 816, sp: "Caliente", jp: "熱い", icon: Icons.whatshot, category: "形容詞"),
  Word(id: 817, sp: "Salado", jp: "塩辛い", icon: Icons.opacity, category: "形容詞"),
  Word(
      id: 818, sp: "Amargo", jp: "苦い", icon: Icons.psychology, category: "形容詞"),
  Word(id: 819, sp: "Dulce", jp: "甘い", icon: Icons.icecream, category: "形容詞"),
  Word(
      id: 820,
      sp: "Ácido",
      jp: "酸っぱい",
      icon: Icons.bakery_dining,
      category: "形容詞"),

  // --- 時間・頻度・関係（副詞など） ---
  Word(
      id: 821,
      sp: "Siempre",
      jp: "いつも",
      icon: Icons.all_inclusive,
      category: "時"),
  Word(id: 822, sp: "Nunca", jp: "決して〜ない", icon: Icons.block, category: "時"),
  Word(id: 823, sp: "A veces", jp: "時々", icon: Icons.more_horiz, category: "時"),
  Word(id: 824, sp: "Pronto", jp: "すぐに", icon: Icons.timer_10, category: "時"),
  Word(id: 825, sp: "Tarde", jp: "遅く", icon: Icons.schedule, category: "時"),
  Word(
      id: 826,
      sp: "Temprano",
      jp: "早く",
      icon: Icons.wb_twilight,
      category: "時"),
  Word(id: 827, sp: "Todavía", jp: "まだ", icon: Icons.pending, category: "時"),
  Word(id: 828, sp: "Ya", jp: "もう/すでに", icon: Icons.done_all, category: "時"),
  Word(
      id: 829,
      sp: "Casi",
      jp: "ほとんど",
      icon: Icons.shutter_speed,
      category: "時"),
  Word(
      id: 830,
      sp: "Bastante",
      jp: "かなり",
      icon: Icons.format_list_bulleted,
      category: "時"),

  // --- 人の様子・社会的立場 ---
  Word(id: 831, sp: "Extranjero", jp: "外国人", icon: Icons.public, category: "人"),
  Word(id: 832, sp: "Turista", jp: "観光客", icon: Icons.map, category: "人"),
  Word(
      id: 833, sp: "Experto", jp: "専門家", icon: Icons.psychology, category: "人"),
  Word(id: 834, sp: "Dueño", jp: "オーナー/持ち主", icon: Icons.key, category: "人"),
  Word(id: 835, sp: "Pareja", jp: "ペア/恋人", icon: Icons.people, category: "人"),
  Word(id: 836, sp: "Enemigo", jp: "敵", icon: Icons.dangerous, category: "人"),
  Word(id: 837, sp: "Héroe", jp: "ヒーロー", icon: Icons.star, category: "人"),
  Word(id: 838, sp: "Genio", jp: "天才", icon: Icons.lightbulb, category: "人"),
  Word(id: 839, sp: "Pobre", jp: "貧乏な人", icon: Icons.person_off, category: "人"),
  Word(
      id: 840,
      sp: "Rico",
      jp: "金持ちの人",
      icon: Icons.monetization_on,
      category: "人"),

  // --- 抽象的な概念の続き ---
  Word(
      id: 841,
      sp: "Sistema",
      jp: "システム",
      icon: Icons.settings_input_component,
      category: "基本"),
  Word(id: 842, sp: "Método", jp: "方法", icon: Icons.reorder, category: "基本"),
  Word(id: 843, sp: "Objetivo", jp: "目的/目標", icon: Icons.flag, category: "基本"),
  Word(id: 844, sp: "Plan", jp: "計画", icon: Icons.event_note, category: "基本"),
  Word(
      id: 845,
      sp: "Riesgo",
      jp: "リスク",
      icon: Icons.warning_amber,
      category: "基本"),
  Word(id: 846, sp: "Éxito", jp: "成功", icon: Icons.thumb_up, category: "基本"),
  Word(
      id: 847, sp: "Fracaso", jp: "失敗", icon: Icons.thumb_down, category: "基本"),
  Word(id: 848, sp: "Suerte", jp: "運", icon: Icons.casino, category: "基本"),
  Word(
      id: 849,
      sp: "Destino",
      jp: "運命/目的地",
      icon: Icons.explore,
      category: "基本"),
  Word(
      id: 850,
      sp: "Milagro",
      jp: "奇跡",
      icon: Icons.auto_awesome,
      category: "基本"), // --- 追加パック：No.851〜920（計70単語） ---
  // --- 宇宙・科学・技術の深掘り ---
  Word(id: 851, sp: "Planeta", jp: "惑星", icon: Icons.public, category: "自然"),
  Word(id: 852, sp: "Estrella", jp: "星", icon: Icons.star, category: "自然"),
  Word(id: 853, sp: "Energía", jp: "エネルギー", icon: Icons.bolt, category: "基本"),
  Word(
      id: 854,
      sp: "Fuerza",
      jp: "力",
      icon: Icons.fitness_center,
      category: "基本"),
  Word(id: 855, sp: "Gravedad", jp: "重力", icon: Icons.south, category: "基本"),
  Word(
      id: 856,
      sp: "Experimento",
      jp: "実験",
      icon: Icons.science,
      category: "生活"),
  Word(id: 857, sp: "Dato", jp: "データ", icon: Icons.storage, category: "基本"),
  Word(id: 858, sp: "Robot", jp: "ロボット", icon: Icons.smart_toy, category: "生活"),
  Word(
      id: 859,
      sp: "Satélite",
      jp: "衛星",
      icon: Icons.settings_input_antenna,
      category: "自然"),
  Word(
      id: 860, sp: "Telescopio", jp: "望遠鏡", icon: Icons.search, category: "生活"),

  // --- 法律・権利・社会秩序 ---
  Word(
      id: 861,
      sp: "Prueba",
      jp: "証拠/テスト",
      icon: Icons.fact_check,
      category: "基本"),
  Word(id: 862, sp: "Juicio", jp: "裁判/判断", icon: Icons.gavel, category: "基本"),
  Word(
      id: 863,
      sp: "Testigo",
      jp: "目撃者/証人",
      icon: Icons.visibility,
      category: "人"),
  Word(
      id: 864,
      sp: "Culpable",
      jp: "有罪の",
      icon: Icons.report_problem,
      category: "形容詞"),
  Word(
      id: 865,
      sp: "Inocente",
      jp: "無実の/無邪気な",
      icon: Icons.child_care,
      category: "形容詞"),
  Word(id: 866, sp: "Cárcel", jp: "刑務所", icon: Icons.lock, category: "場所"),
  Word(
      id: 867,
      sp: "Policía",
      jp: "警察",
      icon: Icons.local_police,
      category: "人"),
  Word(
      id: 868,
      sp: "Seguridad",
      jp: "安全/警備",
      icon: Icons.verified_user,
      category: "基本"),
  Word(id: 869, sp: "Paz", jp: "平和", icon: Icons.front_hand, category: "基本"),
  Word(
      id: 870, sp: "Conflicto", jp: "紛争/葛藤", icon: Icons.error, category: "基本"),

  // --- 感情・人間関係の複雑な表現 ---
  Word(
      id: 871,
      sp: "Envidia",
      jp: "嫉妬",
      icon: Icons.remove_red_eye,
      category: "感情"),
  Word(
      id: 872,
      sp: "Respeto",
      jp: "尊敬",
      icon: Icons.volunteer_activism,
      category: "感情"),
  Word(
      id: 873,
      sp: "Orgullo",
      jp: "誇り",
      icon: Icons.workspace_premium,
      category: "感情"),
  Word(id: 874, sp: "Vergüenza", jp: "恥", icon: Icons.face, category: "感情"),
  Word(
      id: 875,
      sp: "Soledad",
      jp: "孤独",
      icon: Icons.person_outline,
      category: "感情"),
  Word(
      id: 876,
      sp: "Celos",
      jp: "やきもち",
      icon: Icons.visibility_off,
      category: "感情"),
  Word(id: 877, sp: "Amistad", jp: "友情", icon: Icons.groups, category: "基本"),
  Word(
      id: 878,
      sp: "Enemistad",
      jp: "敵意",
      icon: Icons.person_remove,
      category: "基本"),
  Word(id: 879, sp: "Apoyo", jp: "支援", icon: Icons.handshake, category: "基本"),
  Word(
      id: 880,
      sp: "Traición",
      jp: "裏切り",
      icon: Icons.heart_broken,
      category: "基本"),

  // --- 動作・変化（より抽象的） ---
  Word(id: 881, sp: "Avanzar", jp: "前進する", icon: Icons.forward, category: "動詞"),
  Word(id: 882, sp: "Retroceder", jp: "後退する", icon: Icons.undo, category: "動詞"),
  Word(id: 883, sp: "Ocurrir", jp: "起こる", icon: Icons.event, category: "動詞"),
  Word(
      id: 884, sp: "Suceder", jp: "続く/起こる", icon: Icons.update, category: "動詞"),
  Word(id: 885, sp: "Mantener", jp: "維持する", icon: Icons.save, category: "動詞"),
  Word(id: 886, sp: "Evitar", jp: "避ける", icon: Icons.block, category: "動詞"),
  Word(
      id: 887,
      sp: "Separar",
      jp: "分ける",
      icon: Icons.content_cut,
      category: "動詞"),
  Word(id: 888, sp: "Unir", jp: "結びつける", icon: Icons.link, category: "動詞"),
  Word(id: 889, sp: "Compartir", jp: "共有する", icon: Icons.share, category: "動詞"),
  Word(
      id: 890, sp: "Gastar", jp: "浪費する", icon: Icons.money_off, category: "動詞"),

  // --- 様子・状態を表す形容詞 ---
  Word(
      id: 891,
      sp: "Brillante",
      jp: "輝かしい",
      icon: Icons.lightbulb,
      category: "形容詞"),
  Word(id: 892, sp: "Oscuro", jp: "暗い", icon: Icons.bedtime, category: "形容詞"),
  Word(
      id: 893,
      sp: "Pesado",
      jp: "重い",
      icon: Icons.fitness_center,
      category: "形容詞"),
  Word(id: 894, sp: "Ligero", jp: "軽い", icon: Icons.air, category: "形容詞"),
  Word(id: 895, sp: "Famoso", jp: "有名な", icon: Icons.stars, category: "形容詞"),
  Word(
      id: 896,
      sp: "Desconocido",
      jp: "未知の",
      icon: Icons.help_outline,
      category: "形容詞"),
  Word(
      id: 897,
      sp: "Diferente",
      jp: "異なる",
      icon: Icons.difference,
      category: "形容詞"),
  Word(id: 898, sp: "Igual", jp: "同じ", icon: Icons.reorder, category: "形容詞"),
  Word(id: 899, sp: "Único", jp: "唯一の", icon: Icons.looks_one, category: "形容詞"),
  Word(id: 900, sp: "Común", jp: "共通の", icon: Icons.groups, category: "形容詞"),

  // --- その他・接続詞・量・頻度 ---
  Word(
      id: 901,
      sp: "Bastante",
      jp: "十分な/かなり",
      icon: Icons.done_all,
      category: "基本"),
  Word(
      id: 902,
      sp: "Suficiente",
      jp: "足りている",
      icon: Icons.check,
      category: "基本"),
  Word(
      id: 903,
      sp: "Demasiado",
      jp: "多すぎる",
      icon: Icons.warning,
      category: "基本"),
  Word(id: 904, sp: "Poco", jp: "少し", icon: Icons.remove, category: "基本"),
  Word(id: 905, sp: "Muy", jp: "とても", icon: Icons.bolt, category: "基本"),
  Word(
      id: 906,
      sp: "Tan",
      jp: "そんなに",
      icon: Icons.priority_high,
      category: "基本"),
  Word(id: 907, sp: "Solo", jp: "ただ〜だけ", icon: Icons.person, category: "基本"),
  Word(id: 908, sp: "Aún", jp: "まだ/さらに", icon: Icons.more_time, category: "基本"),
  Word(
      id: 909,
      sp: "Tal vez",
      jp: "たぶん",
      icon: Icons.question_mark,
      category: "基本"),
  Word(
      id: 910,
      sp: "Quizás",
      jp: "おそらく",
      icon: Icons.help_outline,
      category: "基本"),

  // --- 生活の中の細かな物 ---
  Word(
      id: 911,
      sp: "Sombrero",
      jp: "帽子",
      icon: Icons.theater_comedy,
      category: "衣服"),
  Word(
      id: 912,
      sp: "Cinturón",
      jp: "ベルト",
      icon: Icons.linear_scale,
      category: "衣服"),
  Word(
      id: 913,
      sp: "Botón",
      jp: "ボタン",
      icon: Icons.radio_button_checked,
      category: "生活"),
  Word(
      id: 914,
      sp: "Cremallera",
      jp: "ジッパー",
      icon: Icons.unfold_more,
      category: "生活"),
  Word(
      id: 915,
      sp: "Bolsillo",
      jp: "ポケット",
      icon: Icons.crop_portrait,
      category: "生活"),
  Word(id: 916, sp: "Joyas", jp: "宝石", icon: Icons.diamond, category: "生活"),
  Word(
      id: 917,
      sp: "Collar",
      jp: "ネックレス",
      icon: Icons.panorama_fish_eye,
      category: "生活"),
  Word(
      id: 918,
      sp: "Anillo",
      jp: "指輪",
      icon: Icons.radio_button_unchecked,
      category: "生活"),
  Word(id: 919, sp: "Reloj", jp: "時計", icon: Icons.watch, category: "生活"),
  Word(
      id: 920,
      sp: "Gafas",
      jp: "メガネ",
      icon: Icons.visibility,
      category: "生活"), // --- 完結パック：No.921〜1,000（計80単語） ---
  // --- 社会・組織・グローバル ---
  Word(id: 921, sp: "Nación", jp: "国家", icon: Icons.flag, category: "場所"),
  Word(
      id: 922,
      sp: "Universo",
      jp: "宇宙",
      icon: Icons.auto_awesome,
      category: "自然"),
  Word(id: 923, sp: "Población", jp: "人口", icon: Icons.groups, category: "基本"),
  Word(
      id: 924,
      sp: "Gobierno",
      jp: "政府",
      icon: Icons.account_balance,
      category: "場所"),
  Word(
      id: 925,
      sp: "Democracia",
      jp: "民主主義",
      icon: Icons.how_to_vote,
      category: "基本"),
  Word(id: 926, sp: "Libertad", jp: "自由", icon: Icons.wb_sunny, category: "基本"),
  Word(id: 927, sp: "Paz", jp: "平和", icon: Icons.front_hand, category: "基本"),
  Word(id: 928, sp: "Guerra", jp: "戦争", icon: Icons.report, category: "基本"),
  Word(
      id: 929,
      sp: "Frontera",
      jp: "国境",
      icon: Icons.door_back_door,
      category: "場所"),
  Word(id: 930, sp: "Idioma", jp: "言語", icon: Icons.translate, category: "基本"),

  // --- 高度な思考・精神活動 ---
  Word(
      id: 931,
      sp: "Conciencia",
      jp: "意識/良心",
      icon: Icons.psychology,
      category: "基本"),
  Word(
      id: 932,
      sp: "Sabiduría",
      jp: "知恵",
      icon: Icons.lightbulb,
      category: "基本"),
  Word(
      id: 933,
      sp: "Memoria",
      jp: "記憶/メモリー",
      icon: Icons.memory,
      category: "基本"),
  Word(
      id: 934,
      sp: "Espíritu",
      jp: "精神/魂",
      icon: Icons.auto_fix_high,
      category: "基本"),
  Word(id: 935, sp: "Destino", jp: "運命", icon: Icons.explore, category: "基本"),
  Word(
      id: 936,
      sp: "Voluntad",
      jp: "意志",
      icon: Icons.directions_run,
      category: "基本"),
  Word(id: 937, sp: "Duda", jp: "疑い", icon: Icons.help_outline, category: "感情"),
  Word(id: 938, sp: "Verdad", jp: "真実", icon: Icons.verified, category: "基本"),
  Word(
      id: 939,
      sp: "Realidad",
      jp: "現実",
      icon: Icons.visibility,
      category: "基本"),
  Word(id: 940, sp: "Fantasía", jp: "空想", icon: Icons.cloud, category: "基本"),

  // --- 生活と環境の細部 ---
  Word(id: 941, sp: "Ambiente", jp: "環境/雰囲気", icon: Icons.eco, category: "自然"),
  Word(id: 942, sp: "Recurso", jp: "資源", icon: Icons.inventory, category: "基本"),
  Word(id: 943, sp: "Origen", jp: "起源", icon: Icons.start, category: "基本"),
  Word(id: 944, sp: "Final", jp: "最後", icon: Icons.stop, category: "基本"),
  Word(id: 945, sp: "Proceso", jp: "過程", icon: Icons.reorder, category: "基本"),
  Word(id: 946, sp: "Etapa", jp: "段階", icon: Icons.reorder, category: "基本"),
  Word(id: 947, sp: "Nivel", jp: "レベル", icon: Icons.bar_chart, category: "基本"),
  Word(id: 948, sp: "Grado", jp: "度合/学位", icon: Icons.school, category: "基本"),
  Word(
      id: 949,
      sp: "Calidad",
      jp: "品質",
      icon: Icons.high_quality,
      category: "基本"),
  Word(id: 950, sp: "Cantidad", jp: "数量", icon: Icons.numbers, category: "基本"),

  // --- 動詞（まとめ・完結） ---
  Word(
      id: 951,
      sp: "Completar",
      jp: "完了させる",
      icon: Icons.task_alt,
      category: "動詞"),
  Word(
      id: 952,
      sp: "Lograr",
      jp: "達成する",
      icon: Icons.emoji_events,
      category: "動詞"),
  Word(
      id: 953,
      sp: "Prometer",
      jp: "約束する",
      icon: Icons.handshake,
      category: "動詞"),
  Word(
      id: 954,
      sp: "Imaginar",
      jp: "想像する",
      icon: Icons.auto_fix_normal,
      category: "動詞"),
  Word(id: 955, sp: "Significar", jp: "意味する", icon: Icons.info, category: "動詞"),
  Word(
      id: 956,
      sp: "Aparecer",
      jp: "現れる",
      icon: Icons.visibility,
      category: "動詞"),
  Word(
      id: 957,
      sp: "Desaparecer",
      jp: "消える",
      icon: Icons.visibility_off,
      category: "動詞"),
  Word(
      id: 958,
      sp: "Atender",
      jp: "接客する/注意を払う",
      icon: Icons.person_search,
      category: "動詞"),
  Word(
      id: 959,
      sp: "Aprovechar",
      jp: "利用する/活かす",
      icon: Icons.bolt,
      category: "動詞"),
  Word(
      id: 960,
      sp: "Disfrutar",
      jp: "楽しむ",
      icon: Icons.sentiment_very_satisfied,
      category: "動詞"),

  // --- 最後の形容詞・副詞 ---
  Word(
      id: 961,
      sp: "Posible",
      jp: "可能な",
      icon: Icons.check_circle_outline,
      category: "形容詞"),
  Word(
      id: 962,
      sp: "Imposible",
      jp: "不可能な",
      icon: Icons.cancel,
      category: "形容詞"),
  Word(
      id: 963,
      sp: "Probable",
      jp: "ありそうな",
      icon: Icons.query_builder,
      category: "形容詞"),
  Word(
      id: 964,
      sp: "Seguro",
      jp: "確実な/安全な",
      icon: Icons.security,
      category: "形容詞"),
  Word(id: 965, sp: "Especial", jp: "特別な", icon: Icons.star, category: "形容詞"),
  Word(id: 966, sp: "General", jp: "一般的な", icon: Icons.public, category: "形容詞"),
  Word(
      id: 967,
      sp: "Principal",
      jp: "主要な",
      icon: Icons.label_important,
      category: "形容詞"),
  Word(
      id: 968,
      sp: "Secundario",
      jp: "副次的な",
      icon: Icons.label,
      category: "形容詞"),
  Word(id: 969, sp: "Actual", jp: "現在の", icon: Icons.today, category: "形容詞"),
  Word(id: 970, sp: "Pasado", jp: "過去の", icon: Icons.history, category: "形容詞"),

  // --- 最後を締めくくる表現 ---
  Word(id: 971, sp: "Próximo", jp: "次の", icon: Icons.skip_next, category: "基本"),
  Word(id: 972, sp: "Último", jp: "最後の", icon: Icons.last_page, category: "基本"),
  Word(id: 973, sp: "Juntos", jp: "一緒に", icon: Icons.people, category: "基本"),
  Word(
      id: 974,
      sp: "Separados",
      jp: "離れて",
      icon: Icons.unfold_less,
      category: "基本"),
  Word(id: 975, sp: "Cerca", jp: "近くに", icon: Icons.near_me, category: "基本"),
  Word(
      id: 976, sp: "Lejos", jp: "遠くに", icon: Icons.explore_off, category: "基本"),
  Word(
      id: 977, sp: "Alrededor", jp: "周りに", icon: Icons.refresh, category: "基本"),
  Word(id: 978, sp: "Atrás", jp: "後ろに", icon: Icons.arrow_back, category: "基本"),
  Word(
      id: 979,
      sp: "Adelante",
      jp: "前へ",
      icon: Icons.arrow_forward,
      category: "基本"),
  Word(
      id: 980,
      sp: "Arriba",
      jp: "上に",
      icon: Icons.arrow_upward,
      category: "基本"),
  Word(
      id: 981,
      sp: "Abajo",
      jp: "下に",
      icon: Icons.arrow_downward,
      category: "基本"),
  Word(
      id: 982,
      sp: "Derecha",
      jp: "右",
      icon: Icons.keyboard_arrow_right,
      category: "基本"),
  Word(
      id: 983,
      sp: "Izquierda",
      jp: "左",
      icon: Icons.keyboard_arrow_left,
      category: "基本"),
  Word(id: 984, sp: "Pronto", jp: "すぐに", icon: Icons.speed, category: "時"),
  Word(id: 985, sp: "Luego", jp: "後で", icon: Icons.update, category: "時"),
  Word(id: 986, sp: "Ahora", jp: "今", icon: Icons.alarm_on, category: "時"),
  Word(id: 987, sp: "Aquí", jp: "ここ", icon: Icons.location_on, category: "場所"),
  Word(
      id: 988, sp: "Allí", jp: "あそこ", icon: Icons.location_off, category: "場所"),
  Word(
      id: 989,
      sp: "Cualquier",
      jp: "どんな〜でも",
      icon: Icons.all_inclusive,
      category: "基本"),
  Word(
      id: 990,
      sp: "Cada",
      jp: "各〜/毎に",
      icon: Icons.event_repeat,
      category: "基本"),
  Word(id: 991, sp: "Mismo", jp: "同じ", icon: Icons.copy_all, category: "基本"),
  Word(id: 992, sp: "Otro", jp: "別の", icon: Icons.alt_route, category: "基本"),
  Word(id: 993, sp: "Algo", jp: "何か", icon: Icons.help_outline, category: "基本"),
  Word(
      id: 994,
      sp: "Nada",
      jp: "何も〜ない",
      icon: Icons.not_interested,
      category: "基本"),
  Word(
      id: 995, sp: "Alguien", jp: "誰か", icon: Icons.person_add, category: "基本"),
  Word(
      id: 996,
      sp: "Nadie",
      jp: "誰も〜ない",
      icon: Icons.person_off,
      category: "基本"),
  Word(id: 997, sp: "Éxito", jp: "成功", icon: Icons.thumb_up, category: "基本"),
  Word(
      id: 998,
      sp: "Gracias",
      jp: "ありがとう",
      icon: Icons.volunteer_activism,
      category: "基本"),
  Word(
      id: 999,
      sp: "Adiós",
      jp: "さようなら",
      icon: Icons.exit_to_app,
      category: "基本"),
  Word(
      id: 1000,
      sp: "Mañana",
      jp: "明日/朝",
      icon: Icons.wb_twilight,
      category: "時"),
];
// 私は、ここに広告ユニットIDを貼り付けます
final String adUnitId =
    'ca-app-pub-1313663524693433/6230919662'; // ここを広告ユニットIDに！'; // ここを広告ユニットIDに！
