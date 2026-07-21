import 'package:eventsapp/core/api/api_consumer.dart';
import 'package:eventsapp/models/planner_model.dart';

class PlannersRepository {
  final ApiConsumer apiConsumer;

  PlannersRepository({required this.apiConsumer});

  Future<List<PlannerModel>> getPlanners() async {
  try {
    final response = await apiConsumer.get('/providers'); 
    final List<dynamic> data = response['data']; 
    return data.map((item) => PlannerModel.fromJson(item)).toList();
  } catch (e) {
    print("حدث خطأ أثناء جلب المزودين: $e");
    return []; 
  }
}
}