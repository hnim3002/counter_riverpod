class Counter {
  int value = 0;

  Counter({int initValue = 2}) {
    value = initValue;
  }

  Counter increase() {
    value++;
    return this;
  }

  Counter decrease() {
    value--;
    return this;
  }
}
