class Animal {
  Animal(
this.name
, this.age);
  
  int age;
  String name;

  String talk() {
    return('grrrr');
  }
}

class Cat extends Animal {
  // use the 'super' keyword to interact with 
  // the super class of Cat
  Cat(String name, int age) : super(name, age);
  void ronronear()
  {
    print ("sonido de ronroneo");
  }
  String talk() {
    return('meow');
  }
  
}


class Dog extends Animal {
  // use the 'super' keyword to interact with 
  // the super class of Cat
  Dog(String name, int age) : super(name, age);
  
  String talk() {
    return('bark');
  }
  void hacercaso ()
  {
    print ('a sus ordentes');
  }
}

class Cow extends Animal {
  // use the 'super' keyword to interact with 
  // the super class of Cat
  Cow(String name, int age) : super(name, age);
  String talk() {
    return('muuu');
  }
} 