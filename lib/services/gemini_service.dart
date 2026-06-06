import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  GenerativeModel? _model;
  ChatSession? _session;

  static const String _systemPrompt = '''
You are SERO, a compassionate, warm, and encouraging AI wellness companion for SERENE AI — Africa's mental wellness platform.

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

Language: Respond in English by default. If user writes in Amharic or Tigrigna, respond in that language.

Always end your first message with a wellness question to understand the user\'s current state.
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
    if (_session == null) {
      return _getMockResponse(message);
    }

    try {
      final response = await _session!.sendMessage(Content.text(message));
      return response.text ?? "I'm here with you. Let's take this one step at a time. 💚";
    } catch (e) {
      return _getMockResponse(message);
    }
  }

  String _getMockResponse(String message) {
    final lower = message.toLowerCase();

    if (lower.contains('stress') || lower.contains('anxious') || lower.contains('overwhelm')) {
      return "I hear you — stress can feel so heavy. 💚 Let\'s try a quick reset: breathe in for 4 counts, hold for 7, exhale for 8. Do this 3 times. You\'re stronger than this feeling. How long have you been feeling this way?";
    }
    if (lower.contains('tired') || lower.contains('exhausted') || lower.contains('burnout')) {
      return "Burnout is your body asking for care — and you\'re wise to listen. 🌿 Tonight, could you do one kind thing for yourself? Even 20 minutes of rest, a warm drink, or stepping outside counts. What does self-care look like for you right now?";
    }
    if (lower.contains('happy') || lower.contains('great') || lower.contains('good')) {
      return "That\'s wonderful to hear! 🌟 Positive moments are worth celebrating and anchoring. What do you think contributed to this feeling today? Let\'s make sure we can recreate it!";
    }
    if (lower.contains('sleep') || lower.contains('insomnia')) {
      return "Quality sleep is one of your most powerful wellness tools. 🌙 Try this tonight: no screens 1 hour before bed, dim your lights, and do 5 minutes of deep breathing. Would you like me to guide you through a bedtime routine?";
    }
    if (lower.contains('meditat') || lower.contains('breath')) {
      return "Let\'s begin. 🧘 Find a comfortable position and close your eyes. Breathe in slowly for 4 counts... hold for 4... breathe out for 6. Feel your shoulders drop with each exhale. You\'re doing wonderfully. Continue for 5 minutes and notice how you feel.";
    }
    if (lower.contains('journal')) {
      return "Journaling is such a powerful practice. ✍️ Here\'s a prompt for today: *\"What is one thing I did today that I\'m proud of, no matter how small?\"* There are no wrong answers — just your honest, beautiful thoughts. I\'m here when you\'re done.";
    }
    if (lower.contains('water') || lower.contains('drink') || lower.contains('hydrat')) {
      return "Great reminder! 💧 Dehydration quietly affects mood, focus, and energy — often without us realizing. Your goal: 8 glasses today. If plain water feels boring, add a slice of lemon or cucumber. How many glasses have you had so far?";
    }

    return "I\'m SERO, your wellness companion. 💚 I\'m here to help you prevent burnout, build healthy habits, and thrive — one day at a time. How are you feeling right now, and what would you most like support with today?";
  }

  void resetSession() {
    if (_model != null) {
      _session = _model!.startChat();
    }
  }
}

// Provider
final geminiServiceProvider = Provider<GeminiService>((ref) {
  final service = GeminiService();
  service.initialize();
  return service;
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final GeminiService _service;

  ChatNotifier(this._service) : super([
    ChatMessage(
      text: "Hi! I\'m SERO, your personal wellness companion. 💚\n\nI\'m here to help you prevent burnout, build healthy habits, and thrive — every single day.\n\nHow are you feeling right now?",
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
  return ChatNotifier(service);
});

