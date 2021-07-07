import 'dart:io';

enum ProductSource {
  googlePlay,
  appStore,
}

extension ProductSourceExtension on ProductSource {
  String get str {
    switch (this) {
      case ProductSource.appStore:
        return 'app_store';

      case ProductSource.googlePlay:
      default:
        return 'google_play';
    }
  }
}

ProductSource getProductSourceByPlatform() {
  if (Platform.isIOS) {
    return ProductSource.appStore;
  }

  return ProductSource.googlePlay;
}

ProductSource getProductSourceByStr(
  String source,
) {
  switch (source) {
    case 'app_store':
      return ProductSource.appStore;

    case 'google_play':
    default:
      return ProductSource.googlePlay;
  }
}
