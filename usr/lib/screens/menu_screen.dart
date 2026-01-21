import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background (Simulated Smoke/Map)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF141414),
                  Color(0xFF2A2A2A),
                ],
              ),
            ),
          ),
          
          // Character Model Placeholder (Center-Right)
          Positioned(
            right: 100,
            bottom: 0,
            top: 100,
            child: Opacity(
              opacity: 0.8,
              child: Image.network(
                'https://raw.githubusercontent.com/flutter/assets-for-api-docs/master/packages/diagrams/assets/blend_mode_destination.jpeg', // Placeholder
                errorBuilder: (c, e, s) => Container(
                  width: 300,
                  color: Colors.grey.withOpacity(0.2),
                  child: const Center(child: Text("CT OPERATOR", style: TextStyle(color: Colors.white10, fontSize: 40, fontWeight: FontWeight.bold))),
                ),
              ),
            ),
          ),

          // Left Sidebar (Navigation)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 80,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildNavIcon(Icons.home, true),
                  _buildNavIcon(Icons.tv, false),
                  _buildNavIcon(Icons.inventory_2, false),
                  _buildNavIcon(Icons.settings, false),
                  const Spacer(),
                  _buildNavIcon(Icons.power_settings_new, false),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Top Bar (Status)
          Positioned(
            left: 100,
            top: 20,
            right: 20,
            child: Row(
              children: [
                const Text(
                  "COUNTER-STRIKE 2",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Spacer(),
                _buildStatusBadge("PRIME ENABLED", Colors.green),
                const SizedBox(width: 10),
                const CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.person),
                ),
              ],
            ),
          ),

          // Play Menu (Left Panel)
          Positioned(
            left: 100,
            top: 100,
            bottom: 50,
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("COMPETITIVE", style: TextStyle(color: Colors.white54, letterSpacing: 2)),
                const SizedBox(height: 10),
                const Text("MIRAGE", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                
                // Play Button
                InkWell(
                  onTap: () => Navigator.pushNamed(context, '/game'),
                  child: Container(
                    height: 60,
                    width: 200,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 10, spreadRadius: 2),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "PLAY",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                _buildMenuOption("Premier"),
                _buildMenuOption("Matchmaking"),
                _buildMenuOption("Wingman"),
                _buildMenuOption("Casual"),
                _buildMenuOption("Deathmatch"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, bool isSelected) {
    return Container(
      height: 60,
      width: 80,
      decoration: BoxDecoration(
        border: isSelected ? const Border(left: BorderSide(color: Colors.white, width: 4)) : null,
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.white38,
        size: 28,
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildMenuOption(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
