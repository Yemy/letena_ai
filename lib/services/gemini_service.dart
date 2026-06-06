import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../providers/language_provider.dart';
import '../core/localization/app_localizations.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isLoading;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isLoading = false,
  });
}

class GeminiService {
  final AppLocalizations l10n;
  GenerativeModel? _model;
  ChatSession? _session;

  GeminiService(this.l10n);

  AppLanguage get currentLanguage => l10n.language;

  String get _systemPrompt => '''
You are Letena, a compassionate, warm, and encouraging AI wellness companion for SERENE AI — Africa's mental wellness platform.

Your role:
- Act as a mental wellness coach, accountability partner, and caring friend
- Help users prevent burnout, reduce stress, and build healthy habits
- Provide evidence-based wellness guidance using CBT, positive psychology, and mindfulness
- Be culturally aware of African contexts (Ethiopia, East Africa, urban and rural settings)
- Never diagnose, prescribe medication, or replace professional mental health care
- Always encourage users to seek professional help when needed
- Celebrate every small win with genuine enthusiasm
- Speak with warmth, compassion, and zero judgment
- Keep responses concise (3-4 sentences max unless user needs more)
- Offer actionable, specific suggestions
- Occasionally use encouraging phrases like "You\'ve got this!", "That\'s a real win.", "I\'m proud of you."
- If user seems in crisis, express care and gently guide to emergency resources

Capabilities you can guide users through:
- Breathing exercises (4-7-8, box breathing, diaphragmatic)
- Journaling prompts
- Guided meditation (describe it step by step)
- Stress relief techniques
- Sleep hygiene tips
- Nutrition and hydration reminders
- Exercise motivation
- Digital detox strategies
- Gratitude practices
- Positive affirmations

Language: ALWAYS respond and communicate in ${currentLanguage.displayName}. All your outputs MUST be in this language.

Always end your first message with a wellness question to understand the user's current state in ${currentLanguage.displayName}.
''';

  Future<void> initialize() async {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty || apiKey == 'your_gemini_api_key_here') {
      return; // Will use mock mode
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(_systemPrompt),
      generationConfig: GenerationConfig(
        temperature: 0.8,
        maxOutputTokens: 512,
      ),
    );
    _session = _model!.startChat();
  }

  Future<String> sendMessage(String message) async {
    // Prepend a hard language enforcement instruction to every user message
    // so the AI model cannot ignore the selected language, even mid-session.
    final langName = currentLanguage.displayName;
    final enforcedMessage =
        '[IMPORTANT: You MUST respond ONLY in $langName. Do not use any other language.] $message';

    if (_session == null) {
      return _getMockResponse(message);
    }

    try {
      final response = await _session!.sendMessage(Content.text(enforcedMessage));
      return response.text ?? l10n.defaultFallback;
    } catch (e) {
      return _getMockResponse(message);
    }
  }

  String _getMockResponse(String message) {
    final lower = message.toLowerCase();
    final lang = currentLanguage;

    if (lower.contains('stress') || lower.contains('anxious') || lower.contains('overwhelm')
        || lower.contains('ጭንቀት') || lower.contains('ጭቅ') || lower.contains('ጨነቀ')) {
      switch (lang) {
        case AppLanguage.amharic:
          return 'ጭንቀቱን ሰማሁ። 💚 ፈጣን ዳሰሳ እንሞክር፦ 4 ጊዜ ትንፋሽ ጠጣ፣ 7 ጊዜ ያዝ፣ 8 ጊዜ ለቀቅ። ይህን 3 ጊዜ ደግም። ስንት ጊዜ ሆኖ ይሰማዎታል?';
        case AppLanguage.tigrigna:
          return 'ጭንቀትካ ሰሚዔ። 💚 ቅልጡፍ ምልምማድ ንፈትን፦ 4 ግዜ ትንፋስ ሓዝ፣ 7 ግዜ ደው ኣብሎ፣ 8 ግዜ ለቀቖ። ይህን 3 ጊዜ ደጋግሞ። ክንደይ ዘምሓቈ ይስምዓካ ኣሎ?';
        case AppLanguage.oromo:
          return 'Dhiphina kee dhageaye. 💚 Haalduree tokko yaaluu: yeroo 4 hafuura fuudhi, yeroo 7 qabi, yeroo 8 gadi lakkisi. Kana yeroo 3 irradeebi. Yoom irraa dhufe?';
        default:
          return "I hear you — stress can feel so heavy. 💚 Let\'s try a quick reset: breathe in for 4 counts, hold for 7, exhale for 8. Do this 3 times. How long have you been feeling this way?";
      }
    }
    if (lower.contains('tired') || lower.contains('exhausted') || lower.contains('burnout')
        || lower.contains('ደክሞ') || lower.contains('ድካም')) {
      switch (lang) {
        case AppLanguage.amharic:
          return 'ድካምዎ ሰምቻለሁ። 🌿 ዛሬ ምሽት ለራስዎ አንድ ደግ ነገር ማድረግ ይችሉ ይሆን? 20 ደቂቃ እረፍት፣ ሞቃት መጠጥ፣ ወይም ወጥቶ ትንሽ ሽር ሽር — እነዚህ ሁሉ ይቆጠራሉ። አሁን ለልብዎ ምን ይሰማዎታል?';
        case AppLanguage.tigrigna:
          return 'ድካምካ ሰሚዔ። 🌿 ሎሚ ምሸት ንርእስካ ሓደ ጽቡቕ ነገር ክትገብር ትኽእል? ዕረፍቲ፣ ምሁር መስተ፣ ወይ ወጺእካ ምስሓር — ኩሎም ይቁጸሩ። ሕጂ ንርእስካ ከምቲ ዝስምዓካ?';
        case AppLanguage.oromo:
          return 'Dadhabbiikee dheengaddhe. 🌿 Halkan kana of-duraa tokko tolchuu dandeessaa? Boqonnaa, dhugaatii ho\'aa, ykn gadi ba\'uun deemuu — hundinuu lakkaa\'ifama. Amma ofii keetif maaltu dhaga\'amaa jira?';
        default:
          return "Burnout is your body asking for care — and you\'re wise to listen. 🌿 Tonight, could you do one kind thing for yourself? Even 20 minutes of rest counts. What does self-care look like for you right now?";
      }
    }
    if (lower.contains('happy') || lower.contains('great') || lower.contains('good')
        || lower.contains('ደስ') || lower.contains('ጥሩ')) {
      switch (lang) {
        case AppLanguage.amharic:
          return 'ይህን ሲሰሙ ደስ ይሰኛል! 🌟 አዎንታዊ ስሜቶች ሊያከብሩ ይገባቸዋል። ዛሬ ይህን ስሜት ላሳዎ ያስበዎ ምን ይሆናል? 다시 ልናቋቁመው!';
        case AppLanguage.tigrigna:
          return 'ሰሚዔ ደስ ይብለኒ! 🌟 ኣወንታዊ ስምዒታት ኣብዕሎ። ሎሚ እቲ ስምዒት ዝምጸኣካ ምንታይ ይኸውን? ደጊምና ነቚሞ!';
        case AppLanguage.oromo:
          return 'Dhagahuun gammachuu! 🌟 Yeroo mijaa\'aa ta\'uu beekuu barbaachisa. Har\'a maaltu si gammachiise? Deebi\'uu danda\'uu haa qopheessinuu!';
        default:
          return "That\'s wonderful to hear! 🌟 Positive moments are worth celebrating. What do you think contributed to this feeling today? Let\'s recreate it!";
      }
    }
    if (lower.contains('sleep') || lower.contains('insomnia')
        || lower.contains('እንቅልፍ') || lower.contains('ምነቃቅ')) {
      switch (lang) {
        case AppLanguage.amharic:
          return 'ጥሩ እንቅልፍ ህወታችን ቁልፍ ነው። 🌙 ዛሬ ሲተኙ ሞክሩ፦ ከ1 ሰዓት በፊት ማያ ፈካ ያቁሙ፣ ቀላል ብርሃን ያድርጉ፣ 5 ደቂቃ ጠልቅ ትንፋሽ ይምሩ። የምሽት ልምዱ ይፈልጋሉ?';
        case AppLanguage.tigrigna:
          return 'ጽቡቕ ምሕዳር ቁልፊ ናይ ጥዕናና ኢዩ። 🌙 ሎሚ ምሸት ፈትን፦ ቅድሚ 1 ሰዓት ናይ ስክሪን ግዜ ደው ኣብሎ፣ ቀሊል ብርሃን ግበር፣ 5 ደቒቕ ጸሎት ትንፋስ ይምሪ። ናይ ምሸት ልምዲ ትደሊ?';
        case AppLanguage.oromo:
          return 'Hirriba gaarii fayyummaaf barbaachisaadha. 🌙 Halkan kana yaaluu: sa\'atii 1 dura screen dhaabuun, ifa xiqqeessuu, daqiiqaa 5 hafuura gaaddii fudhachuu. Sagantaa halkan barbaaddaa?';
        default:
          return "Quality sleep is one of your most powerful wellness tools. 🌙 No screens 1 hour before bed, dim lights, and 5 minutes of deep breathing. Would you like me to guide you through a bedtime routine?";
      }
    }
    if (lower.contains('meditat') || lower.contains('breath')
        || lower.contains('ማሰላሰል') || lower.contains('ትንፋሽ')) {
      switch (lang) {
        case AppLanguage.amharic:
          return 'ይጀምሩ። 🧘 ምቹ ቦታ ያዙ ዓይኖቶን ዝጉ። በቀስታ 4 ጊዜ ትንፋሽ ጠጡ... 4 ጊዜ ያዙ... 6 ጊዜ ለቀቁ። ሁሉ ጊዜ ትከሻዎ ወደ ታች ይወርዳሉ። ለ5 ደቂቃ ቀጥሉ።';
        case AppLanguage.tigrigna:
          return 'ንጅምር። 🧘 ምቹ ቦታ ሒዝካ ዓይንኻ ዕጸዎ። ብቀስታ 4 ግዜ ትንፋስ ሓዝ... 4 ግዜ ደው ኣብሎ... 6 ግዜ ለቐቖ። ነፍሲ ወከፍ ምስ ወጽዐ ሸፍተካ ወደ ታች ትወርድ። ን5 ደቒቕ ቀጽሎ።';
        case AppLanguage.oromo:
          return 'Haa jalqabnu. 🧘 Bakka mijaa\'aa qabadhu, ija cufadhu. Baay\'ee gadi ta\'un yeroo 4 hafuura fuudhi... yeroo 4 qabi... yeroo 6 gadi lakkisi. Yeroo 5 ittifufi.';
        default:
          return "Let\'s begin. 🧘 Find a comfortable position and close your eyes. Breathe in slowly for 4 counts... hold for 4... breathe out for 6. Continue for 5 minutes.";
      }
    }

    return l10n.defaultFallback;
  }

  void resetSession() {
    if (_model != null) {
      _session = _model!.startChat();
    }
  }
}

// Provider
final geminiServiceProvider = Provider<GeminiService>((ref) {
  final l10n = ref.watch(localizationsProvider);
  final service = GeminiService(l10n);
  service.initialize();
  return service;
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final GeminiService _service;

  ChatNotifier(this._service, AppLocalizations l10n) : super([
    ChatMessage(
      text: l10n.greetingMessage,
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ]);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    state = [
      ...state,
      ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      ChatMessage(text: '', isUser: false, timestamp: DateTime.now(), isLoading: true),
    ];
    _isLoading = true;

    final response = await _service.sendMessage(text);
    _isLoading = false;

    // Replace loading with actual response
    final updated = List<ChatMessage>.from(state)..removeLast();
    updated.add(ChatMessage(text: response, isUser: false, timestamp: DateTime.now()));
    state = updated;
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  final service = ref.watch(geminiServiceProvider);
  final l10n = ref.watch(localizationsProvider);
  return ChatNotifier(service, l10n);
});

