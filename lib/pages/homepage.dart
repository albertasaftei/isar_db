import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:isar_db/components/drawer.dart';
import 'package:isar_db/models/user.dart';
import 'package:isar_db/models/user_database.dart';
import 'package:isar_db/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    context.read<UserDatabase>().loadUsers();
    super.initState();
  }

  void createUser() {
    User user = User();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2)
                  ],
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  user.name = nameController.text;
                  user.age = ageController.text.isNotEmpty
                      ? int.parse(ageController.text)
                      : null;
                  user.createdAt = DateTime.now();
                  ageController.clear();
                  nameController.clear();
                  Provider.of<UserDatabase>(context, listen: false)
                      .addUser(user);
                  Navigator.of(context).pop();
                },
                child: const Text('Create'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final userDatabase = context.watch<UserDatabase>();
    List<User> users = userDatabase.users;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Isar DB'),
        ),
        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: createUser,
          child: const Icon(Icons.add),
        ),
        body: _renderCards(users));
  }

  ListView _renderCards(List<User> users) {
    return ListView.separated(
        separatorBuilder: (context, index) => const Gap(5),
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            child: ListTile(
              style: ListTileStyle.list,
              title: Text(
                users[index].name ?? '',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Age: ${users[index].age ?? 'N/A'}'),
                  Text(
                    'Created: ${DateFormat('dd-MM-yyyy').format(users[index].createdAt ?? DateTime.now())}',
                    style: TextStyle(
                        color: Provider.of<ThemeProvider>(context)
                            .themeData
                            .colorScheme
                            .primary),
                  )
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        nameController.text = users[index].name ?? '';
                        ageController.text = users[index].age.toString();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                          labelText: 'Name'),
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(2)
                                      ],
                                      controller: ageController,
                                      decoration: const InputDecoration(
                                          labelText: 'Age'),
                                    )
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      nameController.clear();
                                      ageController.clear();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.read<UserDatabase>().updateUser(
                                          users[index].id,
                                          nameController.text,
                                          int.parse(ageController.text));
                                      nameController.clear();
                                      ageController.clear();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Update'),
                                  ),
                                ],
                              );
                            });
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      Provider.of<UserDatabase>(context, listen: false)
                          .deleteUser(users[index].id);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
