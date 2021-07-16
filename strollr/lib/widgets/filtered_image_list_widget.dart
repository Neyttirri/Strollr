import 'dart:io';

import 'package:flutter/material.dart';
import 'filtered_image_widget.dart';

class FilteredImageListWidget extends StatelessWidget {
  final List<List<double>> filters;
  final File image;
  final ValueChanged<List<double>> onChangedFilter;

  const FilteredImageListWidget({
    Key? key,
    required this.filters,
    required this.image,
    required this.onChangedFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.17;

    return Container(
      height: height,
      //color: Color(0xFFDDDDDD), //Color(0xFFDDDDDD),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            blurRadius: 20,
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];

          return InkWell(
            onTap: () => onChangedFilter(filter),
            child: Container(
              padding: EdgeInsets.all(4),
              child:
                  FilteredImageWidget(
                    image: image,
                    filterMatrix: filters[index] ,
                  ),
            ),
          );
        },
      ),
    );
  }
}