import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:journal_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:journal_app/models/book.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  final bool readOnly;

  const ProfileScreen({super.key, required this.readOnly});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    context.read<AuthenticationBloc>().add(GetUserEvent());
    super.initState();
  }

  Future<void> _updateProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final file = File(pickedImage.path);
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${pickedImage.name}';

      final supabase = Supabase.instance.client;
      final response =
          await supabase.storage.from('images').upload(fileName, file);

      if (response.isNotEmpty) {
        final publicUrl =
            supabase.storage.from('images').getPublicUrl(fileName);

        // Dispatch update user event
        if (mounted) {
          context
              .read<AuthenticationBloc>()
              .add(AddProfilePicEvent(profileUrl: publicUrl));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.readOnly ? 'Profile' : 'Edit Profile',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: HugeIcon(
              color: Theme.of(context).colorScheme.onSurface,
              icon: widget.readOnly
                  ? HugeIcons.strokeRoundedEdit01
                  : HugeIcons.strokeRoundedTick02,
            ),
            onPressed: () {
              if (widget.readOnly) {
                context.go('/home/settings/edit_profile');
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    title: const Text("Save Changes?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthenticationBloc>().add(
                              ChangeUsernameEvent(
                                  newUsername: usernameController.text));
                          context.pop();
                          context.go('/home/settings/profile');
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state is GetUserLoaded) {
            if (usernameController.text.isEmpty &&
                state.myUser.username != null) {
              usernameController.text += state.myUser.username ?? '';
            }
            return Column(
              children: [
                const SizedBox(height: 24),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withAlpha((0.4 * 255).toInt()),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2,
                          ),
                        ),
                        child: state.myUser.profileUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.network(
                                  state.myUser.profileUrl!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Text(
                                  state.myUser.username?[0].toUpperCase() ??
                                      'U',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _updateProfileImage,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.surface,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Theme.of(context).colorScheme.surface,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: widget.readOnly
                            ? InputBorder.none
                            : const UnderlineInputBorder(),
                      ),
                      controller: usernameController,
                      readOnly: widget.readOnly,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HugeIcon(
                        icon: HugeIcons.strokeRoundedMail01,
                        color: Theme.of(context).colorScheme.onSurface),
                    const SizedBox(width: 4),
                    Text(
                      state.myUser.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  state.myUser.mod == true ? 'Moderator' : 'User',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Saved Books',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go('/booklist');
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Book List
                SizedBox(
                  height: 180,
                  child: state.myUser.savedBooks != null &&
                          state.myUser.savedBooks!.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.myUser.savedBooks!.length,
                          itemBuilder: (context, index) {
                            final book = state.myUser.savedBooks![index];
                            return _buildBookItem(context, book);
                          },
                        )
                      : Center(
                          child: Text(
                            'No saved books yet',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withAlpha(128)),
                          ),
                        ),
                ),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
      ),
    );
  }

  Widget _buildBookItem(BuildContext context, Book book) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: book.coverUrl != null
                ? Image.network(
                    book.coverUrl!,
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 120,
                    width: 120,
                    color: Theme.of(context).colorScheme.primary.withAlpha(51),
                    child: Icon(
                      Icons.book,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            book.title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            book.author,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
