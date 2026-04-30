// filepath: lib/main.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math';

// ============================================================================
// FRUTIGER AERO THEME - Light blues to mid blues with gradients
// ============================================================================

class FrutigerAeroTheme {
  // Primary colors - light to mid blues
  static const Color lightBlue = Color(0xFF87CEEB);
  static const Color skyBlue = Color(0xFF00BFFF);
  static const Color deepSkyBlue = Color(0xFF00A8E8);
  static const Color oceanBlue = Color(0xFF0984E3);
  static const Color midBlue = Color(0xFF4A90D9);
  static const Color tealBlue = Color(0xFF5DADE2);

  // Gradient colors
  static const Color gradientLight = Color(0xFFE8F4FC);
  static const Color gradientMid = Color(0xFFB8DFF5);
  static const Color gradientDark = Color(0xFF7EC8E3);

  // Accent colors
  static const Color accentCyan = Color(0xFF00D4FF);
  static const Color accentAqua = Color(0xFF48DbfB);
  static const Color accentWhite = Color(0xFFF0F8FF);

  // Text colors
  static const Color textDark = Color(0xFF1A365D);
  static const Color textMid = Color(0xFF2C5282);
  static const Color textLight = Color(0xFF4A5568);

  // Status colors
  static const Color success = Color(0xFF48BB78);
  static const Color warning = Color(0xFFECC94B);
  static const Color danger = Color(0xFFE53E3E);
  static const Color info = Color(0xFF4299E1);

  static LinearGradient get backgroundGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientLight, gradientMid, Color(0xFFA8D8F0)],
  );

  static LinearGradient get cardGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF0F8FF), Color(0xFFE8F4FC)],
  );

  static LinearGradient get buttonGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [skyBlue, oceanBlue],
  );

  static LinearGradient get accentGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accentCyan, accentAqua],
  );

  static BoxDecoration get glassDecoration => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.85),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
    boxShadow: [
      BoxShadow(
        color: skyBlue.withValues(alpha: 0.2),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );

  static BoxDecoration get cardDecoration => BoxDecoration(
    gradient: cardGradient,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
    boxShadow: [
      BoxShadow(
        color: skyBlue.withValues(alpha: 0.25),
        blurRadius: 20,
        spreadRadius: 2,
        offset: const Offset(0, 8),
      ),
    ],
  );
}

// ============================================================================
// DATA MODELS
// ============================================================================

class Post {
  final String id;
  final String title;
  final String content;
  final String? anonymousName;
  final DateTime timestamp;
  int likes;
  int favorites;
  final List<String> tags;
  final List<Comment> comments;
  final bool isUserPost; // Track if this is the user's own post
  final bool isLikedByMe;
  final bool isFavoritedByMe;

  Post({
    required this.id,
    required this.title,
    required this.content,
    this.anonymousName,
    required this.timestamp,
    this.likes = 0,
    this.favorites = 0,
    this.tags = const [],
    this.comments = const [],
    this.isUserPost = false,
    this.isLikedByMe = false,
    this.isFavoritedByMe = false,
  });

  Post copyWith({
    int? likes,
    int? favorites,
    List<Comment>? comments,
    bool? isLikedByMe,
    bool? isFavoritedByMe,
  }) {
    return Post(
      id: id,
      title: title,
      content: content,
      anonymousName: anonymousName,
      timestamp: timestamp,
      likes: likes ?? this.likes,
      favorites: favorites ?? this.favorites,
      tags: tags,
      comments: comments ?? this.comments,
      isUserPost: isUserPost,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      isFavoritedByMe: isFavoritedByMe ?? this.isFavoritedByMe,
    );
  }
}

class Comment {
  final String id;
  final String authorName;
  final String content;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.authorName,
    required this.content,
    required this.timestamp,
  });
}

class MoodEntry {
  final String id;
  final String mood;
  final String? note;
  final DateTime date;

  MoodEntry({
    required this.id,
    required this.mood,
    this.note,
    required this.date,
  });
}

class UserProfile {
  String username;
  String bio;

  UserProfile({
    this.username = 'TeenUser',
    this.bio = 'Just here to connect and support each other 💙',
  });
}

class PeerProfile {
  final String id;
  final String username;
  final String bio;

  PeerProfile({required this.id, required this.username, required this.bio});
}

// ============================================================================
// MAIN APP
// ============================================================================

void main() {
  runApp(const TeenChatApp());
}

class TeenChatApp extends StatelessWidget {
  const TeenChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeenChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: FrutigerAeroTheme.oceanBlue,
          brightness: Brightness.light,
        ),
        fontFamily: 'Segoe UI',
      ),
      home: const MainNavigation(),
    );
  }
}

// ============================================================================
// GLOBAL STATE
// ============================================================================

class AppState extends InheritedWidget {
  final List<Post> posts;
  final List<Post> favoritePosts;
  final UserProfile userProfile;
  final Map<String, MoodEntry> moodEntries;

  const AppState({
    super.key,
    required this.posts,
    required this.favoritePosts,
    required this.userProfile,
    required this.moodEntries,
    required super.child,
  });

  static AppState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppState>()!;
  }

  @override
  bool updateShouldNotify(AppState oldWidget) => true;
}

// ============================================================================
// MAIN NAVIGATION
// ============================================================================

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Global state
  late List<Post> _posts;
  late List<Post> _favoritePosts;
  late UserProfile _userProfile;
  late Map<String, MoodEntry> _moodEntries;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _posts = [
      Post(
        id: '1',
        title: 'What did you guys eat for breakfast today?',
        content:
            'I had some cereal and fruit. Been trying to start my day with something healthy! What about you guys?',
        anonymousName: 'OceanDreamer',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 24,
        favorites: 5,
        tags: ['food', 'morning'],
        comments: [
          Comment(
            id: 'c1',
            authorName: 'StarryKid',
            content: 'I had pancakes 🥞',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          ),
          Comment(
            id: 'c2',
            authorName: 'SunshineVibes',
            content: 'Just grabbed a coffee lol',
            timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          ),
        ],
      ),
      Post(
        id: '2',
        title: 'How do you deal with school stress?',
        content:
            'Exams are coming up and I\'m feeling really overwhelmed. Any study tips or stress management tricks that work for you guys?',
        anonymousName: 'WorriedStudent',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        likes: 45,
        favorites: 12,
        tags: ['school', 'stress', 'study'],
        comments: [
          Comment(
            id: 'c3',
            authorName: 'CalmOcean',
            content: 'Try the Pomodoro technique! 25 min study, 5 min break 📚',
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          ),
        ],
      ),
      Post(
        id: '3',
        title: 'Random thought: Mondays hit different',
        content:
            'Why does it feel like the weekend ended too fast every time? Anyone else feel like Sundays are just pre-Monday anxiety? 😅',
        anonymousName: 'WeekendWarrior',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        likes: 67,
        favorites: 18,
        tags: ['thoughts', 'weekend'],
        comments: [
          Comment(
            id: 'c4',
            authorName: 'ChillVibes',
            content: 'Sundays be like that fr 💀',
            timestamp: DateTime.now().subtract(const Duration(hours: 7)),
          ),
          Comment(
            id: 'c5',
            authorName: 'MoonChild',
            content: 'Just embrace it and take it one day at a time ✨',
            timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          ),
        ],
      ),
    ];

    _favoritePosts = [];
    _userProfile = UserProfile();
    _moodEntries = {};
  }

  void _addPost(Post post) {
    setState(() {
      _posts.insert(0, post);
    });
  }

  void _toggleFavorite(Post post) {
    setState(() {
      final index = _posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        final isFave = _posts[index].isFavoritedByMe;
        _posts[index] = _posts[index].copyWith(
          favorites: _posts[index].favorites + (isFave ? -1 : 1),
          isFavoritedByMe: !isFave,
        );
        if (isFave) {
          _favoritePosts.removeWhere((p) => p.id == post.id);
        } else {
          _favoritePosts.add(_posts[index]);
        }
      }
    });
  }

  void _toggleLike(Post post) {
    setState(() {
      final index = _posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        final isLiked = _posts[index].isLikedByMe;
        _posts[index] = _posts[index].copyWith(
          likes: _posts[index].likes + (isLiked ? -1 : 1),
          isLikedByMe: !isLiked,
        );
      }
    });
  }

  void _addComment(Post post, String commentText) {
    setState(() {
      final index = _posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        final newComment = Comment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          authorName: _userProfile.username,
          content: commentText,
          timestamp: DateTime.now(),
        );
        final updatedPost = _posts[index].copyWith(
          comments: [..._posts[index].comments, newComment],
        );
        _posts[index] = updatedPost;
      }
    });
  }

  void _updateUserProfile(String username, String bio) {
    setState(() {
      _userProfile.username = username;
      _userProfile.bio = bio;
    });
  }

  void _addMoodEntry(String dateKey, MoodEntry entry) {
    setState(() {
      _moodEntries[dateKey] = entry;
    });
  }

  // Public method to save mood from HomeScreen
  void saveMoodEntry(String dateKey, MoodEntry entry) {
    _addMoodEntry(dateKey, entry);
  }

  @override
  Widget build(BuildContext context) {
    return AppState(
      posts: _posts,
      favoritePosts: _favoritePosts,
      userProfile: _userProfile,
      moodEntries: _moodEntries,
      child: Scaffold(
        extendBody: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: FrutigerAeroTheme.backgroundGradient,
          ),
          child: Stack(
            children: [
              const Positioned.fill(child: ParticleBackground()),
              SafeArea(
                bottom: false,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildScreen(_currentIndex),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: FrutigerAeroTheme.oceanBlue.withValues(
                          alpha: 0.1,
                        ),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(0, Icons.home_rounded, 'Home'),
                      _buildNavItem(1, Icons.forum_rounded, 'Feed'),
                      _buildNavItem(2, Icons.add_circle_rounded, 'Post'),
                      _buildNavItem(3, Icons.people_rounded, 'Find Friends'),
                      _buildNavItem(4, Icons.person_rounded, 'You'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen(key: ValueKey('home'));
      case 1:
        return FeedScreen(
          posts: _posts,
          userProfile: _userProfile,
          onLike: _toggleLike,
          onFavorite: _toggleFavorite,
          onComment: _addComment,
          key: ValueKey('feed'),
        );
      case 2:
        return PostScreen(onSubmit: _addPost, userProfile: _userProfile, key: ValueKey('post'));
      case 3:
        return const FindFriendsScreen(key: ValueKey('friends'));
      case 4:
        return ProfileScreen(
          userProfile: _userProfile,
          onUpdateProfile: _updateUserProfile,
          favoritePosts: _favoritePosts,
          key: ValueKey('profile'),
        );
      default:
        return const HomeScreen(key: ValueKey('home'));
    }
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? FrutigerAeroTheme.buttonGradient : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : FrutigerAeroTheme.textMid,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : FrutigerAeroTheme.textMid,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// HOME SCREEN
// ============================================================================

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
    {'icon': '😢', 'label': 'Sad', 'color': Colors.red},
    {'icon': '😕', 'label': 'Down', 'color': Colors.orange},
    {'icon': '😐', 'label': 'Okay', 'color': Colors.yellow},
    {'icon': '🙂', 'label': 'Good', 'color': Colors.green},
    {'icon': '😄', 'label': 'Great', 'color': Colors.blue},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 24),

            // Mood Check-in Button
            _buildMoodCheckIn(),
            const SizedBox(height: 24),

            // Community Insights
            _buildCommunityInsights(),
            const SizedBox(height: 32),

            // Demo Text
            const Center(
              child: Text(
                "Welcome! Feel free to explore. As this is just the demo, some features might be missing or in beta. Thank you for checking us out!",
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

  Widget _buildHeader() {
    final appState = AppState.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: FrutigerAeroTheme.glassDecoration,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: FrutigerAeroTheme.accentGradient,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                appState.userProfile.username.isNotEmpty
                    ? appState.userProfile.username[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: FrutigerAeroTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  appState.userProfile.username,
                  style: TextStyle(
                    fontSize: 14,
                    color: FrutigerAeroTheme.textMid,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
                  child: const Icon(
                    Icons.emoji_emotions,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mood Check-in',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: FrutigerAeroTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _showMoodCalendar
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
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
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: FrutigerAeroTheme.skyBlue.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<int>(
            value: _selectedMonth.month - 1,
            underline: const SizedBox(),
            items: List.generate(
              12,
              (index) => DropdownMenuItem(
                value: index,
                child: Text(
                  months[index],
                  style: const TextStyle(color: FrutigerAeroTheme.textDark),
                ),
              ),
            ),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedMonth = DateTime(_selectedMonth.year, value + 1);
                });
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: FrutigerAeroTheme.skyBlue.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<int>(
            value: _selectedMonth.year,
            underline: const SizedBox(),
            items: List.generate(
              10,
              (index) => DropdownMenuItem(
                value: 2020 + index,
                child: Text(
                  '${2020 + index}',
                  style: const TextStyle(color: FrutigerAeroTheme.textDark),
                ),
              ),
            ),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedMonth = DateTime(value, _selectedMonth.month);
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    final firstDayOfMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + 1,
      0,
    );
    final daysInMonth = lastDayOfMonth.day;
    final startingWeekday = firstDayOfMonth.weekday % 7;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
              .map(
                (day) => SizedBox(
                  width: 36,
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: FrutigerAeroTheme.textMid,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.3,
          ),
          itemCount: 42,
          itemBuilder: (context, index) {
            final dayNumber = index - startingWeekday + 1;
            if (dayNumber < 1 || dayNumber > daysInMonth) {
              return const SizedBox();
            }

            final date = DateTime(
              _selectedMonth.year,
              _selectedMonth.month,
              dayNumber,
            );
            final isSelected =
                _selectedDate?.day == dayNumber &&
                _selectedDate?.month == _selectedMonth.month &&
                _selectedDate?.year == _selectedMonth.year;

            final dateKey = '${date.year}-${date.month}-${date.day}';
            final appState = AppState.of(context);
            final moodEntry = appState.moodEntries[dateKey];
            final moodData = moodEntry != null
                ? _moods.firstWhere(
                    (m) => m['label'] == moodEntry.mood,
                    orElse: () => _moods.last,
                  )
                : null;
            final moodColor = moodData?['color'] as Color?;
            final moodIcon = moodData?['icon'] as String?;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = date;
                  _selectedMood = moodEntry?.mood;
                  _moodNoteController.text = moodEntry?.note ?? '';
                });
              },
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? FrutigerAeroTheme.buttonGradient
                      : null,
                  color: isSelected
                      ? null
                      : (moodColor != null
                            ? moodColor.withValues(alpha: 0.2)
                            : FrutigerAeroTheme.skyBlue.withValues(alpha: 0.1)),
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? null
                      : (moodColor != null
                            ? Border.all(
                                color: moodColor.withValues(alpha: 0.5),
                              )
                            : null),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        '$dayNumber',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : FrutigerAeroTheme.textDark,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (moodIcon != null)
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Text(
                          moodIcon,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
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
        const Text(
          'How did you feel today?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: FrutigerAeroTheme.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _moods
              .map(
                (mood) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMood = mood['label'];
                    });
                  },
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
                            color: _selectedMood == mood['label']
                                ? mood['color'] as Color
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          mood['icon'],
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mood['label'],
                        style: TextStyle(
                          fontSize: 11,
                          color: _selectedMood == mood['label']
                              ? mood['color'] as Color
                              : FrutigerAeroTheme.textLight,
                          fontWeight: _selectedMood == mood['label']
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _moodNoteController,
          decoration: InputDecoration(
            labelText: 'What made you feel this way?',
            labelStyle: TextStyle(color: FrutigerAeroTheme.textLight),
            filled: true,
            fillColor: FrutigerAeroTheme.gradientLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Mood',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _saveMood() {
    if (_selectedDate == null || _selectedMood == null) return;

    final dateKey =
        '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}';
    final entry = MoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mood: _selectedMood!,
      note: _moodNoteController.text.isNotEmpty
          ? _moodNoteController.text
          : null,
      date: _selectedDate!,
    );

    final navState = context.findAncestorStateOfType<_MainNavigationState>();
    if (navState != null) {
      navState.saveMoodEntry(dateKey, entry);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('Mood saved: $_selectedMood'),
          ],
        ),
        backgroundColor: FrutigerAeroTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    setState(() {
      _selectedMood = null;
      _moodNoteController.clear();
    });
  }

  Widget _buildCommunityInsights() {
    final insights = [
      {
        'title': 'Trending: Self-Care Sunday',
        'participants': 234,
        'icon': Icons.spa,
      },
      {
        'title': 'Most Popular: Anxiety Tips',
        'participants': 189,
        'icon': Icons.psychology,
      },
      {
        'title': 'Active Now: Study Tips',
        'participants': 156,
        'icon': Icons.school,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Community Insights',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: FrutigerAeroTheme.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: FrutigerAeroTheme.glassDecoration,
          child: Column(
            children: insights
                .map((insight) => _buildInsightRow(insight))
                .toList(),
          ),
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
            child: Icon(
              insight['icon'],
              color: FrutigerAeroTheme.oceanBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              insight['title'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: FrutigerAeroTheme.textDark,
              ),
            ),
          ),
          Text(
            '${insight['participants']} shared',
            style: TextStyle(fontSize: 12, color: FrutigerAeroTheme.textLight),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// FEED SCREEN
// ============================================================================

class FeedScreen extends StatefulWidget {
  final List<Post> posts;
  final UserProfile userProfile;
  final Function(Post) onLike;
  final Function(Post) onFavorite;
  final Function(Post, String) onComment;

  const FeedScreen({
    super.key,
    required this.posts,
    required this.userProfile,
    required this.onLike,
    required this.onFavorite,
    required this.onComment,
  });

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Feed',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: FrutigerAeroTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'See what others are sharing',
                  style: TextStyle(
                    fontSize: 14,
                    color: FrutigerAeroTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Rules Section
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: 16,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  FrutigerAeroTheme.skyBlue.withValues(alpha: 0.2),
                  FrutigerAeroTheme.oceanBlue.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: FrutigerAeroTheme.skyBlue.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.rule, color: FrutigerAeroTheme.oceanBlue),
                    SizedBox(width: 8),
                    Text(
                      'Community Rules',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: FrutigerAeroTheme.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildRule('• Be kind and supportive'),
                _buildRule('• Don\'t say hurtful things or harass people'),
                _buildRule('• Respect privacy and anonymity'),
                _buildRule('• No spam or self-promotion'),
              ],
            ),
          ),
        ),

        // Posts
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildPostCard(widget.posts[index]),
              childCount: widget.posts.length,
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
      ],
    );
  }

  Widget _buildRule(String rule) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        rule,
        style: TextStyle(fontSize: 13, color: FrutigerAeroTheme.textMid),
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    final isLiked = post.isLikedByMe;
    final isFavorited = post.isFavoritedByMe;

    // Always resolve the display name live so username changes propagate
    // instantly to all posts — old and new — without mutating stored data.
    final displayName = post.isUserPost
        ? widget.userProfile.username
        : (post.anonymousName ?? 'Anonymous');
    final avatarLetter = displayName.isNotEmpty
        ? displayName[0].toUpperCase()
        : 'A';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: FrutigerAeroTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with profile photo
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: FrutigerAeroTheme.accentGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    avatarLetter,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: FrutigerAeroTheme.textDark,
                      ),
                    ),
                    Text(
                      _formatTime(post.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: FrutigerAeroTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Title
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: FrutigerAeroTheme.textDark,
            ),
          ),

          const SizedBox(height: 8),

          // Content
          Text(
            post.content,
            style: const TextStyle(
              fontSize: 14,
              color: FrutigerAeroTheme.textMid,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 12),

          // Tags
          if (post.tags.isNotEmpty)
            Wrap(
              spacing: 8,
              children: post.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: FrutigerAeroTheme.skyBlue.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '#$tag',
                        style: const TextStyle(
                          fontSize: 12,
                          color: FrutigerAeroTheme.oceanBlue,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

          const SizedBox(height: 12),

          // Actions
          Row(
            children: [
              BounceButton(
                onTap: () {
                  widget.onLike(post);
                },
                child: Row(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: isLiked
                          ? FrutigerAeroTheme.danger
                          : FrutigerAeroTheme.textMid,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post.likes}',
                      style: TextStyle(
                        fontSize: 13,
                        color: FrutigerAeroTheme.textMid,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              BounceButton(
                onTap: () {
                  widget.onFavorite(post);
                },
                child: Row(
                  children: [
                    Icon(
                      isFavorited ? Icons.star : Icons.star_border,
                      size: 20,
                      color: isFavorited
                          ? FrutigerAeroTheme.warning
                          : FrutigerAeroTheme.textMid,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post.favorites}',
                      style: TextStyle(
                        fontSize: 13,
                        color: FrutigerAeroTheme.textMid,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => _showCommentDialog(post),
                child: Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 20,
                      color: FrutigerAeroTheme.textMid,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post.comments.length}',
                      style: TextStyle(
                        fontSize: 13,
                        color: FrutigerAeroTheme.textMid,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _showShareDialog(),
                child: Row(
                  children: [
                    Icon(
                      Icons.share,
                      size: 20,
                      color: FrutigerAeroTheme.textMid,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Share',
                      style: TextStyle(
                        fontSize: 13,
                        color: FrutigerAeroTheme.textMid,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Comments
          if (post.comments.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            ...post.comments.map((comment) => _buildComment(comment)),
          ],
        ],
      ),
    );
  }

  Widget _buildComment(Comment comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: FrutigerAeroTheme.accentGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                comment.authorName.isNotEmpty
                    ? comment.authorName[0].toUpperCase()
                    : 'A',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.authorName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: FrutigerAeroTheme.textDark,
                  ),
                ),
                Text(
                  comment.content,
                  style: TextStyle(
                    fontSize: 13,
                    color: FrutigerAeroTheme.textMid,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCommentDialog(Post post) {
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Comment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: FrutigerAeroTheme.textDark,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: FrutigerAeroTheme.accentGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        widget.userProfile.username.isNotEmpty
                            ? widget.userProfile.username[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'Comment...',
                        hintStyle: TextStyle(
                          color: FrutigerAeroTheme.textLight,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: FrutigerAeroTheme.skyBlue.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: FrutigerAeroTheme.buttonGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (commentController.text.trim().isNotEmpty) {
                        widget.onComment(post, commentController.text.trim());
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Post Comment',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: FrutigerAeroTheme.oceanBlue),
            SizedBox(width: 12),
            Text('Share'),
          ],
        ),
        content: const Text(
          'Whoops! You can\'t share these posts as this is just the demo!',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: FrutigerAeroTheme.oceanBlue,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}

// ============================================================================
// POST SCREEN
// ============================================================================

class PostScreen extends StatefulWidget {
  final Function(Post) onSubmit;
  final UserProfile userProfile;

  const PostScreen({super.key, required this.onSubmit, required this.userProfile});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _selectedTags = [];

  final List<String> _availableTags = [
    'mental-health',
    'stress',
    'school',
    'friends',
    'family',
    'positivity',
    'support',
    'anxiety',
    'self-care',
    'motivation',
    'food',
    'thoughts',
    'weekend',
    'study',
    'tips',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Post',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: FrutigerAeroTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Share your thoughts with the community',
            style: TextStyle(fontSize: 14, color: FrutigerAeroTheme.textLight),
          ),
          const SizedBox(height: 24),

          // Title Input
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: FrutigerAeroTheme.glassDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: FrutigerAeroTheme.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'What\'s your question or topic?',
                    hintStyle: TextStyle(color: FrutigerAeroTheme.textLight),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: FrutigerAeroTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Description Input
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: FrutigerAeroTheme.glassDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: FrutigerAeroTheme.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _contentController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Share more details...',
                    hintStyle: TextStyle(color: FrutigerAeroTheme.textLight),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: FrutigerAeroTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tags - Same style as other sections
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: FrutigerAeroTheme.glassDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Tags',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: FrutigerAeroTheme.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableTags
                      .map((tag) => _buildTagChip(tag))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: FrutigerAeroTheme.buttonGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: FrutigerAeroTheme.oceanBlue.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Post to Feed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    final isSelected = _selectedTags.contains(tag);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedTags.remove(tag);
          } else {
            _selectedTags.add(tag);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? FrutigerAeroTheme.buttonGradient : null,
          color: isSelected
              ? null
              : FrutigerAeroTheme.skyBlue.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : FrutigerAeroTheme.skyBlue.withValues(alpha: 0.5),
          ),
        ),
        child: Text(
          '#$tag',
          style: TextStyle(
            fontSize: 13,
            color: isSelected ? Colors.white : FrutigerAeroTheme.oceanBlue,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _submitPost() {
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in both title and description'),
          backgroundColor: FrutigerAeroTheme.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final post = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      anonymousName: widget.userProfile.username,
      timestamp: DateTime.now(),
      likes: 0,
      favorites: 0,
      tags: _selectedTags,
      comments: [],
      isUserPost: true,
    );

    widget.onSubmit(post);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            const Text('Posted to feed!'),
          ],
        ),
        backgroundColor: FrutigerAeroTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    _titleController.clear();
    _contentController.clear();
    setState(() {
      _selectedTags.clear();
    });
  }
}

// ============================================================================
// FIND FRIENDS SCREEN
// ============================================================================

class FindFriendsScreen extends StatefulWidget {
  const FindFriendsScreen({super.key});

  @override
  State<FindFriendsScreen> createState() => _FindFriendsScreenState();
}

class _FindFriendsScreenState extends State<FindFriendsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<PeerProfile> _allProfiles = _generateProfiles(50);
  final List<PeerProfile> _displayedProfiles = [];
  int _loadedCount = 10;
  bool _isLoading = false;
  String? _searchQuery;

  static List<PeerProfile> _generateProfiles(int count) {
    final random = Random();
    // Names and bios that match feed style
    final usernames = [
      'OceanDreamer',
      'WorriedScholar',
      'ChillVibes',
      'StarryKid',
      'SunshineVibes',
      'WeekendWarrior',
      'MoonChild',
      'CalmOcean',
      'CoffeeAddict',
      'MidnightCoder',
      'LostInThoughts',
      'PizzaLover',
      'SleepyHead',
      'MemeLord',
      'CloudWatcher',
      'SillyGoose',
      'WanderingSoul',
      'ChaosCoordinator',
      'NoodleBrain',
      'SpaceCadet',
    ];
    final bios = [
      'just vibing tbh 🏄‍♂️',
      'collecting shiny rocks ✨',
      'professional overthinker 🤔',
      'will trade memes for wifi 📶',
      'powered by iced coffee ☕',
      'idk I just got here 🤷‍♂️',
      'certified nap enthusiast 😴',
      'currently loading... ⏳',
      'running on 2 hours of sleep and a dream 🌙',
      'fluent in sarcasm and typos ⌨️',
      'just a silly goose on the loose 🪿',
      'living off vibes and snacks 🍕',
      'probably thinking about food 🍔',
      'procrastinating right now 📱',
      'trying to find my brain cells 🧠',
    ];

    return List.generate(
      count,
      (index) => PeerProfile(
        id: 'peer_$index',
        username:
            usernames[index % usernames.length] +
            random.nextInt(999).toString(),
        bio: bios[index % bios.length],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _displayedProfiles.addAll(_allProfiles.take(_loadedCount));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (_isLoading || _loadedCount >= _allProfiles.length) return;

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _loadedCount = (_loadedCount + 10).clamp(0, _allProfiles.length);
          _displayedProfiles.clear();
          _displayedProfiles.addAll(_allProfiles.take(_loadedCount));
          _isLoading = false;
        });
      }
    });
  }

  void _search(String query) {
    setState(() {
      _searchQuery = query.isEmpty ? null : query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Find Friends',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: FrutigerAeroTheme.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Connect with others who understand',
                style: TextStyle(
                  fontSize: 14,
                  color: FrutigerAeroTheme.textLight,
                ),
              ),
            ],
          ),
        ),

        // Search Bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: FrutigerAeroTheme.midBlue.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            onSubmitted: _search,
            decoration: InputDecoration(
              hintText: 'Search by username...',
              hintStyle: TextStyle(color: FrutigerAeroTheme.textLight),
              border: InputBorder.none,
              icon: Icon(Icons.search, color: FrutigerAeroTheme.oceanBlue),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Search Result Message
        if (_searchQuery != null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FrutigerAeroTheme.warning.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: FrutigerAeroTheme.warning),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Currently there are no users with that username! As this is just the demo!',
                    style: TextStyle(color: FrutigerAeroTheme.textDark),
                  ),
                ),
              ],
            ),
          ),

        // Profiles List
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 120),
            itemCount: _displayedProfiles.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= _displayedProfiles.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return _buildProfileCard(_displayedProfiles[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(PeerProfile profile) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: FrutigerAeroTheme.cardDecoration,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: FrutigerAeroTheme.accentGradient,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                profile.username.isNotEmpty
                    ? profile.username[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.username,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: FrutigerAeroTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.bio,
                  style: TextStyle(
                    fontSize: 13,
                    color: FrutigerAeroTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.person_add, color: FrutigerAeroTheme.oceanBlue),
            onPressed: () => _showProfileDialog(profile),
          ),
        ],
      ),
    );
  }

  void _showProfileDialog(PeerProfile profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: FrutigerAeroTheme.accentGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  profile.username.isNotEmpty
                      ? profile.username[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                profile.username,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: const Text(
          'Hey! We\'re glad you\'re finding friends, but unfortunately there are no users currently as this is just the demo!',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: FrutigerAeroTheme.oceanBlue,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PROFILE SCREEN (YOU)
// ============================================================================

class ProfileScreen extends StatefulWidget {
  final UserProfile userProfile;
  final Function(String, String) onUpdateProfile;
  final List<Post> favoritePosts;

  const ProfileScreen({
    super.key,
    required this.userProfile,
    required this.onUpdateProfile,
    required this.favoritePosts,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);

    // Filter to show only user's own posts
    final userPosts = appState.posts.where((p) => p.isUserPost).toList();

    return Column(
      children: [
        // Profile Header
        Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: FrutigerAeroTheme.accentGradient,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        widget.userProfile.username.isNotEmpty
                            ? widget.userProfile.username[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showEditDialog,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: FrutigerAeroTheme.oceanBlue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                widget.userProfile.username,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: FrutigerAeroTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                widget.userProfile.bio,
                style: TextStyle(
                  fontSize: 14,
                  color: FrutigerAeroTheme.textMid,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const _LogOutText(),
            ],
          ),
        ),

        // Tabs
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: FrutigerAeroTheme.midBlue.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: FrutigerAeroTheme.oceanBlue,
            unselectedLabelColor: FrutigerAeroTheme.textLight,
            indicatorColor: FrutigerAeroTheme.oceanBlue,
            tabs: const [
              Tab(text: 'Posts'),
              Tab(text: 'Favorites'),
            ],
          ),
        ),

        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [_buildPostsTab(userPosts), _buildFavoritesTab()],
          ),
        ),
      ],
    );
  }

  Widget _buildPostsTab(List<Post> posts) {
    if (posts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.post_add,
                size: 64,
                color: FrutigerAeroTheme.skyBlue.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No posts yet',
                style: TextStyle(
                  fontSize: 16,
                  color: FrutigerAeroTheme.textLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create a post to see it here!',
                style: TextStyle(
                  fontSize: 14,
                  color: FrutigerAeroTheme.textLight,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
      itemCount: posts.length,
      itemBuilder: (context, index) => _buildPostItem(posts[index]),
    );
  }

  Widget _buildFavoritesTab() {
    if (widget.favoritePosts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star_border,
                size: 64,
                color: FrutigerAeroTheme.skyBlue.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No favorites yet',
                style: TextStyle(
                  fontSize: 16,
                  color: FrutigerAeroTheme.textLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Star posts to add them here!',
                style: TextStyle(
                  fontSize: 14,
                  color: FrutigerAeroTheme.textLight,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
      itemCount: widget.favoritePosts.length,
      itemBuilder: (context, index) =>
          _buildPostItem(widget.favoritePosts[index]),
    );
  }

  Widget _buildPostItem(Post post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: FrutigerAeroTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: FrutigerAeroTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            post.content,
            style: TextStyle(fontSize: 13, color: FrutigerAeroTheme.textMid),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.favorite, size: 16, color: FrutigerAeroTheme.danger),
              const SizedBox(width: 4),
              Text(
                '${post.likes}',
                style: TextStyle(
                  fontSize: 12,
                  color: FrutigerAeroTheme.textLight,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.star, size: 16, color: FrutigerAeroTheme.warning),
              const SizedBox(width: 4),
              Text(
                '${post.favorites}',
                style: TextStyle(
                  fontSize: 12,
                  color: FrutigerAeroTheme.textLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditDialog() {
    final usernameController = TextEditingController(
      text: widget.userProfile.username,
    );
    final bioController = TextEditingController(text: widget.userProfile.bio);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.edit, color: FrutigerAeroTheme.oceanBlue),
            SizedBox(width: 12),
            Text('Edit Profile'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: FrutigerAeroTheme.textLight),
                filled: true,
                fillColor: FrutigerAeroTheme.gradientLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bioController,
              decoration: InputDecoration(
                labelText: 'Bio',
                labelStyle: TextStyle(color: FrutigerAeroTheme.textLight),
                filled: true,
                fillColor: FrutigerAeroTheme.gradientLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onUpdateProfile(
                usernameController.text.trim(),
                bioController.text.trim(),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FrutigerAeroTheme.oceanBlue,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    for (int i = 0; i < 20; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          speed: 0.05 + _random.nextDouble() * 0.1,
          radius: 2 + _random.nextDouble() * 4,
          opacity: 0.05 + _random.nextDouble() * 0.2,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (var p in _particles) {
          p.y -= p.speed * 0.01;
          if (p.y < -0.1) {
            p.y = 1.1;
            p.x = _random.nextDouble();
          }
        }
        return CustomPaint(
          painter: _ParticlePainter(particles: _particles),
          child: Container(),
        );
      },
    );
  }
}

class _Particle {
  double x;
  double y;
  double speed;
  double radius;
  double opacity;

  _Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.radius,
    required this.opacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;

  _ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint = Paint()..color = Colors.white.withValues(alpha: p.opacity);
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _LogOutText extends StatefulWidget {
  const _LogOutText();

  @override
  State<_LogOutText> createState() => _LogOutTextState();
}

class _LogOutTextState extends State<_LogOutText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Whoops!'),
              content: const Text(
                "You can't log out if you were never logged in, as this is just the demo!",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        child: Text(
          'Log out',
          style: TextStyle(
            color: FrutigerAeroTheme.danger,
            fontSize: 14,
            decoration: _isHovered
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationColor: FrutigerAeroTheme.danger,
          ),
        ),
      ),
    );
  }
}

class BounceButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const BounceButton({super.key, required this.child, required this.onTap});

  @override
  State<BounceButton> createState() => _BounceButtonState();
}

class _BounceButtonState extends State<BounceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}
