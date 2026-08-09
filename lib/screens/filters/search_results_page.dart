import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/cubit/user_state.dart';
import 'package:eventsapp/screens/details_page.dart'; 

class SearchResultsPage extends StatelessWidget {
  final String categoryName;

  const SearchResultsPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Results: $categoryName'),
        centerTitle: true,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          // حالة التحميل
          if (state is GetListingLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFD6B237)));
          }

          // حالة الخطأ
          if (state is GetListingFailure) {
            return Center(
              child: Text(state.errMessage, style: const TextStyle(color: Colors.red)),
            );
          }

          // حالة النجاح
          if (state is GetListingSuccess) {
            final listings = state.listingResponse.data;

            if (listings.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'No results found for your filters.',
                      style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              );
            }

            // 🚀 عرض النتائج كروت احترافية قابلة للضغط
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listings.length,
              itemBuilder: (context, index) {
                final item = listings[index];
                
                // جلب الصورة أو وضع صورة افتراضية
                final String imageUrl = item.images.isNotEmpty
                    ? item.images[0]
                    : 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1000';

                // استخراج السعر المبدئي إن وُجد
                final String price = item.variants.isNotEmpty 
                    ? '${item.variants[0].price} ${item.variants[0].currency}' 
                    : 'Price not specified';

                return GestureDetector(
                  onTap: () {
                    // 🚀 الانتقال لصفحة التفاصيل عند الضغط على الكرت
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(item: item),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. صورة العنصر
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.network(
                            imageUrl,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 180,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                            ),
                          ),
                        ),
                        
                        // 2. تفاصيل العنصر
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // العنوان ونوع العنصر
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title['en'] ?? item.title['ar'] ?? 'No Title',
                                      style: const TextStyle(
                                        fontSize: 18, 
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD6B237).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      item.type.toUpperCase(),
                                      style: const TextStyle(
                                        color: Color(0xFFD6B237),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              
                              // الموقع
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.district.name,
                                    style: TextStyle(color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              
                              // السعر
                              Row(
                                children: [
                                  const Text(
                                    'Starts from: ',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    price,
                                    style: const TextStyle(
                                      color: Color(0xFFD6B237),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}