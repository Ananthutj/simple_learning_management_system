import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms_app/business_logic/modules/modules_bloc.dart';
import 'package:lms_app/business_logic/subjects/subjects_bloc.dart';
import 'package:lms_app/business_logic/videos/videos_bloc.dart';
import 'package:lms_app/data/repo/modules_repo.dart';
import 'package:lms_app/data/repo/subjects_repo.dart';
import 'package:lms_app/data/repo/videos_repo.dart';
import 'package:lms_app/presentation/screens/home_page.dart';
import 'package:lms_app/routes/router.dart';

void main() async{
  runApp(const LMS());
}

class LMS extends StatelessWidget {

  const LMS({super.key});

  @override
  Widget build(BuildContext context) {
    final SubjectsRepo subjectsRepo = SubjectsRepo();
    final ModulesRepo modulesRepo = ModulesRepo();
    final VideosRepo videosRepo = VideosRepo();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=> SubjectsBloc(subjectsRepo)),
        BlocProvider(create: (context)=> ModulesBloc(modulesRepo)),
        BlocProvider(create: (context)=> VideosBloc(videosRepo))
      ],
      child: MaterialApp(
        title: 'Learning Management System',
        debugShowCheckedModeBanner: false,
        initialRoute: '/HomePage',
        onGenerateRoute: RouteGenerator.generateRoute,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
