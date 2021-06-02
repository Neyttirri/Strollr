import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:strollr/services/camera/save_picture.dart';
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
    image = widget.arguments[0];
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
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                child: AspectRatio(
                  aspectRatio: 16.0 / 9.0,
                  child: buildImage(),
                ),
              ),
              SizedBox(
                //height: MediaQuery.of(context).size.height -
                 //   MediaQuery.of(context).size.width,
                //width: MediaQuery.of(context).size.width,
                child: SliderTheme(
                  data: const SliderThemeData(
                    showValueIndicator: ShowValueIndicator.never,
                  ),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Column(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.brush),
                                    color: Theme.of(context).accentColor,
                                    highlightColor: Colors.white54,
                                    onPressed: () {  },
                                  ),
                                  Text(
                                    "Saturation",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ],
                              ),
                              // _buildSat(),
                              Spacer(),
                              Column(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.brightness_4),
                                    color: Theme.of(context).accentColor,
                                    highlightColor: Colors.white54,
                                    onPressed: () {  },
                                  ),
                                  Text(
                                    "Saturation",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                  )
                                ],
                              ),
                              // _buildBrightness(),
                              Spacer(),
                              Column(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.color_lens),
                                    color: Theme.of(context).accentColor,
                                    highlightColor: Colors.white54,
                                    focusColor: Colors.red,
                                    onPressed: () {  },
                                  ),
                                  Text(
                                    "Kontrast",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                  )
                                ],
                              ),
                              Spacer(),
                              // _buildCon(),
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildFunctions(),
    );
  }

  Widget buildImage() {
    // to generate dynamic and vibrant shades
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
    final ExtendedImageEditorState state = editorKey.currentState!;
    final Rect rect = state.getCropRect()!;
    final EditActionDetails action = state.editAction!;
    final double radian = action.rotateAngle;

    final bool flipHorizontal = action.flipY;
    final bool flipVertical = action.flipX;
    final Uint8List img = state.rawImageData;

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

    option.outputFormat = const OutputFormat.jpeg(100);

    print(const JsonEncoder.withIndent('  ').convert(option.toJson()));

    final DateTime start = DateTime.now();
    final Uint8List result = (await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    ))!;

    print('result.length = ${result.length}');

    final Duration diff = DateTime.now().difference(start);
    image.writeAsBytesSync(result);
    print('image_editor time : $diff');
    Future.delayed(Duration(seconds: 0)).then(
      (value) => Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (context) => SaveImageScreen(
                  arguments: [image],
                )),
      ),
    );
  }

  void flip() {
    editorKey.currentState!.flip();
  }

  void rotate(bool right) {
    editorKey.currentState!.rotate(right: right);
  }

  Widget _buildSat() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        Column(
          children: <Widget>[
            Icon(
              Icons.brush,
              color: Theme.of(context).accentColor,
            ),
            Text(
              "Saturation",
              style: TextStyle(color: Theme.of(context).accentColor),
            )
          ],
        ),
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

  Widget _buildBrightness() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        Column(
          children: <Widget>[
            Icon(
              Icons.brightness_4,
              color: Theme.of(context).accentColor,
            ),
            Text(
              "Helligkeit",
              style: TextStyle(color: Theme.of(context).accentColor),
            )
          ],
        ),
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

  Widget _buildCon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        Column(
          children: <Widget>[
            Icon(
              Icons.color_lens,
              color: Theme.of(context).accentColor,
            ),
            Text(
              "Kontrast",
              style: TextStyle(color: Theme.of(context).accentColor),
            )
          ],
        ),
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
}
/*
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
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                child: AspectRatio(
                  aspectRatio: 16.0/9.0,
                  child: buildImage(),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).size.width,
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
                        Spacer(flex: 1),
                        _buildSat(),
                        Spacer(flex: 1),
                        _buildBrightness(),
                        Spacer(flex: 1),
                        _buildCon(),
                        Spacer(flex: 1),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildFunctions(),
    );
  }
 */
