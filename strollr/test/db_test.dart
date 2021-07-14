import 'package:flutter_test/flutter_test.dart';
import 'package:strollr/db/database_interface_helper.dart';
import 'package:strollr/db/database_manager.dart';
import 'package:strollr/model/walk.dart';
import 'package:strollr/model/picture.dart';

import 'package:flutter/services.dart' show rootBundle;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    // clean up db before every test
     // await DatabaseManager.instance.deleteDb();
  });

  tearDownAll(() async {
    // clean up db after all tests
    // await DatabaseManager.instance.deleteDb();
  });

  group('DatabaseManager', () {
    Walk walk = _createTestWalk('first test walk');
    Walk walk1 = _createTestWalk('second test walk');
    Walk walk2 = Walk(
      name: 'third walk ',
      durationTime: ("01:30:00"),
      distanceInKm: 4.1,
      route: 'should be a xml file',
      startedAtTime: DateTime.parse("2022-04-23 11:30:00Z"),
      endedAtTime: DateTime.parse("2023-01-07 13:00:00Z"),
    );
    late Picture picture;
    test('Insert walk', () async {
      // insert a walk
      walk = await DatabaseOperations.insertWalk(walk);
      walk1 = await DatabaseOperations.insertWalk(walk1);
      walk2 = await DatabaseOperations.insertWalk(walk2);

      //expect((await DatabaseManager.instance.readALlWalks()).length,
      //   DatabaseOperations.walksCounter);
/*
      YearWithDuration res1 = await DbHelper.readAllWalkDurationMonthlyInAYear(2023);
      int i2 = 1;
      print('${res1.durationPerMonth.length}');
      for (double dist in res1.durationPerMonth) {
        print('day: ${i2}, duration: ${dist}');
        i2++;
      }
      
 */


      /*
      List<DailyDistance> res = await DatabaseManager.instance
          .readAllWalkDistancesInAMonth('04', '2023');
      print(res.length);
      for (DailyDistance dist in res) {
        print('day: ${dist.day}, distance: ${dist.distance}');
      }

       */
    });

/*
    test('Insert picture', () async {
      // insert a picture to the DB
      picture = await _createTestPicture(walk.id!);
      picture = await DatabaseOperations.insertPicture(picture);
      expect((await DatabaseManager.instance.readALlPictures()).length,
          DatabaseOperations.picturesCounter);
    });


    test('Update walk', () async {
      String newName = 'updated walk';
      Walk updatedWalk = walk.copy();
      updatedWalk.name = newName;
      await DatabaseManager.instance.updateWalk(updatedWalk);
      expect((await DatabaseManager.instance.readALlWalks()).length,
          DatabaseOperations.walksCounter);
      expect((await DatabaseManager.instance.readWalkFromId(walk.id!)).name, newName);
    });

    test('Update picture', () async {
      int newCategory = 2;
      Picture updatedPicture = picture.copy();
      updatedPicture.category = newCategory;
      await DatabaseManager.instance.updatePicture(updatedPicture);
      expect((await DatabaseManager.instance.readALlPictures()).length,
          DatabaseOperations.picturesCounter);
      expect(
          (await DatabaseManager.instance
                  .readALlPicturesFromCategory(newCategory))
              .length,
          DatabaseOperations.picturesCounter);
      expect(
          (await DatabaseManager.instance.readALlPicturesFromWalkInCategory(
                  picture.walk_id, newCategory))
              .length,
          DatabaseOperations.picturesCounter);
      expect(
          (await DatabaseManager.instance.readPictureFromPictureId(picture.id!))
              .category,
          newCategory);
    });


    test('Delete walk', () async {
      Walk toDeleteWalk = _createTestWalk('delete me');
      toDeleteWalk = await DatabaseOperations.insertWalk(toDeleteWalk);
      expect((await DatabaseManager.instance.readALlWalks()).length,
          DatabaseOperations.walksCounter);
      await DatabaseOperations.deleteWalk(toDeleteWalk.id!);
      expect((await DatabaseManager.instance.readALlWalks()).length,
          DatabaseOperations.walksCounter);
      List<Walk> currentWalks =
          (await DatabaseManager.instance.readALlWalks()).toList();
      for (var i = 0; i < currentWalks.length; i++) {
        expect(currentWalks[i].id == toDeleteWalk.id, false);
      }
    });

     */

    test('Delete picture', () async {
      Picture toDeletePicture = await _createTestPicture(walk.id!);
      toDeletePicture = await DatabaseOperations.insertPicture(toDeletePicture);
      await DatabaseOperations.deletePicture(toDeletePicture.id!);
      List<Picture> currentPictures =
          (await DatabaseManager.instance.readALlPictures()).toList();
      for (var i = 0; i < currentPictures.length; i++) {
        expect(currentPictures[i].id == toDeletePicture.id, false);
      }
    });
  });
}

Walk _createTestWalk(String name) {
  return Walk(
    name: name,
    durationTime: '01:40:00',
    distanceInKm: 3.56,
    route: 'should be a xml file',
    startedAtTime: DateTime.parse("2021-04-22 11:30:00Z"),
    endedAtTime: DateTime.parse("2023-12-28 13:00:00Z"),
  );
}

Future<Picture> _createTestPicture(int walkID) async {
  final bytes = (await rootBundle.load('assets/images/startScreen.jpg'))
      .buffer
      .asUint8List();
  return Picture(
    pictureData: bytes,
    filename: 'someNameHere.jpg',
    createdAtTime: DateTime.parse("2021-05-22 11:40:00Z"),
    generic1: 'black, if that is a color',
    generic2: 'not too big',
    description: 'gonna put sth here later',
    location: 'some gps data',
    category: 1,
    walk_id: walkID,
  );
}

// no need of this class if the database is cleaned after each test! See SetUp() in main()
class DatabaseOperations {
  static int picturesCounter = 0;
  static int walksCounter = 0;

  static Future<Walk> insertWalk(Walk walk) async {
    walksCounter++;
    return await DatabaseManager.instance.insertWalk(walk);
  }

  static Future<Picture> insertPicture(Picture picture) async {
    picturesCounter++;
    return await DatabaseManager.instance.insertPicture(picture);
  }

  static Future<int> deleteWalk(int id) async {
    walksCounter--;
    return await DatabaseManager.instance.deleteWalk(id);
  }

  static Future<int> deletePicture(int id) async {
    picturesCounter--;
    return await DatabaseManager.instance.deletePicture(id);
  }
}
