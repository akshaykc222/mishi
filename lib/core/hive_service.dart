import 'package:hive/hive.dart';

import '../mishi/presentation/utils/pretty_print.dart';

class HiveService {
  Future<Box<T>> getBox<T>({required String boxName}) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    } else {
      return await Hive.openBox<T>(boxName);
    }
  }

  isExists({required String boxName}) async {
    final openBox = await getBox(boxName: boxName);
    int length = openBox.length;
    return length != 0;
  }

  addBoxes<T>(List<T> items, String boxName) async {
    final openBox = await getBox<T>(boxName: boxName);
    final existingItems = openBox.values.toList();
    // final deleteItems =
    //     openBox.values.where((element) => !items.contains(element));
    // prettyPrint(msg: deleteItems.toSet().toString());
    // deleteItems.toList().asMap().forEach((key, value) {
    //   prettyPrint(msg: "deleting items $key $value");
    //   try {
    //     openBox.deleteAt(key);
    //   } catch (e) {
    //     prettyPrint(msg: e.toString());
    //   }
    // });
    items.asMap().forEach((index, item) {
      if (existingItems.contains(item)) {
        prettyPrint(msg: "item exits updated $item");
        openBox.put(index, item);
      } else {
        prettyPrint(msg: "item added $item");
        openBox.add(item);
      }
    });
    // for (var item in items) {
    //
    // }
  }

  clearAllValues<T>(String boxName) async {
    final openBox = await getBox<T>(boxName: boxName);
    await openBox.clear();
  }

  clearWithWhere<T>(String boxName, String value) async {
    final openBox = await getBox<T>(boxName: boxName);
    openBox.values.toList().asMap().forEach((key, v) {
      if (value == v) {}
    });
  }

  getBoxes<T>(String boxName) async {
    List<T> boxList = <T>[];

    final openBox = await getBox(boxName: boxName);

    int length = openBox.length;

    for (int i = 0; i < length; i++) {
      boxList.add(await openBox.getAt(i));
    }

    return boxList;
  }
}
