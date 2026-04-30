// lib/screens/home_screen.dart
//
// Landing screen: personalised greeting, mood calendar check-in, community insights.

import 'package:flutter/material.dart';
import '../theme/frutiger_aero_theme.dart';
import '../models/mood_entry.dart';
import '../state/app_state.dart';
import '../state/main_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showMoodCalendar = false;
  DateTime _selectedMonth = DateTime.now();
  DateTime? _selectedDate;
  String? _selectedMood;
  final TextEditingController _moodNoteController = TextEditingController();

  final List<Map<String, dynamic>> _moods = [
    {'icon': '😢', 'label': 'Sad',   'color': Colors.red},
    {'icon': '😕', 'label': 'Down',  'color': Colors.orange},
    {'icon': '😐', 'label': 'Okay',  'color': Colors.yellow},
    {'icon': '🙂', 'label': 'Good',  'color': Colors.green},
    {'icon': '😄', 'label': 'Great', 'color': Colors.blue},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildMoodCheckIn(),
            const SizedBox(height: 24),
            _buildCommunityInsights(),
            const SizedBox(height: 32),
            const Center(
              child: Text(
                'Welcome! Feel free to explore. As this is just the demo, '
                'some features might be missing or in beta. Thank you for checking us out!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: FrutigerAeroTheme.textLight,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    final username = AppState.of(context).userProfile.username;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: FrutigerAeroTheme.glassDecoration,
      child: Row(
        children: [
          _avatarCircle(username, size: 60, fontSize: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: FrutigerAeroTheme.textDark),
                ),
                const SizedBox(height: 4),
                Text(username, style: const TextStyle(fontSize: 14, color: FrutigerAeroTheme.textMid)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Mood check-in ──────────────────────────────────────────────────────────

  Widget _buildMoodCheckIn() {
    return GestureDetector(
      onTap: () => setState(() => _showMoodCalendar = !_showMoodCalendar),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: FrutigerAeroTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: FrutigerAeroTheme.accentGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.emoji_emotions, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Mood Check-in',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: FrutigerAeroTheme.textDark),
                  ),
                ),
                Icon(
                  _showMoodCalendar ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: FrutigerAeroTheme.textMid,
                ),
              ],
            ),
            if (_showMoodCalendar) ...[
              const SizedBox(height: 20),
              _buildMonthYearPicker(),
              const SizedBox(height: 16),
              _buildCalendar(),
              if (_selectedDate != null) ...[
                const SizedBox(height: 20),
                _buildMoodPicker(),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMonthYearPicker() {
    const months = [
      'January','February','March','April','May','June',
      'July','August','September','October','November','December',
    ];

    Widget pill(Widget child) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: FrutigerAeroTheme.skyBlue.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        pill(DropdownButton<int>(
          value: _selectedMonth.month - 1,
          underline: const SizedBox(),
          items: List.generate(12, (i) => DropdownMenuItem(
            value: i,
            child: Text(months[i], style: const TextStyle(color: FrutigerAeroTheme.textDark)),
          )),
          onChanged: (v) { if (v != null) setState(() => _selectedMonth = DateTime(_selectedMonth.year, v + 1)); },
        )),
        const SizedBox(width: 16),
        pill(DropdownButton<int>(
          value: _selectedMonth.year,
          underline: const SizedBox(),
          items: List.generate(10, (i) => DropdownMenuItem(
            value: 2020 + i,
            child: Text('${2020 + i}', style: const TextStyle(color: FrutigerAeroTheme.textDark)),
          )),
          onChanged: (v) { if (v != null) setState(() => _selectedMonth = DateTime(v, _selectedMonth.month)); },
        )),
      ],
    );
  }

  Widget _buildCalendar() {
    final firstDay = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final daysInMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;
    final startingWeekday = firstDay.weekday % 7;
    final appState = AppState.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['S','M','T','W','T','F','S'].map((d) => SizedBox(
            width: 36,
            child: Text(d, textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, color: FrutigerAeroTheme.textMid)),
          )).toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1.3),
          itemCount: 42,
          itemBuilder: (context, index) {
            final dayNumber = index - startingWeekday + 1;
            if (dayNumber < 1 || dayNumber > daysInMonth) return const SizedBox();

            final date = DateTime(_selectedMonth.year, _selectedMonth.month, dayNumber);
            final isSelected = _selectedDate?.day == dayNumber &&
                _selectedDate?.month == _selectedMonth.month &&
                _selectedDate?.year == _selectedMonth.year;

            final dateKey = '${date.year}-${date.month}-${date.day}';
            final moodEntry = appState.moodEntries[dateKey];
            final moodData = moodEntry != null
                ? _moods.firstWhere((m) => m['label'] == moodEntry.mood, orElse: () => _moods.last)
                : null;
            final moodColor = moodData?['color'] as Color?;
            final moodIcon  = moodData?['icon'] as String?;

            return GestureDetector(
              onTap: () => setState(() {
                _selectedDate = date;
                _selectedMood = moodEntry?.mood;
                _moodNoteController.text = moodEntry?.note ?? '';
              }),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  gradient: isSelected ? FrutigerAeroTheme.buttonGradient : null,
                  color: isSelected ? null : (moodColor != null
                      ? moodColor.withValues(alpha: 0.2)
                      : FrutigerAeroTheme.skyBlue.withValues(alpha: 0.1)),
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected ? null : (moodColor != null ? Border.all(color: moodColor.withValues(alpha: 0.5)) : null),
                ),
                child: Stack(
                  children: [
                    Center(child: Text('$dayNumber', style: TextStyle(
                      color: isSelected ? Colors.white : FrutigerAeroTheme.textDark,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ))),
                    if (moodIcon != null)
                      Positioned(bottom: 2, right: 2,
                        child: Text(moodIcon, style: const TextStyle(fontSize: 10))),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMoodPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('How did you feel today?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: FrutigerAeroTheme.textDark)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _moods.map((mood) => GestureDetector(
            onTap: () => setState(() => _selectedMood = mood['label']),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _selectedMood == mood['label']
                        ? (mood['color'] as Color).withValues(alpha: 0.3)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedMood == mood['label'] ? mood['color'] as Color : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Text(mood['icon'], style: const TextStyle(fontSize: 28)),
                ),
                const SizedBox(height: 4),
                Text(mood['label'], style: TextStyle(
                  fontSize: 11,
                  color: _selectedMood == mood['label'] ? mood['color'] as Color : FrutigerAeroTheme.textLight,
                  fontWeight: _selectedMood == mood['label'] ? FontWeight.bold : FontWeight.normal,
                )),
              ],
            ),
          )).toList(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _moodNoteController,
          decoration: InputDecoration(
            labelText: 'What made you feel this way?',
            labelStyle: const TextStyle(color: FrutigerAeroTheme.textLight),
            filled: true,
            fillColor: FrutigerAeroTheme.gradientLight,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              gradient: FrutigerAeroTheme.buttonGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: _selectedMood != null ? _saveMood : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Mood', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  void _saveMood() {
    if (_selectedDate == null || _selectedMood == null) return;

    final dateKey = '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}';
    final entry = MoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mood: _selectedMood!,
      note: _moodNoteController.text.isNotEmpty ? _moodNoteController.text : null,
      date: _selectedDate!,
    );

    // Bubble the mood save up to the root navigation state.
    context.findAncestorStateOfType<MainNavigationState>()?.saveMoodEntry(dateKey, entry);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle, color: Colors.white),
        const SizedBox(width: 12),
        Text('Mood saved: $_selectedMood'),
      ]),
      backgroundColor: FrutigerAeroTheme.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));

    setState(() {
      _selectedMood = null;
      _moodNoteController.clear();
    });
  }

  // ── Community insights ─────────────────────────────────────────────────────

  Widget _buildCommunityInsights() {
    // TODO: replace with live API data when backend is ready.
    const insights = [
      {'title': 'Trending: Self-Care Sunday',  'participants': 234, 'icon': Icons.spa},
      {'title': 'Most Popular: Anxiety Tips',  'participants': 189, 'icon': Icons.psychology},
      {'title': 'Active Now: Study Tips',      'participants': 156, 'icon': Icons.school},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Community Insights',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: FrutigerAeroTheme.textDark)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: FrutigerAeroTheme.glassDecoration,
          child: Column(children: insights.map(_buildInsightRow).toList()),
        ),
      ],
    );
  }

  Widget _buildInsightRow(Map<String, dynamic> insight) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: FrutigerAeroTheme.skyBlue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(insight['icon'] as IconData, color: FrutigerAeroTheme.oceanBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(insight['title'] as String,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: FrutigerAeroTheme.textDark))),
          Text('${insight['participants']} shared',
            style: const TextStyle(fontSize: 12, color: FrutigerAeroTheme.textLight)),
        ],
      ),
    );
  }
}

// ── Private avatar helper (used only in this screen) ─────────────────────────

Widget _avatarCircle(String username, {required double size, required double fontSize}) {
  final letter = username.isNotEmpty ? username[0].toUpperCase() : 'U';
  return Container(
    width: size, height: size,
    decoration: BoxDecoration(
      gradient: FrutigerAeroTheme.accentGradient,
      borderRadius: BorderRadius.circular(size / 2),
    ),
    child: Center(child: Text(letter, style: TextStyle(color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.bold))),
  );
}
