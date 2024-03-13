import 'package:pyshop_camera/api_client/api_client.dart';
import 'package:pyshop_camera/models/photo.dart';

class PhotoSendService {
  const PhotoSendService(this.apiClient);

  final ApiClient apiClient;

  Future<bool> send(Photo photo) async {
    try {
      final response = await apiClient.sendPhoto(
        comment: photo.comment,
        latitude: photo.point.latitude,
        longitude: photo.point.longitude,
        photo: photo.filePath,
      );

      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }
}
