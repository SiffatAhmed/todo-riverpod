import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoData = StateNotifierProvider<UserProvider, List<User>>((ref) => UserProvider());

class UserProvider extends StateNotifier<List<User>> {
  UserProvider()
      : super([
          User(title: "Go out with friends", description: "Take some time off to get some social time"),
          User(title: "Read a Book", description: "Spend some quiet time reading a book to relax and unwind."),
          User(title: "Give an hour to course", description: "Continue course riverpod topic "),
          User(title: "Plan vacations", description: "Plan vacations and find activities for off time.")
        ]);

  Future addData(List<User> user) async {
    state = [...state, ...user];
  }

  Future<void> removeData(User user) async {
    state = List.from(state)..remove(user);
  }

  Future<void> updateData(User existingUser, User updatedUser) async {
    state = state.map((user) {
      if (user.title == existingUser.title && user.description == existingUser.description) {
        return updatedUser;
      }
      return user;
    }).toList();
  }
}

class User {
  User({this.title, this.description});
  String? title, description;
}
