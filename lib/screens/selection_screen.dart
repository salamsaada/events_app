import 'package:eventsapp/core/theme/app_text_styles.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:eventsapp/screens/auth/user_register_screen.dart';
import 'package:eventsapp/core/widgets/common/choice_card_widget.dart';
import 'package:eventsapp/screens/home/home_page.dart';
import 'package:flutter/material.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            children: [
              Text(
                l10n.selectionChooseDestination,
                style: AppTextStyles.goldSubtitle,
              ),
              const SizedBox(height: 10),

              Text(
                l10n.selectionBeginJourney,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                ),
              ),
              const SizedBox(height: 40),

              buildChoiceCard(
                context,
                title: l10n.selectionUserTitle,
                description: l10n.selectionUserDescription,
                imagePath: "assets/images/Screenshot 2026-04-21 162329.png",
                buttonText: l10n.selectionJoinTheGala,
                destination: const UserRegisterScreen(),
              ),

              buildChoiceCard(
                context,
                title: l10n.selectionGuestExplorerTitle,
                description: l10n.selectionGuestExplorerDescription,
                imagePath: "assets/images/Screenshot 2026-04-21 162404.png",
                buttonText: l10n.selectionExploreAsGuest,
                isPreferred: false,
                destination: const HomePage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
