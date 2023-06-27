import 'dart:math';

import 'package:testing/shape.dart';
import 'package:test/test.dart';

void main() {

  test('area should be 100', () {
   final primerrectangulo = Rectangle(10, 10);
    expect(primerrectangulo.area, 100);
  });

  test('puntos y objetos e instancias', () {
    final primerrectangulo = Rectangle(10, 10);
    primerrectangulo.center = Point(4, 4);

    expect(primerrectangulo.area, 100);
  });

}