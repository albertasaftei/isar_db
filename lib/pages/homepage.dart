import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:isar_db/components/drawer.dart';
import 'package:isar_db/models/user.dart';
import 'package:isar_db/models/user_database.dart';
import 'package:isar_db/utils/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController dateFromController = TextEditingController();
  TextEditingController dateToController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<UserDatabase>().loadUsers();
    super.initState();
  }

  Future<void> _selectDateFrom() async {
    DateTime? _datePicked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2010),
        lastDate: DateTime.now());

    if (_datePicked != null) {
      dateFromController.text = _datePicked.toString();
    }
  }

  Future<void> _selectDateTo() async {
    DateTime? _datePicked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (_datePicked != null) {
      dateToController.text = _datePicked.toString();
    }
  }

  void filterUsers() {
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
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2)
                          ],
                          controller: ageController,
                          decoration: const InputDecoration(labelText: 'Age'),
                        ),
                        TextFormField(
                          readOnly: true,
                          controller: dateFromController,
                          decoration: const InputDecoration(
                              labelText: 'Creation date from',
                              prefixIcon: Icon(Icons.calendar_today)),
                          mouseCursor: MaterialStateMouseCursor.clickable,
                          onTap: _selectDateFrom,
                        ),
                        TextField(
                          readOnly: true,
                          controller: dateToController,
                          decoration: const InputDecoration(
                              labelText: 'Creation date to',
                              prefixIcon: Icon(Icons.calendar_today)),
                          mouseCursor: MaterialStateMouseCursor.clickable,
                          onTap: _selectDateTo,
                        )
                      ],
                    ))
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
                  if (_formKey.currentState!.validate()) {
                    log('filters applied successfully $dateFromController.text');
                    context.read<UserDatabase>().filterUsers(
                        name: nameController.text,
                        age: ageController.text.isNotEmpty
                            ? int.parse(ageController.text)
                            : null,
                        dateFrom: dateFromController.text.isNotEmpty
                            ? DateTime.parse(dateFromController.text)
                            : null,
                        dateTo: dateToController.text.isNotEmpty
                            ? DateTime.parse(dateToController.text)
                            : null);
                    nameController.clear();
                    ageController.clear();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Filter'),
              ),
            ],
          );
        });
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
          actions: [
            IconButton(
              onPressed: filterUsers,
              icon: const Icon(Icons.filter_alt_outlined),
            )
          ],
        ),
        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: createUser,
          child: const Icon(Icons.add),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _renderCards(users),
            ElevatedButton(onPressed: () {}, child: const Text('Load Users'))
          ],
        ));
  }

  // MARK: - Render Cards
  ListView _renderCards(List<User> users) {
    return ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
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
