class MapUtils {
  /// Adds a string (leaf) to the map at the specified path
  static void addStringToMap({
    required Map<String, dynamic> map,
    required String destinationPath,
    required String leafContent,
  }) {
    final pathList = destinationPath.split('.');

    // starts with type Map<String, dynamic> but
    // may be a Map<String, dynamic> or List<dynamic> after the 1st iteration
    dynamic curr = map;

    for (int i = 0; i < pathList.length; i++) {
      final subPath = pathList[i];
      final subPathInt = int.tryParse(subPath);

      final nextSubPath = i + 1 < pathList.length ? pathList[i + 1] : null;
      final nextIsList =
          nextSubPath != null ? int.tryParse(nextSubPath) != null : false;

      if (i == pathList.length - 1) {
        // destination
        if (subPathInt != null) {
          if (!(curr is List)) {
            throw 'The leaf "$destinationPath" cannot be added because the parent of "$subPathInt" is not a list.';
          }
          final added = addToList(
            list: curr,
            index: subPathInt,
            element: leafContent,
            overwrite: true,
          );

          if (!added) {
            throw 'The leaf "$destinationPath" cannot be added because there are missing indices.';
          }
        } else {
          if (!(curr is Map)) {
            throw 'The leaf "$destinationPath" cannot be added because the parent of "$subPath" is not a map.';
          }
          curr[subPath] = leafContent;
        }
      } else {
        // make sure that the path to the leaf exists
        if (subPathInt != null) {
          // list mode
          if (!(curr is List)) {
            throw 'The leaf "$destinationPath" cannot be added because the parent of "$subPathInt" is not a list.';
          }

          final added = addToList(
            list: curr,
            index: subPathInt,
            element: nextIsList ? <dynamic>[] : <String, dynamic>{},
            overwrite: false,
          );

          if (!added) {
            throw 'The leaf "$destinationPath" cannot be added because there are missing indices.';
          }

          curr = curr[subPathInt];
        } else {
          // map mode
          if (!(curr is Map)) {
            throw 'The leaf "$destinationPath" cannot be added because the parent of "$subPath" is not a map.';
          }

          if (!curr.containsKey(subPath)) {
            // path touches first time the tree, make sure the path exists
            // but do not overwrite,
            // so previous [addStringToMap] calls get not lost
            curr[subPath] = nextIsList ? <dynamic>[] : <String, dynamic>{};
          }

          curr = curr[subPath];
        }
      }
    }
  }

  /// Adds an element to the list
  /// Adding must be in the correct order, so if the list is too small, then it won't be added
  /// Returns true, if the element was added
  static bool addToList({
    required List list,
    required int index,
    required dynamic element,
    required bool overwrite,
  }) {
    if (index <= list.length) {
      if (index == list.length) {
        list.add(element);
      } else if (overwrite) {
        list[index] = element;
      }
      return true;
    } else {
      return false;
    }
  }
}
