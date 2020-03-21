import 'package:local_cache_sync/local_cache_sync.dart';
import 'package:safemap/safemap.dart';

class VideoResource {
  final String url;
  final bool isLive;
  final String title;
  final String description;
  final String image;

  VideoResource({
    this.url: '',
    this.isLive: false,
    this.title: '',
    this.description: '',
    this.image: '',
  });

  VideoResource.formJson(
    Map<String, dynamic> map,
  ) : this(
          url: SafeMap(map)['url'].string,
          isLive: SafeMap(map)['isLive'].boolean,
          title: SafeMap(map)['title'].string,
          description: SafeMap(map)['description'].string,
          image: SafeMap(map)['image'].string,
        );

  Map<String, dynamic> get jsonMap => {
        'url': url,
        'isLive': isLive,
        'title': title,
        'description': description,
        'image': image,
      };

  static LocalCacheLoader get _loader => LocalCacheLoader('video');

  void save() => _loader.saveById(url, jsonMap);

  void delete() => _loader.deleteById(url);

  static List<VideoResource> all() {
    return _loader.all.map<VideoResource>(
      (obj) => VideoResource.formJson(obj.value),
    );
  }
}
