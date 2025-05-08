import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syntrix_ai/pages/home_page.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Navigate to home page after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF9C27B0),  // Deep purple
              Color(0xFF673AB7),  // Purple
              Color.fromARGB(255, 78, 101, 227),  // Indigo
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Robot icon with pulsing animation
              ScaleTransition(
                scale: _animation,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(75),
                  child: Image.network(
                    'https://imgs.search.brave.com/Cj9QNSCWOrOujg9k7qiHHyfKP_lMGfmhCTNVHhbrroo/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9pbWcu/ZnJlZXBpay5jb20v/cHJlbWl1bS1waG90/by9yb2JvdC1yZXBy/ZXNlbnRhdGlvbi1m/dXR1cmlzdGljLXRl/Y2hub2xvZ3lfNTM4/NzYtODkxMTExLmpw/Zz9zZW10PWFpc19o/eWJyaWQmdz03NDA',
                    fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF9C27B0),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / 
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Color(0xFF9C27B0),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // App name
              const Text(
                'Syntrix Ai',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Loading indicator
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 5,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
} 