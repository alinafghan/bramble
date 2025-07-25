import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/blocs/journal_bloc/journal_bloc.dart';
import 'package:journal_app/models/journal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BottomNav extends StatefulWidget {
  final VoidCallback onSave;
  final Future<void> Function()? onImagePick;
  final Journal? journal;
  final TextEditingController textController;
  final bool allowImagePick;

  final ImagePicker? testImagePicker;
  final SupabaseClient? testSupabase;

  const BottomNav(
      {super.key,
      required this.onSave,
      this.journal,
      this.onImagePick,
      required this.textController,
      this.allowImagePick = true,
      this.testImagePicker,
      this.testSupabase});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  Future<void> _pickImage(Journal journal) async {
    final picker = widget.testImagePicker ?? ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    if (pickedImages.isNotEmpty) {
      final supabase = widget.testSupabase ?? Supabase.instance.client;
      final savedPaths = <String>[];

      for (var xf in pickedImages.take(4)) {
        final file = File(xf.path);
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${xf.name}';

        final storageResponse =
            await supabase.storage.from('images').upload(fileName, file);

        if (storageResponse.isNotEmpty) {
          final publicUrl =
              supabase.storage.from('images').getPublicUrl(fileName);
          savedPaths.add(publicUrl);
        }
      }

      if (mounted) {
        context.read<JournalBloc>().add(
              AddImage(journal: journal, image: savedPaths),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Colors.grey.withValues(),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              top: 2,
              right: 4,
              left: 4,
              bottom: MediaQuery.of(context).viewInsets.bottom * 1),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    DateTime timeStamp = DateTime.now();
                    String formattedTime = DateFormat.jm().format(timeStamp);

                    widget.textController.text += formattedTime;
                  },
                  icon: const Icon(
                    HugeIcons.strokeRoundedClock01,
                    size: 32,
                  ),
                ),
                if (widget.allowImagePick)
                  IconButton(
                    onPressed: () async {
                      _pickImage(widget.journal!);
                    },
                    icon: const Icon(
                      HugeIcons.strokeRoundedAlbum02,
                      size: 32,
                    ),
                  ),
              ],
            ),
            IconButton(
                onPressed: () {
                  widget.onSave();
                  context.pop();
                },
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedTick02,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 32,
                ))
          ]),
        ),
      ),
    );
  }
}
