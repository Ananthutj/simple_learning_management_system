import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms_app/business_logic/subjects/subjects_bloc.dart';
import 'package:lms_app/globals/extensions.dart';
import 'package:lms_app/globals/text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();

    context.read<SubjectsBloc>().add(FetchSubjects());
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            pinned: true,
            floating: true,
            backgroundColor: const Color.fromARGB(255, 72, 36, 87),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Home Page",
              style: h6.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: context.colorScheme.surface,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(context.height / 11.7),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 7),
                child: TextFormField(
                  controller: searchController,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                    hintText: "Search here...",
                    hintStyle: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: context.colorScheme.onSurface,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: context.colorScheme.onSurface,
                      ),
                      onPressed: () => searchController.clear(),
                    ),
                    filled: true,
                    fillColor: context.colorScheme.surface.withOpacity(0.9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: context.colorScheme.surface,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: BlocBuilder<SubjectsBloc, SubjectsState>(
          builder: (context, state) {
            if (state is SubjectsFetched) {
              final subjects = state.subjects;
              print(subjects.length);
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    height:
                        150, 
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            subject
                                .image,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors
                                  .grey,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Text(
                            subject.title,
                            style: s3.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is SubjectsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SubjectsError) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else {
              return const Center(
                child: Text("No subjects are available now"),
              );
            }
          },
        ),
      ),
    );
  }
}
