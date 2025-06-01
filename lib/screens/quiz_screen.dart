import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../extensions/string_extensions.dart';
import '../providers/language_provider.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;
  final String languageCode;

  const QuizScreen({Key? key, required this.quiz, required this.languageCode}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  List<int?> _userAnswers = [];
  bool _answerSelected = false;
  int? _selectedAnswerIndex;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _userAnswers = List.filled(widget.quiz.questions.length, null);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectAnswer(int answerIndex) {
    if (_answerSelected) return;

    setState(() {
      _selectedAnswerIndex = answerIndex;
      _answerSelected = true;
      _userAnswers[_currentQuestionIndex] = answerIndex;

      if (answerIndex == widget.quiz.questions[_currentQuestionIndex].correctAnswerIndex) {
        _score += widget.quiz.points;
      }
    });

    // Wait before moving to next question
    Future.delayed(const Duration(seconds: 1), () {
      if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
        _animationController.reverse().then((_) {
          setState(() {
            _currentQuestionIndex++;
            _answerSelected = false;
            _selectedAnswerIndex = null;
          });
          _animationController.forward();
        });
      } else {
        setState(() {
          _quizCompleted = true;
        });
      }
    });
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _quizCompleted = false;
      _userAnswers = List.filled(widget.quiz.questions.length, null);
      _answerSelected = false;
      _selectedAnswerIndex = null;
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          widget.quiz.getTitle(widget.languageCode),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              // Show help dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('help'.tr(context)),
                  content: Text('quiz_help_text'.tr(context)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('ok'.tr(context)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _quizCompleted
            ? _buildResultScreen()
            : FadeTransition(
                opacity: _animation,
                child: _buildQuizScreen(),
              ),
      ),
    );
  }

  Widget _buildQuizScreen() {
    final question = widget.quiz.questions[_currentQuestionIndex];
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary.withOpacity(0.05),
            theme.colorScheme.background,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressIndicator(),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${'question'.tr(context)} ${_currentQuestionIndex + 1}/${widget.quiz.questions.length}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: theme.colorScheme.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.quiz.points} ${'points'.tr(context)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    question.getQuestion(widget.languageCode),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: question.getOptions(widget.languageCode).length,
                itemBuilder: (context, index) {
                  return _buildAnswerOption(
                    index,
                    question.getOptions(widget.languageCode)[index],
                    question.correctAnswerIndex,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOption(int index, String option, int correctIndex) {
    bool isSelected = _selectedAnswerIndex == index;
    bool isCorrect = index == correctIndex;
    final theme = Theme.of(context);

    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData? trailingIcon;

    if (_answerSelected) {
      if (isSelected && isCorrect) {
        // Correct answer selected
        backgroundColor = Colors.green.withOpacity(0.1);
        borderColor = Colors.green;
        textColor = Colors.green.shade800;
        trailingIcon = Icons.check_circle;
      } else if (isSelected && !isCorrect) {
        // Wrong answer selected
        backgroundColor = Colors.red.withOpacity(0.1);
        borderColor = Colors.red;
        textColor = Colors.red.shade800;
        trailingIcon = Icons.cancel;
      } else if (!isSelected && isCorrect) {
        // Correct answer not selected
        backgroundColor = Colors.green.withOpacity(0.1);
        borderColor = Colors.green;
        textColor = Colors.green.shade800;
        trailingIcon = Icons.check_circle;
      } else {
        // Other options
        backgroundColor = theme.colorScheme.surface;
        borderColor = theme.colorScheme.outline.withOpacity(0.3);
        textColor = theme.colorScheme.onSurface.withOpacity(0.7);
      }
    } else {
      // Not answered yet
      backgroundColor = isSelected ? theme.colorScheme.primary.withOpacity(0.1) : theme.colorScheme.surface;
      borderColor = isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withOpacity(0.3);
      textColor = isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _answerSelected ? null : () => _selectAnswer(index),
          borderRadius: BorderRadius.circular(16),
          splashColor: theme.colorScheme.primary.withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _answerSelected && (isSelected || isCorrect)
                        ? borderColor
                        : theme.colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _answerSelected && (isSelected || isCorrect)
                          ? borderColor
                          : theme.colorScheme.outline.withOpacity(0.5),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index), // A, B, C, D...
                      style: TextStyle(
                        color: _answerSelected && (isSelected || isCorrect)
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                      fontWeight: isSelected || (_answerSelected && isCorrect)
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (_answerSelected && trailingIcon != null)
                  Icon(
                    trailingIcon,
                    color: isCorrect ? Colors.green : Colors.red,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final progress = (_currentQuestionIndex + 1) / widget.quiz.questions.length;
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${'progress'.tr(context)}: ${(_currentQuestionIndex + 1)}/${widget.quiz.questions.length}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
            const Spacer(),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: MediaQuery.of(context).size.width * progress - 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    final totalQuestions = widget.quiz.questions.length;
    final correctAnswers = _userAnswers.asMap().entries.where(
          (entry) => entry.value == widget.quiz.questions[entry.key].correctAnswerIndex,
        ).length;

    final percentage = (correctAnswers / totalQuestions) * 100;
    final theme = Theme.of(context);

    Color resultColor;
    String resultText;
    IconData resultIcon;

    if (percentage >= 80) {
      resultColor = Colors.green;
      resultText = 'excellent'.tr(context);
      resultIcon = Icons.emoji_events;
    } else if (percentage >= 60) {
      resultColor = Colors.amber;
      resultText = 'good_job'.tr(context);
      resultIcon = Icons.thumb_up;
    } else {
      resultColor = Colors.red;
      resultText = 'try_again'.tr(context);
      resultIcon = Icons.refresh;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary.withOpacity(0.05),
            theme.colorScheme.background,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: resultColor.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: resultColor.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                resultIcon,
                size: 64,
                color: resultColor,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              resultText,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: resultColor,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildScoreItem(
                    'your_score'.tr(context),
                    '$_score ${'points'.tr(context)}',
                    Icons.stars,
                    theme.colorScheme.primary,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(),
                  ),
                  _buildScoreItem(
                    'correct_answers'.tr(context),
                    '$correctAnswers/$totalQuestions',
                    Icons.check_circle,
                    Colors.green,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(),
                  ),
                  _buildScoreItem(
                    'accuracy'.tr(context),
                    '${percentage.toInt()}%',
                    Icons.analytics,
                    Colors.blue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _restartQuiz,
                    icon: const Icon(Icons.refresh),
                    label: Text('try_again'.tr(context)),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: Text(
                'back_to_quizzes'.tr(context),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}