import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../../../providers/language_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../services/gemini_service.dart';

class CompanionScreen extends ConsumerStatefulWidget {
  const CompanionScreen({super.key});

  @override
  ConsumerState<CompanionScreen> createState() => _CompanionScreenState();
}

class _CompanionScreenState extends ConsumerState<CompanionScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  bool _sttAvailable = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _sttAvailable = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted) setState(() => _isListening = false);
        }
      },
      onError: (errorNotification) {
        if (mounted) {
          setState(() => _isListening = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Voice Input Error: ${errorNotification.errorMsg}. Ensure Google Voice Typing supports this language.'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
    if (mounted) setState(() {});
  }

  Future<void> _speakMessage(String text) async {
    final lang = ref.read(languageProvider);
    String localeId;
    switch (lang) {
      case AppLanguage.amharic: localeId = 'am-ET'; break;
      case AppLanguage.tigrigna: localeId = 'ti-ET'; break;
      case AppLanguage.oromo: localeId = 'om-ET'; break;
      default: localeId = 'en-US';
    }
    
    await _flutterTts.stop();

    try {
      final isAvailable = await _flutterTts.isLanguageAvailable(localeId);
      if (isAvailable != true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Text-to-Speech pack for $localeId not installed natively. Please download it in your device settings.'),
              backgroundColor: AppColors.warning,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      await _flutterTts.setLanguage(localeId);
      final cleanText = text.replaceAll(RegExp(r'\*|\#|_'), '');
      await _flutterTts.speak(cleanText);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Voice Engine Error: Unable to play audio.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _listen() async {
    if (!_sttAvailable) {
      _initSpeech();
      return;
    }
    
    if (_isListening) {
      setState(() => _isListening = false);
      _speech.stop();
    } else {
      final lang = ref.read(languageProvider);
      String localeId;
      switch (lang) {
        case AppLanguage.amharic: localeId = 'am_ET'; break;
        case AppLanguage.tigrigna: localeId = 'ti_ET'; break;
        case AppLanguage.oromo: localeId = 'om_ET'; break;
        default: localeId = 'en_US';
      }

      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) {
          setState(() {
            _textController.text = val.recognizedWords;
          });
        },
        localeId: localeId.replaceAll('_', '-'), // Ensure format consistency
      );
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _flutterTts.stop();
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _send() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    ref.read(chatProvider.notifier).sendMessage(text);

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.watch(localizationsProvider);

    // Listen for new messages to trigger TTS
    ref.listen<List<ChatMessage>>(chatProvider, (previous, next) {
      if (previous != null && next.isNotEmpty && previous.isNotEmpty) {
        final lastNext = next.last;
        final lastPrev = previous.last;
        if (!lastNext.isUser && !lastNext.isLoading && lastPrev.isLoading) {
          _speakMessage(lastNext.text);
        }
      }
    });

    final messages = ref.watch(chatProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF0F8F5),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF0F8F5),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Center(child: Text('🌿', style: TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Letena',
                  style: TextStyle(fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  l10n.companionRole,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 11,
                    color: isDark ? Colors.white60 : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.read(geminiServiceProvider).resetSession();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Conversation reset! Starting fresh 🌱'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick prompts
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                l10n.imStressed,
                l10n.guideMeditation,
                'Breathing exercise',
                'Journal prompt ✍️',
                'Sleep tips 🌙',
                'I feel burnout 🔥',
              ].map((prompt) {
                return GestureDetector(
                  onTap: () {
                    _textController.text = prompt;
                    _send();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Text(
                      prompt,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (ctx, i) {
                final msg = messages[i];
                return _ChatBubble(message: msg, isDark: isDark)
                    .animate(key: ValueKey(i))
                    .fadeIn(duration: 300.ms)
                    .slideY(begin: 0.3, end: 0);
              },
            ),
          ),

          // Input bar
          Container(
            padding: EdgeInsets.only(
              left: 16, right: 16,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Voice button
                GestureDetector(
                  onTap: _listen,
                  child: Container(
                    width: 44,
                    height: 44,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: _isListening ? Colors.red.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isListening ? Icons.mic_off_rounded : Icons.mic_rounded, 
                      color: _isListening ? Colors.red : AppColors.primary, 
                      size: 22
                    ),
                  ),
                ),

                // Text input
                Expanded(
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    maxLines: 4,
                    minLines: 1,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: l10n.talkToCompanion,
                      hintStyle: const TextStyle(fontFamily: 'Nunito', color: AppColors.textMuted),
                      filled: true,
                      fillColor: isDark ? AppColors.cardDark : const Color(0xFFF0F5F3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Send button
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isDark;

  const _ChatBubble({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8, bottom: 2),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Center(child: Text('🌿', style: TextStyle(fontSize: 16))),
            ),
          ],

          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: isUser ? AppColors.primaryGradient : null,
                color: isUser ? null : (isDark ? AppColors.cardDark : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: message.isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (i) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 6, height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ).animate(delay: Duration(milliseconds: i * 200))
                            .fadeIn(duration: 300.ms)
                            .then()
                            .fadeOut(duration: 300.ms)
                            .then()
                            .fadeIn(duration: 300.ms);
                      }),
                    )
                  : Text(
                      message.text,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        color: isUser ? Colors.white : (isDark ? Colors.white : AppColors.textPrimary),
                        height: 1.5,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

