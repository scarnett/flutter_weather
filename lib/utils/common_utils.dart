String toCamelCase(
  String str,
) {
  String s = str
      .replaceAllMapped(
          RegExp(
              r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+'),
          (Match m) =>
              "${m[0][0].toUpperCase()}${m[0].substring(1).toLowerCase()}")
      .replaceAll(RegExp(r'(_|-|\s)+'), '');
  return s[0].toLowerCase() + s.substring(1);
}

class Nullable<T> {
  T _value;

  Nullable(
    this._value,
  );

  T get value => _value;
}
