import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/chat_message.dart';
import '../services/gemini_service.dart';
import '../widgets/chat_bubble.dart';
import '../providers/language_provider.dart';
import '../extensions/string_extensions.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
    _textController.addListener(() {
      setState(() {}); // Update UI when text changes
    });
  }

  void _loadChatHistory() async {
    final history = await GeminiService.loadChatHistory();
    if (mounted) {
      setState(() {
        _messages.addAll(history);
      });
    }
  }

  void _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isLoading) return;

    final userMessage = ChatMessage.user(text);
    final loadingMessage = ChatMessage.loading();

    setState(() {
      _messages.add(userMessage);
      _messages.add(loadingMessage);
      _isLoading = true;
    });

    _textController.clear();
    _scrollToBottom();

    try {
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      final response = await GeminiService.sendMessage(
        text, 
        language: languageProvider.locale.languageCode,
      );

      setState(() {
        _messages.removeLast(); // Remove loading message
        _messages.add(ChatMessage.ai(response));
        _isLoading = false;
      });

      _scrollToBottom();
      await GeminiService.saveChatHistory(_messages);
    } catch (e) {
      setState(() {
        _messages.removeLast(); // Remove loading message
        _messages.add(ChatMessage.ai('error_message'.tr(context)));
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('clear_chat'.tr(context)),
        content: Text('clear_chat_confirmation'.tr(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr(context)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _messages.clear();
              });
              Navigator.pop(context);
            },
            child: Text('clear'.tr(context)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.smart_toy,
                color: colorScheme.onPrimary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تراثنا AI',
                    style: GoogleFonts.playfairDisplay(
                      color: colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Algeria Heritage Assistant',
                    style: GoogleFonts.montserrat(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _clearChat,
            icon: Icon(
              Icons.refresh,
              color: colorScheme.onSurfaceVariant,
            ),
            tooltip: 'clear_chat'.tr(context),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _buildWelcomeScreen(colorScheme)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return ChatBubble(message: _messages[index]);
                    },
                  ),
          ),
          _buildInputArea(colorScheme),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen(ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Logo and Title
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primary.withAlpha(179),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.smart_toy,
              size: 48,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'مرحباً بك في تراثنا AI',
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Your Algeria Heritage Assistant',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withAlpha(128),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '🇩🇿 Algeria Topics Only',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),

          // Features Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildFeatureCard(
                colorScheme,
                Icons.location_city,
                'Historical Sites',
                'المواقع التاريخية',
              ),
              _buildFeatureCard(
                colorScheme,
                Icons.museum,
                'Museums',
                'المتاحف',
              ),
              _buildFeatureCard(
                colorScheme,
                Icons.festival,
                'Traditions',
                'التقاليد',
              ),
              _buildFeatureCard(
                colorScheme,
                Icons.landscape,
                'Tourism',
                'السياحة',
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Sample Questions
          Text(
            'Try asking me about:',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          ..._buildSampleQuestions(colorScheme),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(ColorScheme colorScheme, IconData icon, String title, String arabicTitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            arabicTitle,
            style: GoogleFonts.montserrat(
              fontSize: 10,
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSampleQuestions(ColorScheme colorScheme) {
    final questions = [
      'Tell me about Bordj El Mokrani fortress',
      'كل الآثار التاريخية في الجزائر',
      'What are Algeria\'s UNESCO World Heritage sites?',
      'أخبرني عن القصبة في الجزائر العاصمة',
      'Parlez-moi des sites de Djémila et Timgad',
      'What is the history of Tipaza ruins?',
      'ما هي أشهر المواقع الأثرية في الجزائر؟',
      'Tell me about Tassili N\'Ajjer rock art',
      'أخبرني عن تاريخ الأمير عبد القادر',
      'Quels sont les monuments islamiques en Algérie?',
    ];

    return questions.map((question) =>
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          onTap: () {
            _textController.text = question;
            _sendMessage();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outlineVariant,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 16,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).toList();
  }

  Widget _buildInputArea(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withAlpha(128),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Ask about Algeria\'s heritage, history, culture...',
                  hintStyle: GoogleFonts.montserrat(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                enabled: !_isLoading,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: _textController.text.trim().isEmpty || _isLoading
                  ? colorScheme.surfaceContainerHighest
                  : colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _isLoading || _textController.text.trim().isEmpty
                  ? null
                  : _sendMessage,
              icon: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.send,
                      color: _textController.text.trim().isEmpty
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onPrimary,
                      size: 20,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
