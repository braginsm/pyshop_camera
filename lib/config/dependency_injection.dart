import 'package:get_it/get_it.dart';
import 'package:pyshop_camera/api_client/api_client.dart';
import 'package:pyshop_camera/services/photo_send_service.dart';
import 'package:pyshop_camera/services/position_service.dart';

void configureDependencyInjection() {
  final apiClient =
      ApiClient(baseUrl: 'https://flutter-sandbox.free.beeceptor.com');
  final photoSendService = PhotoSendService(apiClient);
  final positionService = PositionService();

  GetIt.I.registerSingleton<PhotoSendService>(photoSendService);
  GetIt.I.registerSingleton<PositionService>(positionService);
}
