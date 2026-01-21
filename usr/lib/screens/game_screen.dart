import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _health = 100;
  int _armor = 100;
  int _ammo = 30;
  int _reserveAmmo = 90;
  int _kills = 0;
  
  // Target Practice Logic
  final Random _random = Random();
  List<Offset> _targets = [];
  Timer? _targetTimer;

  @override
  void initState() {
    super.initState();
    _startGameLoop();
  }

  void _startGameLoop() {
    _targetTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_targets.length < 5) {
        setState(() {
          _targets.add(Offset(
            _random.nextDouble() * 0.8 + 0.1, // Keep within 10-90% of screen
            _random.nextDouble() * 0.6 + 0.1, // Keep within 10-70% of screen
          ));
        });
      }
    });
  }

  @override
  void dispose() {
    _targetTimer?.cancel();
    super.dispose();
  }

  void _shoot(TapDownDetails details) {
    if (_ammo > 0) {
      setState(() {
        _ammo--;
      });
      
      // Check for hit
      // We need screen size to calculate hit detection from normalized coordinates
      final Size screenSize = MediaQuery.of(context).size;
      final Offset tapPos = details.globalPosition;
      
      bool hit = false;
      List<Offset> remainingTargets = [];
      
      for (var target in _targets) {
        final Offset targetPos = Offset(target.dx * screenSize.width, target.dy * screenSize.height);
        if ((targetPos - tapPos).distance < 40) { // Hit radius
          hit = true;
          _kills++;
        } else {
          remainingTargets.add(target);
        }
      }
      
      if (hit) {
        setState(() {
          _targets = remainingTargets;
        });
        // Play hit sound effect (visual feedback)
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("HEADSHOT!", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            duration: Duration(milliseconds: 300),
            backgroundColor: Colors.transparent,
            elevation: 0,
          )
        );
      }
    } else {
      _reload();
    }
  }

  void _reload() {
    if (_reserveAmmo > 0) {
      setState(() {
        int needed = 30 - _ammo;
        int take = min(needed, _reserveAmmo);
        _ammo += take;
        _reserveAmmo -= take;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: _shoot,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. 3D World Placeholder (Gradient Sky + Floor)
            Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF87CEEB), Color(0xFFE0F7FA)], // Sky
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: const Color(0xFF795548), // Ground
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
                      itemBuilder: (c, i) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 2. Targets
            ..._targets.map((t) => Align(
              alignment: Alignment(t.dx * 2 - 1, t.dy * 2 - 1), // Convert 0..1 to -1..1
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 5)],
                ),
                child: Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  ),
                ),
              ),
            )),

            // 3. HUD - Radar (Top Left)
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: Stack(
                  children: [
                    Center(child: Icon(Icons.navigation, color: Colors.white, size: 16)), // Player
                    const Positioned(top: 40, right: 40, child: Icon(Icons.circle, color: Colors.red, size: 10)), // Enemy
                  ],
                ),
              ),
            ),

            // 4. HUD - Kill Feed (Top Right)
            Positioned(
              top: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildKillFeedItem("Player", "Bot 1", true),
                  _buildKillFeedItem("Player", "Bot 2", false),
                ],
              ),
            ),

            // 5. HUD - Health & Armor (Bottom Left)
            Positioned(
              bottom: 20,
              left: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildHudStat(Icons.add_moderator, "$_health", Colors.white),
                  const SizedBox(width: 20),
                  _buildHudStat(Icons.shield, "$_armor", Colors.white),
                ],
              ),
            ),

            // 6. HUD - Ammo & Weapon (Bottom Right)
            Positioned(
              bottom: 20,
              right: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "$_ammo / $_reserveAmmo",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const Text(
                        "AK-47",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 7. Crosshair (Center)
            Center(
              child: Container(
                width: 20,
                height: 20,
                child: Stack(
                  children: [
                    Center(child: Container(width: 2, height: 14, color: Colors.green)),
                    Center(child: Container(width: 14, height: 2, color: Colors.green)),
                  ],
                ),
              ),
            ),

            // 8. Back Button (Top Left - Hidden mostly but accessible)
            Positioned(
              top: 20,
              left: 180,
              child: IconButton(
                icon: const Icon(Icons.exit_to_app, color: Colors.white54),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHudStat(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            shadows: const [Shadow(blurRadius: 2, color: Colors.black)],
          ),
        ),
      ],
    );
  }

  Widget _buildKillFeedItem(String killer, String victim, bool headshot) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black.withOpacity(0.0), Colors.black.withOpacity(0.6)],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(killer, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          const SizedBox(width: 5),
          Icon(Icons.my_location, size: 14, color: headshot ? Colors.red : Colors.white),
          const SizedBox(width: 5),
          Text(victim, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
