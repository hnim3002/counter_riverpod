import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_riverpod/providers/counter.dart';

part 'counter_provider.g.dart';

@riverpod
class CounterNotifier extends _$CounterNotifier {
  @override
  Future<Counter?> build() async {
    print("CounterNotifier building...");

    ref.onDispose(() {
      print(("CounterNotifier disposed!!!!"));
    });
    return Counter();
  }

  Future<void> increment() async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(seconds: 1));
    state = AsyncData(state.valueOrNull?.increase());
    // print("new state: $state");
  }

  Future<void> decrement() async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(seconds: 1));
    state = AsyncData(state.valueOrNull?.decrease());
    // print("new state: $state");
  }

  Future<void> forceError() async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(seconds: 1));
    state = AsyncError(
        Exception("CounterNotifier sample error..."), StackTrace.current);
  }
}
