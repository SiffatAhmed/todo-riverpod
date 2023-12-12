import 'package:crud_riverpod/riverpod/riverpod.dart';
import 'package:crud_riverpod/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.red,
        ),
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final String title = "";
  final String description = "CRUD Project Using Riverpod";
  final TextEditingController _contTitle = TextEditingController();
  final TextEditingController _contDescription = TextEditingController();

  MyApp({super.key});

  clearFn() {
    _contTitle.clear();
    _contDescription.clear();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CRUD Operations Using riverpod'),
        ),
        body: Consumer(
          builder: (context, ref, child) {
            var data = ref.watch(todoData);
            return data.isNotEmpty
                ? ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final user = data[index];
                      return ContainerWidget(title: user.title.toString(), description: user.description.toString());
                    },
                  )
                : Center(
                    child: Text(
                      "No Todo tasks",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            _showBottomSheetAdd(context, ref);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showBottomSheetAdd(
    BuildContext context,
    WidgetRef ref,
  ) {
    TextEditingController contTitle = TextEditingController();
    TextEditingController contDescription = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Create Note",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              textFormWidget(contTitle, false, "Enter Title"),
              const SizedBox(height: 16.0),
              textFormWidget(contDescription, true, "Enter Description"),
              const SizedBox(height: 16.0),
              InkWell(
                onTap: () {
                  if (contTitle.text.isNotEmpty && contDescription.text.isNotEmpty) {
                    ref.read(todoData.notifier).addData([
                      User(
                        title: contTitle.text,
                        description: contDescription.text,
                      )
                    ]).whenComplete(() {
                      clearFn();
                      Navigator.of(context).pop();
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

textFormWidget(TextEditingController controller, bool val, String hint) {
  return TextFormField(
    controller: controller,
    maxLines: val ? 5 : 1,
    decoration: InputDecoration(
      labelText: hint,
      alignLabelWithHint: true,
      hintText: 'Type something',
      hintMaxLines: 1,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
    ),
  );
}
