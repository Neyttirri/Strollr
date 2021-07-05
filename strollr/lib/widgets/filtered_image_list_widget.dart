import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'filtered_image_widget.dart';
import 'package:photofilters/filters/filters.dart';

class FilteredImageListWidget extends StatelessWidget {
  final List<Filter> filters;
  final img.Image image;
  final ValueChanged<Filter> onChangedFilter;

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilteredImageWidget(
                    filter: filter,
                    image: image,
                    successBuilder: (imageBytes) {
                      print('successBuilder');
                      return CircleAvatar(
                        radius: 30,
                        backgroundImage: MemoryImage(Uint8List.fromList(imageBytes)),
                        //backgroundColor: Colors.white,
                      );
                    },

                    errorBuilder: () {

                      return CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.report, size: 28),
                        backgroundColor: Colors.white,
                      );
          }
                    ,
                    loadingBuilder: () {
                      print('loadingBuilder');
                      return CircleAvatar(
                        radius: 30,
                        child: Center(child: CircularProgressIndicator()),
                        backgroundColor: Colors.white,
                      );
                    } ,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    filter.name,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}