import 'package:eventsapp/cubit/theme_cubit.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/cubit/user_state.dart';
import 'package:eventsapp/screens/provider_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfessionalStaffPage extends StatefulWidget {
  final String eventName;

  const ProfessionalStaffPage({super.key, required this.eventName});

  @override
  State<ProfessionalStaffPage> createState() => _ProfessionalStaffPageState();
}

class _ProfessionalStaffPageState extends State<ProfessionalStaffPage> {
  
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getProviders();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        bool isDark = context.read<ThemeCubit>().isDark;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(widget.eventName, style: theme.appBarTheme.titleTextStyle),
            backgroundColor: theme.appBarTheme.backgroundColor,
            centerTitle: true,
            iconTheme: theme.appBarTheme.iconTheme,
          ),
          body: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state is GetProvidersLoading) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFD6B237)));
              } else if (state is GetProvidersFailure) {
                return Center(child: Text(state.errMessage, style: const TextStyle(color: Colors.red)));
              } else if (state is GetProvidersSuccess) {
                final providers = state.providers; 

                if (providers.isEmpty) {
                  return const Center(child: Text("No providers found."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: providers.length,
                  itemBuilder: (context, index) {
                    final provider = providers[index];
                    return _buildStaffListCard(context, isDark, provider);
                  },
                );
              }
              return const SizedBox();
            },
          ),
        );
      },
    );
  }

  Widget _buildStaffListCard(BuildContext context, bool isDark, dynamic provider) {
    final theme = Theme.of(context);

    final providerId = provider['id'] ?? '';
    final providerName = provider['name'] ?? 'Unknown Name';
    final providerType = provider['type'] ?? 'Professional';
    final rating = provider['rating'] ?? '5.0';

    // 🚀 دالة ذكية لاختيار أيقونة مناسبة بناءً على الاسم أو النوع
    IconData getAppropriateIcon(String name, String type) {
      if (name.contains("مصور")) return Icons.camera_alt_outlined;
      if (name.contains("أفراح") || name.contains("قصر")) return Icons.castle_outlined; // أيقونة قصر
      if (name.contains("ديكور")) return Icons.format_paint_outlined;
      if (name.contains("منسقة") || name.contains("فعاليات") || name.contains("مناسبات")) return Icons.celebration_outlined;
      
      // الأيقونة الافتراضية
      return type == 'company' ? Icons.business_outlined : Icons.person_outline;
    }

    final cardIcon = getAppropriateIcon(providerName, providerType);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProviderDetailsPage(providerId: providerId),
          ),
        );
      },
      child: Container(
        height: 120, 
        margin: const EdgeInsets.only(bottom: 16), 
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // 🚀 1. مساحة الأيقونة
            Container(
              width: 120,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : theme.colorScheme.primary.withOpacity(0.15),
                borderRadius: const BorderRadiusDirectional.horizontal(
                  start: Radius.circular(16),
                ),
              ),
              // عرض الأيقونة في منتصف المربع
              child: Center(
                child: Icon(
                  cardIcon,
                  size: 45, 
                  color: theme.colorScheme.primary, 
                ),
              ),
            ),
            
            // 2. مساحة التفاصيل والنصوص
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      providerName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      providerType, 
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 13),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Details ->",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: theme.colorScheme.primary, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              rating.toString(), 
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}