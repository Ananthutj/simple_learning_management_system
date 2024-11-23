import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms_app/business_logic/modules/modules_bloc.dart';
import 'package:lms_app/data/models/subjects.dart';
import 'package:lms_app/globals/extensions.dart';
import 'package:lms_app/globals/text_styles.dart';

class ModulesPage extends StatefulWidget {
  final Subjects subject;
  const ModulesPage({super.key, required this.subject});

  @override
  State<ModulesPage> createState() => _ModulesPageState();
}

class _ModulesPageState extends State<ModulesPage> {
  @override
  void initState() {
    context.read<ModulesBloc>().add(FetchModules(subjectId: widget.subject.id));
    super.initState();
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 70, 81, 100), Color.fromARGB(255, 72, 97, 108)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildModuleCard(String title, int id,String description) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/VideosPage',
            arguments: {
              'modName': title,
              'modId': id,
            },
          );
        },
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            id.toString(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          title,
          style: b2.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description,style: b4,),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            "No modules are currently available",
            style: h3.copyWith(color: Colors.red),
          ),
        ],
      ),
    );
  }

 Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color.fromARGB(255, 243, 152, 33),),
          SizedBox(height: 16),
          Text("Loading Modules..."),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              widget.subject.title,
              style: h1.copyWith(color: context.colorScheme.surface),
            ),
            leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios,color: context.colorScheme.surface,)),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 41, 60, 93).withOpacity(0.9),
            elevation: 0,
          ),
          body: BlocBuilder<ModulesBloc, ModulesState>(
            builder: (context, state) {
              if (state is ModulesLoading) {
                return _buildLoadingState();
              } else if (state is ModulesError) {
                return _buildErrorState();
              } else if (state is ModulesFetched && widget.subject.id == 1) {
                final modules = state.modules;
                if (modules.isEmpty) {
                  return _buildErrorState();
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: modules.length,
                  itemBuilder: (context, index) {
                    final module = modules[index];
                    return _buildModuleCard(module.title, module.id,module.description);
                  },
                );
              } else {
                return _buildErrorState();
              }
            },
          ),
        ),
      ],
    );
  }
}
