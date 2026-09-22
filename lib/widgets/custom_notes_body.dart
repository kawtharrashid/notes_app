import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/cubits/notes_cubit/notes_cubit.dart';
import 'package:notesapp/widgets/custom_app_bar.dart';
import 'package:notesapp/widgets/custom_icon.dart';
import 'package:notesapp/widgets/notes_list_view.dart';

class CustomNotesBody extends StatefulWidget {
  const CustomNotesBody({super.key});

  @override
  State<CustomNotesBody> createState() => _CustomNotesBodyState();
}

class _CustomNotesBodyState extends State<CustomNotesBody> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  void _toggleSearch() {
    setState(() => _isSearching = !_isSearching);

    if (!_isSearching) {
      _searchController.clear();
      context.read<NotesCubit>().search('');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        _isSearching
            ? Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        hintText: 'Search notes...',
                        border: InputBorder.none,
                      ),
                      onChanged: (query) =>
                          context.read<NotesCubit>().search(query),
                    ),
                  ),
                  CustomIcon(
                    icon: Icons.close,
                    onPressed: _toggleSearch,
                  ),
                ],
              )
            : CustomAppBar(
                title: 'Notes',
                icon: Icons.search,
                onPressed: _toggleSearch,
              ),
        const Expanded(child: SizedBox(height: 100, child: NotesListView())),
      ],
    );
  }
}
