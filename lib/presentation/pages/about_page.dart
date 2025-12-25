import 'package:ditonton/common/constants.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart'; // Tambahkan import ini
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  static const routeName = '/about';

  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: kRichBlack,
                  child: Center(
                    child: Image.asset(
                      'assets/circle-g.png',
                      width: 128,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  color: kMikadoYellow,
                  child: Column(
                    children: [
                      const Text(
                        'Ditonton merupakan sebuah aplikasi katalog film yang diadaptasi dari salah satu mata kuliah di alur belajar Flutter Developer Dicoding.',
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kRichBlack,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          // FirebaseCrashlytics.instance.crash();
                        },
                        child: const Text('Crash (Test Crashlytics)'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
          )
        ],
      ),
    );
  }
}