import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class FilteredImageWidget extends StatelessWidget {
  final List<double> filterMatrix;
  final File image;

  const FilteredImageWidget({
    Key? key,
    required this.filterMatrix,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(filterMatrix),
      child: CircleAvatar(
        maxRadius: 35,
        backgroundImage: ExtendedFileImageProvider(image),
        ),
    );
  }
}
