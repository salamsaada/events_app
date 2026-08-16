import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
// تأكدي من استيراد مسار الموديل تبعك
import 'package:eventsapp/models/planner_model.dart'; 

class ProviderDetailsPage extends StatefulWidget {
  final String providerId;

  const ProviderDetailsPage({super.key, required this.providerId});

  @override
  State<ProviderDetailsPage> createState() => _ProviderDetailsPageState();
}

class _ProviderDetailsPageState extends State<ProviderDetailsPage> {
  bool isLoading = true;
  String? errorMessage;
  
  // 🚀 التعديل: المتغير صار من نوع PlannerModel
  PlannerModel? providerDetails; 

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    final response = await context.read<UserCubit>().userRepository.getProviderDetails(widget.providerId);
    
    if (mounted) {
      setState(() {
        isLoading = false;
        response.fold(
          (error) => errorMessage = error,
          (data) => providerDetails = data, // data هنا هي PlannerModel
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('التفاصيل'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true, 
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFFD6B237)));
    } 
    
    if (errorMessage != null) {
      return Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)));
    } 
    
    if (providerDetails != null) {
      // ✨ شوفي ما أنظف الكود صار! صرنا نقرأ من الموديل مباشرة
      final name = providerDetails!.name;
      final email = providerDetails!.email;
      final phone = providerDetails!.phone;
      final rating = providerDetails!.rating;
      
      // تنسيق نوع المزود للعرض
      String displayType = providerDetails!.type == 'freelancer' ? 'مستقل (Freelancer)' : 'شركة (Company)';

      return SingleChildScrollView(
        child: Column(
          children: [
            // 🎨 الهيدر
            Container(
              width: double.infinity,
              height: 280,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.15),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60), 
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.colorScheme.primary,
                    child: Icon(Icons.person, size: 50, color: theme.colorScheme.onPrimary),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    name,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      displayType, 
                      style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 🎨 كروت المعلومات
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildInfoCard(context, Icons.email_outlined, "البريد الإلكتروني", email),
                  const SizedBox(height: 15),
                  _buildInfoCard(context, Icons.phone_outlined, "رقم الهاتف", phone),
                  const SizedBox(height: 15),
                  _buildInfoCard(context, Icons.star_outline, "التقييم العام", "$rating نجوم"),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String title, String value) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}