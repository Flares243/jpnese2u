part of 'model.dart';

extension ListCaptureTokenData on List<CaptureTokenData> {
  List<int> get tokenIds => map((t) => t.id).toList();

  List<Hinshi> get presentHinshi => map((t) => Hinshi.fromJp(t.pos)).nonNulls
      .fold(<Hinshi>[], (list, h) => list.contains(h) ? list : [...list, h]);

  Map<Hinshi, List<CaptureTokenData>> get hinshiMapping {
    final map = fold(<Hinshi, List<CaptureTokenData>>{}, (map, t) {
      final h = Hinshi.fromJp(t.pos);
      if (h == null) return map;

      return {
        ...map,
        h: [...(map[h] ?? []), t],
      };
    });

    return Map.fromEntries(
      Hinshi.values
          .where((h) => map.containsKey(h))
          .map((h) => MapEntry(h, map[h]!)),
    );
  }
}
