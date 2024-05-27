import 'flattened_datamap.dart';

typedef DataCounter<T, S> = Map<T, Map<S, int>>;

extension DataMapExtension<T, S> on DataCounter<T, S> {
  void initKeyA(List<T> keyAList) {
    for (T key in keyAList) {
      this[key] = {};
    }
  }

  void increment(T keyA, S keyB, {int by = 1}) {
    this[keyA]![keyB] = (this[keyA]![keyB] ?? 0) + by;
  }

  int combinedLength() {
    int length = 0;
    for (T keyA in keys.toList()) {
      length += this[keyA]!.length;
    }
    return length;
  }

  FlatDatamap flatten(List<String> varNames) {
    int length = combinedLength(), k = 0;

    List<Map<String, dynamic>> list = List.filled(length, {});
    for (var keyA in keys) {
      for (var keyB in this[keyA]!.keys) {
        list[k++] = {
          varNames[0]: keyA,
          varNames[1]: keyB,
          varNames[2]: this[keyA]![keyB]
        };
      }
    }
    return list;
  }

  FlatDatamap flattenInnerMap(T keyA, List<String> varNames) {
    int k = 0, listLen = this[keyA]!.keys.length;
    List<Map<String, dynamic>> list = List.filled(listLen, {});
    for (var mapKey in this[keyA]!.keys) {
      list[k++] = {varNames[0]: mapKey, varNames[1]: this[keyA]![mapKey]};
    }
    return list;
  }

  DataCounter<T, S> sortByValue({int n = -1}) {
    int m = n;
    DataCounter<T, S> dataCounter = {};
    for (T keyA in keys) {
      if (this[keyA]!.isNotEmpty) {
        var mapEntries = this[keyA]!.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        Map<S, int> innerMap = <S, int>{}..addEntries(mapEntries);
        if (n == -1) m = innerMap.keys.length;
        dataCounter[keyA] = {
          for (var key in innerMap.keys.take(m)) key: innerMap[key] ?? 0
        };
      }
    }
    return dataCounter;
  }

  Map<T, int> sumInnerMaps() {
    Map<T, int> sum = {for (T keyA in keys) keyA: 0};
    for (T keyA in keys) {
      for (S keyB in this[keyA]!.keys) {
        sum[keyA] = sum[keyA]! + this[keyA]![keyB]!;
      }
    }
    return sum;
  }
}
