library strollr.globals;

import 'package:strollr/stop_watch_timer.dart';
import 'model/picture_categories.dart';

export 'globals.dart';

final StopWatchTimer stopWatchTimer = StopWatchTimer();

final String mushroomImagePath = "assets/images/mushroomIcon.png";
final String plantImagePath = "assets/images/plantIcon.png";
final String animalImagePath = "assets/images/animalFootstepIcon.png";
final String treeImagePath = "assets/images/treeIcon.png";

late Map<int, Categories> idToCategory;
// **************** STECKBRIEF QUESTIONS ********************

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

final String descriptionField = "Erzähl was du darüber weißt!";
