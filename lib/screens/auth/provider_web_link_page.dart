import 'package:eventsapp/core/widgets/common/custom_gold_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderWebLinkPage extends StatelessWidget {
  const ProviderWebLinkPage({super.key});

  final String _webDashboardUrl = "https://royal-event-dashboard.com"; 

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(_webDashboardUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface, 
      body: Padding(
        padding: const EdgeInsets.all(24.0), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            Icon(
              Icons.business_center, 
              size: 80, 
              color: theme.colorScheme.primary,
            ), 
            const SizedBox(height: 24),

            Text(
              "If you would like to join our event organization team, you can visit the following link to manage your services and offers via the Web Dashboard:",
              style: TextStyle(
                fontSize: 16, 
                color: theme.colorScheme.onSurface, 
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            SelectableText(
              _webDashboardUrl,
              style: TextStyle(
                color: theme.colorScheme.primary, 
                fontSize: 16, 
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            CustomGoldButton(
              text: "Go to Web Dashboard",
              icon: Icons.open_in_browser, 
              onTap: _launchUrl, 
            )
          ],
        ),
      ),
    );
  }
}