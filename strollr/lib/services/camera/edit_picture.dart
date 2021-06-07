import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:strollr/services/image_characteristics/describe_picture.dart';
import 'package:strollr/utils/loading_screen.dart';
import 'package:image_editor/image_editor.dart' hide ImageSource;

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

  int selectedTabIndex = 0;
  Map<int, bool> tabSelectionMap = {
    ID_BRIGHTNESS: true,
    ID_CONTRAST: false,
    ID_SATURATION: false,
    ID_FILTERS: false
  };

  late File image;

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
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            // icon to reset made changes
            IconButton(
              icon: Icon(Icons.settings_backup_restore),
              onPressed: () {
                setState(() {
                  saturation = 1;
                  brightness = 0;
                  contrast = 1;
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
          ]),
      body: _loading
          ? LoadingScreen()
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  // the picture + crop option
                  SizedBox(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    child: AspectRatio(
                      aspectRatio: 1.0, // 16.0 / 9.0,
                      child: buildImage(),
                    ),
                  ),
                  SizedBox(
                    height: (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).size.width) *
                        0.55,
                    width: MediaQuery.of(context).size.width,
                    child: SliderTheme(
                      data: const SliderThemeData(
                        showValueIndicator: ShowValueIndicator.never,
                      ),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Sliders for editing picture
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: getCurrentSlider(selectedTabIndex),
                                  )
                                ]),
                            // icons to choose editing option
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  //Spacer(),
                                  _createIconTap('Helligkeit',
                                      Icons.brightness_6, ID_BRIGHTNESS),
                                  //Spacer(),
                                  _createIconTap('Kontrast',
                                      Icons.invert_colors_on, ID_CONTRAST),
                                  //Spacer(),
                                  _createIconTap(
                                      'Sättigung', Icons.brush, ID_SATURATION),
                                  //Spacer(),
                                ]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _buildFunctions(),
    );
  }

  Widget buildImage() {
    // to generate dynamic and vibrant shades,
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(calculateContrastMatrix(contrast)),
      child: ColorFiltered(
        colorFilter: ColorFilter.matrix(calculateSaturationMatrix(saturation)),
        child: ExtendedImage(
          color: brightness > 0
              ? Colors.white.withOpacity(brightness)
              : Colors.black.withOpacity(-brightness),
          colorBlendMode: brightness > 0 ? BlendMode.lighten : BlendMode.darken,
          image: ExtendedFileImageProvider(image),
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          extendedImageEditorKey: editorKey,
          mode: ExtendedImageMode.editor,
          fit: BoxFit.contain,
          initEditorConfigHandler: (state) {
            return EditorConfig(
              maxScale: 8.0,
              cropRectPadding: const EdgeInsets.all(20.0),
              hitTestSize: 20.0,
            );
          },
        ),
      ),
    );
  }

  Widget _buildFunctions() {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.flip,
            color: Colors.white,
          ),
          label: 'Flip',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.rotate_left,
            color: Colors.white,
          ),
          label: 'Rotate left',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.rotate_right,
            color: Colors.white,
          ),
          label: 'Rotate right',
        ),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            flip();
            break;
          case 1:
            rotate(false);
            break;
          case 2:
            rotate(true);
            break;
        }
      },
      currentIndex: 0,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).primaryColor,
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
    var data = await state.image!.toByteData(format: ImageByteFormat.png);
    if (data == null) {
      return;
    } // image.Image? src = decodePng(); final EditActionDetails action = state.editAction!;
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
    option.outputFormat = const OutputFormat.png(88);
    print(const JsonEncoder.withIndent('  ').convert(option.toJson()));
    final DateTime start = DateTime.now();

    final Uint8List result = (await ImageEditor.editImage(
      image: data.buffer.asUint8List(),
      imageEditorOption: option,
    ))!;

    print('result.length = ${result.length}');

    final Duration diff = DateTime.now().difference(start);
    image.writeAsBytesSync(result);
    print('image_editor time : $diff');

    Future.delayed(Duration(seconds: 0)).then(
      (value) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DescribePhotoScreen(
            arguments: [image],
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
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Slider(
            label: 'sat : ${saturation.toStringAsFixed(2)}',
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
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Slider(
            label: '${brightness.toStringAsFixed(2)}',
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
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Slider(
            label: 'con : ${contrast.toStringAsFixed(2)}',
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
        return Text('create filters!! ');

      default:
        throw Exception('no such tab!! ');
    }
  }

  Widget _createIconTap(String label, IconData icon, int id) {
    return Column(
      children: <Widget>[
        IconButton(
          onPressed: () {
            _updateTabSelection(id);
          },
          icon: Icon(icon),
          color: tabSelectionMap[id] as bool
              ? Colors.green[900]
              : Colors.green[300],
        ),
        Text(
          label,
          style: TextStyle(
              color: tabSelectionMap[id] as bool
                  ? Colors.green[900]
                  : Colors.green[
                      300]), // TextStyle(color: Theme.of(context).accentColor),
        ),
      ],
    );
  }

  _updateTabSelection(int id) {
    print(tabSelectionMap);
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

