import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:strollr/utils/filter_utils.dart';
import 'package:strollr/widgets/filtered_image_list_widget.dart';
import 'describe_picture.dart';
import 'package:strollr/utils/loading_screen.dart';
import 'package:image_editor/image_editor.dart' hide ImageSource;
import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';

import '../logger.dart';

class EditPhotoScreen extends StatefulWidget {
  final List arguments;

  EditPhotoScreen({required this.arguments});

  @override
  _EditPhotoScreenState createState() => _EditPhotoScreenState();
}

// theory behind the calculations -> https://docs.rainmeter.net/tips/colormatrix-guide/
class _EditPhotoScreenState extends State<EditPhotoScreen> {
  // keep the state on a global (not local) level -> here: to show the image in another widget but in the same state
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  bool _loading = true;

  double saturation = 1;
  double brightness = 0;
  double contrast = 1;
  bool extraQuality = false;
  final int defaultQuality = 75;
  final int highQuality = 88;

  // the identity matrix, 5th row is implicitly added
  // to create a new color -> [R', G', B', A'] = the matrix * [R, G, B, A]
  final defaultColorMatrix = const <double>[
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0
  ];

  static const int ID_BRIGHTNESS = 0;
  static const int ID_CONTRAST = 1;
  static const int ID_SATURATION = 2;
  static const int ID_FILTERS = 3;
  static const int ID_FLIP = 4;
  static const int ID_ROTATE_LEFT = 5;
  static const int ID_ROTATE_RIGHT = 6;

  int selectedTabIndex = 0;
  Map<int, bool> tabSelectionMap = {
    ID_BRIGHTNESS: true,
    ID_CONTRAST: false,
    ID_SATURATION: false,
    ID_FILTERS: false,
    ID_FLIP: false,
    ID_ROTATE_LEFT: false,
    ID_ROTATE_RIGHT: false
  };

  late File image;
  ScrollController _scrollController = new ScrollController();
  final List<List<double>> filters = [
    NO_FILTER_MATRIX,
    SEPIA_MATRIX,
    GREYSCALE_MATRIX,
    VINTAGE_MATRIX,
    SWEET_MATRIX,
    REMIX_MATRIX,
    EXTRA_MATRIX,
    FILTER_3,
    FILTER_4,
    FILTER_5
  ];
  List<double> _currentFilter = NO_FILTER_MATRIX;
  bool usingFilters = false;

  //    G  [ sg sg+s sg  0   0]
  //    B  [ sb  sb sb+s 0   0]
  //    A  [ 0   0   0   1   0]
  //    W  [ 0   0   0   0   1]
  List<double> calculateSaturationMatrix(double saturation) {
    final m = List<double>.from(defaultColorMatrix);
    final invSat = 1 - saturation;
    final R = 0.213 * invSat; // 0.213 = lumR
    final G = 0.715 * invSat; // 0.715 = lumG
    final B = 0.072 * invSat; // 0.072 = lumB

    // saturation -> only the first 3x3 part of the 5x5 matrix
    m[0] = R + saturation;
    m[1] = G;
    m[2] = B;
    m[5] = R;
    m[6] = G + saturation;
    m[7] = B;
    m[10] = R;
    m[11] = G;
    m[12] = B + saturation;

    return m;
  }

  List<double> calculateContrastMatrix(double contrast) {
    final m = List<double>.from(defaultColorMatrix);

    // only the first 3 rows on the main diagonal
    m[0] = contrast;
    m[6] = contrast;
    m[12] = contrast;
    return m;
  }

  @override
  void initState() {
    super.initState();
    __initializeAsync();
  }

  Future<void> __initializeAsync() async {
    image = widget.arguments[0];
    Future.delayed(Duration(seconds: 0)).whenComplete(() => setState(() {
          _loading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          "Bild bearbeiten",
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.green),
        actions: <Widget>[
          // icon to reset made changes
          IconButton(
            icon: Icon(Icons.settings_backup_restore),
            onPressed: () {
              setState(() {
                saturation = 1;
                brightness = 0;
                contrast = 1;
                _currentFilter = NO_FILTER_MATRIX;
                usingFilters = false;
              });
            },
          ),
          // icon to confirm and save edited image
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              await crop();
            },
          ),
        ],
      ),
      body: _loading
          ? LoadingScreen()
          : Container(
              color: Color(0xFFDDDDDD),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  // the picture + crop option
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: MediaQuery.of(context).size.width,
                    child: AspectRatio(
                      aspectRatio: 16.0 / 9.0,
                      child: buildImage(),
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: const SliderThemeData(
                        showValueIndicator: ShowValueIndicator.never,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Sliders for editing picture
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.17,
                                    child: getCurrentSlider(selectedTabIndex),
                                  )
                                ]),
                            // icons to choose editing option
                            Expanded(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      // so the list is horizontal
                                      child: RotatedBox(
                                        quarterTurns: -1,
                                        child: ClickableListWheelScrollView(
                                          scrollController: _scrollController,
                                          itemCount: tabSelectionMap.length,
                                          itemHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          onItemTapCallback: (id) {
                                            if (id < 0 ||
                                                id > tabSelectionMap.length)
                                              return;
                                            switch (id) {
                                              case ID_FLIP:
                                                flip();
                                                break;
                                              case ID_ROTATE_RIGHT:
                                                rotate(true);
                                                break;
                                              case ID_ROTATE_LEFT:
                                                rotate(false);
                                                break;
                                              default:
                                                _updateTabSelection(id);
                                            }
                                          },
                                          child: ListWheelScrollView(
                                              controller: _scrollController,
                                              diameterRatio: 1.6,
                                              children: [
                                                _createIconTap(
                                                    'Helligkeit',
                                                    Icons.brightness_6,
                                                    ID_BRIGHTNESS),
                                                _createIconTap(
                                                    'Kontrast',
                                                    Icons.invert_colors_on,
                                                    ID_CONTRAST),
                                                _createIconTap('Sättigung',
                                                    Icons.brush, ID_SATURATION),
                                                _createIconTap(
                                                    'Filters',
                                                    Icons
                                                        .filter_vintage_outlined,
                                                    ID_FILTERS),
                                                _createIconTap('spiegeln ',
                                                    Icons.flip, ID_FLIP),
                                                _createIconTap(
                                                    'links drehen ',
                                                    Icons.rotate_left,
                                                    ID_ROTATE_LEFT),
                                                _createIconTap(
                                                    'rechts drehen',
                                                    Icons.rotate_right,
                                                    ID_ROTATE_RIGHT),
                                              ],
                                              itemExtent: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.15 // 110.0,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _createCheckBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildImage() {
    return ColorFiltered(
            colorFilter: ColorFilter.matrix(calculateContrastMatrix(contrast)),
            child: ColorFiltered(
              colorFilter:
                  ColorFilter.matrix(calculateSaturationMatrix(saturation)),
              child: ColorFiltered(
                colorFilter: ColorFilter.matrix(_currentFilter),
                child: ExtendedImage(
                  color: brightness > 0
                      ? Colors.white.withOpacity(brightness)
                      : Colors.black.withOpacity(-brightness),
                  colorBlendMode:
                      brightness > 0 ? BlendMode.lighten : BlendMode.darken,
                  image: ExtendedFileImageProvider(image, cacheRawData: true),
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width,
                  extendedImageEditorKey: editorKey,
                  mode: ExtendedImageMode.editor,
                  enableMemoryCache: true,
                  fit: BoxFit.contain,
                  initEditorConfigHandler: (state) {
                    return EditorConfig(
                      cornerColor: Colors.green,
                      maxScale: 8.0,
                      cropRectPadding: const EdgeInsets.all(20.0),
                      hitTestSize: 20.0,
                    );
                  },
                ),
              ),
            ),
          );
  }

  Future<void> crop([bool test = false]) async {
    setState(() {
      _loading = true;
    });
    final ExtendedImageEditorState? state = editorKey.currentState;

    if (state == null) {
      return;
    }
    final Rect? rect = state.getCropRect();
    if (rect == null) {
      Fluttertoast.showToast(
        msg: 'The crop rect is null.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        // also possible "TOP" and "CENTER"
        backgroundColor: Color(0xffe74c3c),
        textColor: Color(0xffffffff),
      );
      return;
    }
    if (state.image == null) {
      return;
    }
    final EditActionDetails action = state.editAction!;
    final double radian = action.rotateAngle;
    final bool flipHorizontal = action.flipY;
    final bool flipVertical = action.flipX;

    final ImageEditorOption option = ImageEditorOption();
    option.addOption(ClipOption.fromRect(rect));
    option.addOption(
        FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
    if (action.hasRotateAngle) {
      option.addOption(RotateOption(radian.toInt()));
    }
    option.addOption(ColorOption.saturation(saturation));
    option.addOption(ColorOption.brightness(brightness + 1));
    option.addOption(ColorOption.contrast(contrast));
    option.addOption(ColorOption(matrix: _currentFilter));

    print(const JsonEncoder.withIndent('  ').convert(option.toJson()));

    var imageList = state.rawImageData;

    final DateTime start = DateTime.now();
    final result = await ImageEditor.editImage(
      image: imageList,
      imageEditorOption: option,
    );

    final Duration diff = DateTime.now().difference(start);
    image.writeAsBytesSync(result!);
    print('image_editor time : $diff');

    Uint8List compressedImage = (await FlutterImageCompress.compressWithFile(
      image.absolute.path,
      quality: extraQuality ? highQuality : defaultQuality,
    ))!;

    ApplicationLogger.getLogger('_EditPhotoScreenState', colors: true).i(
        'Finished compression. Size before: ${image.readAsBytesSync().lengthInBytes / 1024}. Size after with compression quiality ${extraQuality ? highQuality : defaultQuality}: ${compressedImage.lengthInBytes / 1024}');
    image.writeAsBytesSync(
        compressedImage);

    ApplicationLogger.getLogger('_EditPhotoScreenState', colors: true)
        .d('Finished editing picture');
    Future.delayed(Duration(seconds: 0)).then(
      (value) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DescribePhotoScreen(arguments: [
            image,
            widget.arguments[1]
          ] // picture and its coordinates
              ),
        ),
      ),
    );
    setState(() {
      _loading = false;
    });
    // showPreviewDialog(result);
  }

  void flip() {
    editorKey.currentState!.flip();
  }

  void rotate(bool right) {
    editorKey.currentState!.rotate(right: right);
  }

  Widget _buildSatSlider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Slider(
            label: 'sat : ${saturation.toStringAsFixed(2)}',
            activeColor: Colors.green[900],
            inactiveColor: Colors.green[200],
            onChanged: (double value) {
              setState(() {
                saturation = value;
              });
            },
            divisions: 50,
            value: saturation,
            min: 0,
            max: 2,
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.08),
          child: Text(saturation.toStringAsFixed(2)),
        ),
      ],
    );
  }

  Widget _buildBrightnessSlider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Slider(
            label: '${brightness.toStringAsFixed(2)}',
            activeColor: Colors.green[900],
            inactiveColor: Colors.green[200],
            onChanged: (double value) {
              setState(() {
                brightness = value;
              });
            },
            divisions: 50,
            value: brightness,
            min: -1,
            max: 1,
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.08),
          child: Text(brightness.toStringAsFixed(2)),
        ),
      ],
    );
  }

  Widget _buildConSlider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Slider(
            label: 'con : ${contrast.toStringAsFixed(2)}',
            activeColor: Colors.green[900],
            inactiveColor: Colors.green[200],
            onChanged: (double value) {
              setState(() {
                contrast = value;
              });
            },
            divisions: 50,
            value: contrast,
            min: 0,
            max: 4,
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.08),
          child: Text(contrast.toStringAsFixed(2)),
        ),
      ],
    );
  }

  Widget getCurrentSlider(int index) {
    switch (index) {
      case ID_BRIGHTNESS:
        return _buildBrightnessSlider();
      case ID_CONTRAST:
        return _buildConSlider();
      case ID_SATURATION:
        return _buildSatSlider();
      case ID_FILTERS:
        return FilteredImageListWidget(
          filters: filters,
          image: image,
          onChangedFilter: (filter) {
            setState(() {
              _currentFilter = filter;
              usingFilters = true;
            });
          },
        );

      default:
        return Container();
    }
  }

  Widget _createIconTap(String label, IconData icon, int id) {
    return RotatedBox(
      quarterTurns: 1,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        width: tabSelectionMap[id] as bool ? 110 : 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                icon,
                color: tabSelectionMap[id] as bool
                    ? Colors.green[900]
                    : Colors.green[300],
              ),
              Text(
                label,
                style: TextStyle(
                    color: tabSelectionMap[id] as bool
                        ? Colors.green[900]
                        : Colors.green[300]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createCheckBox() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: extraQuality,
            activeColor: Colors.green,
            onChanged: (newValue) {
              setState(() {
                extraQuality = newValue!;
              });
            },
          ),
          Flexible(
            child: Text(
              'Bild in hoher Auflösung speichern. Verbraucht mehr Speicher!',
              maxLines: 2,
              softWrap: true,
              //overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }

  _updateTabSelection(int id) {
    setState(() {
      selectedTabIndex = id;
      tabSelectionMap.forEach((key, value) {
        if (key == id)
          tabSelectionMap.update(key, (value) => true);
        else
          tabSelectionMap.update(key, (value) => false);
      });
    });
  }
}
