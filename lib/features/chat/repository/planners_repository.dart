import 'package:eventsapp/core/api/api_consumer.dart';
import 'package:eventsapp/models/planner_model.dart';

class PlannersRepository {
  final ApiConsumer apiConsumer;

  PlannersRepository({required this.apiConsumer});

  Future<List<PlannerModel>> getPlanners() async {
    // 1. نضع الرابط الصحيح
    final response = await apiConsumer.get('/providers'); 
    
    // 2. ندخل إلى المفتاح 'data' لأن الباك إند يستخدم Pagination
    final List<dynamic> data = response['data']; 
   
    // 3. نحول البيانات إلى قائمة من الـ Models
    return data.map((item) => PlannerModel.fromJson(item)).toList();
  }
}