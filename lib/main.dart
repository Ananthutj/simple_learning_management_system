import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms_app/business_logic/subjects/subjects_bloc.dart';
import 'package:lms_app/data/repo/subjects_repo.dart';
import 'package:lms_app/presentation/screens/home_page.dart';

void main() {
  runApp(const LMS());
}

class LMS extends StatelessWidget {

  const LMS({super.key});

  @override
  Widget build(BuildContext context) {
    final SubjectsRepo subjectsRepo = SubjectsRepo();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=> SubjectsBloc(subjectsRepo))
      ],
      child: MaterialApp(
        title: 'Learning Management System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
