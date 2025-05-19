import 'package:catcare_mobile/pages/about_page.dart';
import 'package:catcare_mobile/pages/check_page.dart';
import 'package:catcare_mobile/pages/history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onToggleLanguage;
  final Locale currentLocale;

  const HomePage({
    Key? key,
    required this.onToggleLanguage,
    required this.currentLocale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.welcome,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onToggleLanguage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 41, 84, 255),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icons/world.png',
                          width: 12,
                          height: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          currentLocale.languageCode.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Card "Periksa Sekarang"
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF151515),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      //Background Shape biru
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/shape.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Text dan Button
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.checkNow,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                AppLocalizations.of(context)!.desc,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                maxLines: 2,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 160,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF9E4AD5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.check,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ), // Gambar Karakter
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Image.asset(
                          'assets/images/icons.png',
                          height: 160,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Fitur
              Text(
                AppLocalizations.of(context)!.feature,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _featureButton(context, 'assets/icons/paste.png', AppLocalizations.of(context)!.history),
                  _featureButton(context, 'assets/icons/qr.png', AppLocalizations.of(context)!.check),
                  _featureButton(context, 'assets/icons/info.png', AppLocalizations.of(context)!.about),
                ],
              ),

              const SizedBox(height: 30),

              // Tips Section
              Text(
                AppLocalizations.of(context)!.tips,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _tipCard(
                  'Hidrasi',
                  'Pastikan kucing Anda minum cukup air dengan menggunakan'
                      'pancuran air non-plastik. Kucing secara alami mendapatkan'
                      'sekitar 70% air dari mangsanya, dan makanan kering mungkin'
                      'tidak sepenuhnya menggantikannya'),
              const SizedBox(height: 16),
              _tipCard(
                  'Perawatan',
                  'Menyikat bulu secara teratur dapat membantu menghilangkan'
                      'bulu yang rontok dari bulu kucing, mencegah kerontokan dan'
                      'terbentuknya gumpalan bulu. Ini juga membantu membangun'
                      'ikatan dengan kucing Anda.'),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Fitur Button
  Widget _featureButton(BuildContext context, dynamic icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == 'Histori') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HistoryPage()),
          );
        } else if (label == 'Periksa') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CheckPage()),
          );
        } else if (label == AppLocalizations.of(context)!.about) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutPage()),
          );
        }
      },
      child: Container(
        width: 95,
        height: 95,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF9E4AD5)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon is IconData
                ? Icon(icon, color: const Color(0xFF9E4AD5))
                : Image.asset(icon, width: 40, height: 40),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Tips Card
  Widget _tipCard(String title, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {},
                child: Text(
                  'read more',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
