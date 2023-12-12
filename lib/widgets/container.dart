import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../riverpod/riverpod.dart';

class ContainerWidget extends ConsumerWidget {
  const ContainerWidget({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String title, description;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userList = ref.watch(todoData);
    User currentUser = userList.firstWhere(
      (user) => user.title == title && user.description == description,
    );

    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  _showBottomSheetUpdate(context, ref, title, description);
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.edit_note_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () {
                  ref.read(todoData.notifier).removeData(currentUser);
                },
                child: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.delete, color: Colors.redAccent)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBottomSheetUpdate(BuildContext context, WidgetRef ref, String title, String description) {
    final contTitle = TextEditingController(text: title);
    final contDescription = TextEditingController(text: description);
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
          height: 600.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Let's Update",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              textFormWidget(contTitle, false, "Enter Title"),
              const SizedBox(height: 16.0),
              textFormWidget(contDescription, true, "Enter Description"),
              const SizedBox(height: 16.0),
              InkWell(
                onTap: () {
                  var existingUser = ref.read(todoData).firstWhere(
                        (user) => user.title == title && user.description == description,
                        orElse: () => User(title: '', description: ''),
                      );

                  if (contTitle.text.isNotEmpty && contDescription.text.isNotEmpty) {
                    User updatedUser = User(
                      title: contTitle.text,
                      description: contDescription.text,
                    );
                    ref.read(todoData.notifier).updateData(existingUser, updatedUser).whenComplete(() {
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
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
