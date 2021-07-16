library strollr.globals;

import 'package:flutter/material.dart';
import 'package:strollr/Tabs/stats.dart';
import 'package:strollr/stop_watch_timer.dart';
import 'model/picture_categories.dart';

export 'globals.dart';

final StopWatchTimer stopWatchTimer = StopWatchTimer();

int currentSliderValue = 2021;
String month = '';

final String mushroomImagePath = "assets/images/mushroomIcon.png";
final String plantImagePath = "assets/images/plantIcon.png";
final String animalImagePath = "assets/images/animalFootstepIcon.png";
final String treeImagePath = "assets/images/treeIcon.png";
final String undefinedCategoryImagePath = "assets/images/defaultIcon.png";

// ugly stuff TODO better ^^
final Map<int, Categories> idToCategoryMap = {
  1: Categories.undefined,
  2: Categories.trashbin,
  3: Categories.animal,
  4: Categories.tree,
  5: Categories.plant,
  6: Categories.mushroom,
};
// **************** STECKBRIEF QUESTIONS ********************
/*
Map<Categories, List<String>> questionsForCategory = {
  Categories.animal: [
    'Was für ein Tier ist das?',
    'zB Hase, Ameise,...',
    'Womit ernährt sich das Tier?',
    'zB ernähren sich Ameisen von Insekten, Pflanzensäften und dem Honigtau von Schildläusen oder Blattläusen'
  ],
  Categories.mushroom: [
    'Was für ein Pilz ist das?',
    'zB Pfifferling, Austernpilz',
    'Ist es giftig oder kann man es essen?',
    'Austernpilz ist essbar, kann aber mit Gelbstieligen Muschelseitling verwechelt werden, der auch Giftstoffe enthalten kann'
  ],
  Categories.plant: [
    'Was für eine Pflanze ist das?',
    'zB Goldtaler, Kapkörbchen, ... ',
    'Wann und wie oft blüht diese Pflanze?',
    'zB hat Kapkörbchen eine Blütezeit von Mai bis September'
  ],
  Categories.tree: [
    'Was für einen Baum ist das?',
    'zB Eiche, Tanne,...',
    'Wo wachsen solche Bäume?',
    'zB kann die Eiche nicht im Schatten anderer Gehölze wachsen'
  ],
};

 */

final String descriptionField = "Erzähl was du darüber weißt!";

Map<Categories, List<String>> questionsForCategory = {
  Categories.animal: [
    'Name des Tieres:',
    'zB Hase, Ameise,...',
    'Art der Ernährung:',
    'zB Fleischfresser oder Pflanzenfresser'
  ],
  Categories.mushroom: [
    'Name des Pilzes:',
    'zB Pfifferling, Austernpilz',
    'Ist der Pilz giftig oder kann man ihn essen?',
    'Austernpilz ist essbar, kann aber mit Gelbstieligen Muschelseitling verwechelt werden, der auch Giftstoffe enthalten kann'
  ],
  Categories.plant: [
    'Name der Pflanze:',
    'zB Goldtaler, Kapkörbchen, ... ',
    'Blütezeit der Pflanze:',
    'zB hat Kapkörbchen eine Blütezeit von Mai bis September'
  ],
  Categories.tree: [
    'Name des Baumes:',
    'zB Eiche, Tanne,...',
    'Wo wachsen solche Bäume?',
    'zB kann die Eiche nicht im Schatten anderer Gehölze wachsen'
  ],
};
