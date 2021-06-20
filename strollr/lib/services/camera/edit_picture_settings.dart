import 'package:flutter/material.dart';

class EditingSettings extends StatelessWidget {
  static final int ID_BRIGHTNESS = 0;
  static final int ID_CONTRAST = 1;
  static final int ID_SATURATION = 2;
  static final int ID_FILTERS = 3;

  static int currentChoice = 0;
  static int lastChoice = 0;

  static final List<Widget> iconsEditor = [
    IconEditor(ID_BRIGHTNESS, 'Helligkeit', Icons.brightness_6,
        isPressed: true),
    IconEditor(ID_CONTRAST, 'Kontrast', Icons.invert_colors_on),
    IconEditor(ID_SATURATION, 'Sättigung', Icons.brush),
    IconEditor(ID_FILTERS, 'Filters', Icons.filter_vintage_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(), // sliders
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...EditingSettings.iconsEditor, // options
          ],
        ),
      ],
    );
  }
}

class IconEditor extends StatefulWidget {
  final int id;
  final String label;
  final IconData icon;
  final bool isPressed;

  IconEditor(this.id, this.label, this.icon, {this.isPressed = false});

  @override
  State<StatefulWidget> createState() {
    return IconEditorState(isPressed);
  }
}

class IconEditorState extends State<IconEditor> {
  bool isPressed;

  IconEditorState(this.isPressed);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: isPressed ? 1 : 0,
        ),
      ),
      child: Column(
        children: <Widget>[
          IconButton(
            icon: Icon(widget.icon),
            color: Theme.of(context).accentColor,
            onPressed: () {
              setState(() {
                EditingSettings.lastChoice = EditingSettings.currentChoice;
                EditingSettings.currentChoice = widget.id;
                for (int i = 0; i < EditingSettings.iconsEditor.length; i++) {
                  if ((EditingSettings.iconsEditor[i] as IconEditor).id ==
                      EditingSettings.lastChoice)
                    //(EditingSettings.iconsEditor[i] as IconEditor).isPressed = false;
                    isPressed = false;
                }
                isPressed = true;
              });
            },
          ),
          Text(
            widget.label,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ],
      ),
    );
  }
}
