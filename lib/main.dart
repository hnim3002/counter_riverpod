import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_riverpod/providers/counter_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  void _incrementCounter() {
    ref.read(counterNotifierProvider.notifier).increment();
  }

  void _decrementCounter() {
    final variable = ref.read(counterNotifierProvider);
    final variable2 = ref.read(counterNotifierProvider.notifier);

    // variable2.decrement();
    ref.read(counterNotifierProvider.notifier).decrement();
  }

  void _onBack() {
    final lastValue = ref.read(counterNotifierProvider);
    print("lastValue: $lastValue");
    Navigator.of(context).pop();
  }

  void _forceError() {
    ref.read(counterNotifierProvider.notifier).forceError();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(counterNotifierProvider);
    ref.listen(counterNotifierProvider, (prev, next) {
      if (next is AsyncError) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Something went wrong: ${next.error}"),
            );
          },
        );
      }
    });

    print("asyncValue: $asyncValue");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            if (asyncValue is AsyncLoading) const CircularProgressIndicator(),
            if (asyncValue is AsyncData)
              Text(
                '${asyncValue.valueOrNull?.value}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            TextButton(
                onPressed: _decrementCounter, child: const Text('Decrement')),
            TextButton(onPressed: _onBack, child: const Text('BACK')),
            TextButton(onPressed: _forceError, child: const Text('FORCE ERROR'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: asyncValue is AsyncLoading ? null : _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    print("MyHomePage widget disposed!");
    super.dispose();
  }
}
