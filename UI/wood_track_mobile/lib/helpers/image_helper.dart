import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageHelper {
  static Widget buildImage(String url, {double width = 50, double height = 50}) {
    final safeWidth = (width.isFinite && width > 0) ? width : 50.0;
    final safeHeight = (height.isFinite && height > 0) ? height : 50.0;

    if (url.isEmpty) {
      return Icon(Icons.image, color: Colors.grey[300], size: safeWidth);
    }

    if (url.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        url,
        width: safeWidth,
        height: safeHeight,
        placeholderBuilder: (context) => Container(
          width: safeWidth,
          height: safeHeight,
          color: Colors.grey[100],
          child: Icon(Icons.image, color: Colors.grey[300], size: safeWidth * 0.8),
        ),
      );
    }

    return Image.network(
      url,
      width: safeWidth,
      height: safeHeight,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: safeWidth,
          height: safeHeight,
          color: Colors.grey[100],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.broken_image, color: Colors.grey[300], size: safeWidth);
      },
    );
  }
}

