// lib/screens/find_friends_screen.dart
//
// Browse and search community profiles. Supports infinite scroll with a
// 500 ms simulated load delay. When a real backend is ready, replace
// _generateProfiles with an API call and remove the pagination simulation.

import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/frutiger_aero_theme.dart';
import '../models/peer_profile.dart';

class FindFriendsScreen extends StatefulWidget {
  const FindFriendsScreen({super.key});

  @override
  State<FindFriendsScreen> createState() => _FindFriendsScreenState();
}

class _FindFriendsScreenState extends State<FindFriendsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  // TODO: replace with paginated API call when backend is ready.
  final List<PeerProfile> _allProfiles = _generateProfiles(50);
  final List<PeerProfile> _displayedProfiles = [];
  int _loadedCount = 10;
  bool _isLoading = false;
  String? _searchQuery;

  // ── Demo data generation ───────────────────────────────────────────────────

  static List<PeerProfile> _generateProfiles(int count) {
    final random = Random();
    const usernames = [
      'OceanDreamer', 'WorriedScholar', 'ChillVibes', 'StarryKid',
      'SunshineVibes', 'WeekendWarrior', 'MoonChild', 'CalmOcean',
      'CoffeeAddict', 'MidnightCoder', 'LostInThoughts', 'PizzaLover',
      'SleepyHead', 'MemeLord', 'CloudWatcher', 'SillyGoose',
      'WanderingSoul', 'ChaosCoordinator', 'NoodleBrain', 'SpaceCadet',
    ];
    const bios = [
      'just vibing tbh 🏄‍♂️', 'collecting shiny rocks ✨', 'professional overthinker 🤔',
      'will trade memes for wifi 📶', 'powered by iced coffee ☕',
      'idk I just got here 🤷‍♂️', 'certified nap enthusiast 😴',
      'currently loading... ⏳', 'running on 2 hours of sleep and a dream 🌙',
      'fluent in sarcasm and typos ⌨️', 'just a silly goose on the loose 🪿',
      'living off vibes and snacks 🍕', 'probably thinking about food 🍔',
      'procrastinating right now 📱', 'trying to find my brain cells 🧠',
    ];
    return List.generate(count, (i) => PeerProfile(
      id: 'peer_$i',
      username: usernames[i % usernames.length] + random.nextInt(999).toString(),
      bio: bios[i % bios.length],
    ));
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _displayedProfiles.addAll(_allProfiles.take(_loadedCount));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  // ── Scroll / pagination ────────────────────────────────────────────────────

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (_isLoading || _loadedCount >= _allProfiles.length) return;
    setState(() => _isLoading = true);
    // TODO: replace with real API pagination call.
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _loadedCount = (_loadedCount + 10).clamp(0, _allProfiles.length);
          _displayedProfiles
            ..clear()
            ..addAll(_allProfiles.take(_loadedCount));
          _isLoading = false;
        });
      }
    });
  }

  void _search(String query) {
    setState(() => _searchQuery = query.isEmpty ? null : query);
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Find Friends',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: FrutigerAeroTheme.textDark)),
              const SizedBox(height: 4),
              Text('Connect with others who understand',
                style: TextStyle(fontSize: 14, color: FrutigerAeroTheme.textLight)),
            ],
          ),
        ),

        // Search bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: FrutigerAeroTheme.midBlue.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: TextField(
            controller: _textController,
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

        // Search result notice
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

        // Profiles list
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 120),
            itemCount: _displayedProfiles.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= _displayedProfiles.length) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ));
              }
              return _buildProfileCard(_displayedProfiles[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(PeerProfile profile) {
    final letter = profile.username.isNotEmpty ? profile.username[0].toUpperCase() : 'U';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: FrutigerAeroTheme.cardDecoration,
      child: Row(
        children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(gradient: FrutigerAeroTheme.accentGradient, borderRadius: BorderRadius.circular(25)),
            child: Center(child: Text(letter, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile.username, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: FrutigerAeroTheme.textDark)),
                const SizedBox(height: 4),
                Text(profile.bio, style: TextStyle(fontSize: 13, color: FrutigerAeroTheme.textLight)),
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
    final letter = profile.username.isNotEmpty ? profile.username[0].toUpperCase() : 'U';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(gradient: FrutigerAeroTheme.accentGradient, borderRadius: BorderRadius.circular(20)),
              child: Center(child: Text(letter, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(profile.username, style: const TextStyle(fontSize: 18))),
          ],
        ),
        content: const Text(
          "Hey! We're glad you're finding friends, but unfortunately there are no users currently as this is just the demo!",
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: FrutigerAeroTheme.oceanBlue),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
