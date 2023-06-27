// Import the test package and Counter class
//import 'dart:js_util';

import 'package:testing/animals.dart';
import 'package:test/test.dart';

void main() {
  test('crear un animal', () {
    final animalgenerico = Animal("pepe", 12);
    
    expect(
animalgenerico.talk
(), "grrrr");

    final morena = Dog("morena", 4);
    morena.hacercaso();
    expect(
morena.talk
(), "bark");

    final lina = Cat("lina",11);
    lina.ronronear();
    
    final lola = Cow("lola",12);
    expect(
lola.talk
(), "muuu");
  });
} 