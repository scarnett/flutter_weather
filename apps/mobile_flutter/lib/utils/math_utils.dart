double round5({
  required num number,
  num offset: 0,
}) {
  if ((number % 5) == 0) {
    return (number + 5.0);
  }

  return ((number / 5.0).ceil() * 5.0) + offset;
}
