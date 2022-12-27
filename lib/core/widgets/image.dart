import 'package:flutter/material.dart';
import "package:flutter_svg/flutter_svg.dart";
import 'package:huzz/core/constants/app_themes.dart';

class LocalImage extends StatelessWidget {
  const LocalImage(
    this.image, {
    Key? key,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  }) : super(key: key);
  final String image;
  final double? height, width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      fit: fit,
      height: height,
      width: width,
    );
  }
}

class LocalSvgImage extends StatelessWidget {
  const LocalSvgImage(this.image,
      {Key? key, this.height, this.width, this.fit = BoxFit.contain})
      : super(key: key);
  final String image;
  final double? height, width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      image,
      fit: fit,
      height: height,
      width: width,
    );
  }
}

class LocalSvgIcon extends StatelessWidget {
  const LocalSvgIcon(
    this.icon, {
    this.fit = BoxFit.contain,
    this.size = IconSizes.sm,
    this.color,
    Key? key,
  }) : super(key: key);
  final String icon;
  final BoxFit fit;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Center(
        child: SvgPicture.asset(
          icon,
          height: size ?? IconSizes.sm,
          width: size ?? IconSizes.sm,
          fit: fit,
          color: color ?? Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
