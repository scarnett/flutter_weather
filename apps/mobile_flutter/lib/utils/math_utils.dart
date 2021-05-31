double round5({
  required num number,
  num? offset,
}) {
  if ((number % 5) == 0) {
    return (number + (offset?.toDouble() ?? 5.0));
  }

  return (((number % 5.0) >= 2.5)
          ? (((number / 5.0).ceil() * 5.0))
          : ((number / 5.0).ceil() * 5.0)) +
      (offset?.toDouble() ?? 0.0);
}
