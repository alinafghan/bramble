import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:journal_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/utils/constants.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        context
            .read<AuthenticationBloc>()
            .add(AddProfilePicEvent(profileUrl: publicUrl));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const HugeIcon(
              color: AppTheme.text,
              icon: HugeIcons.strokeRoundedEdit01,
            ),
            onPressed: () {
              // Navigate to edit profile
              context.push('/home/edit_profile');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state is GetUserLoaded) {
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
                          color: AppTheme.palette2.withOpacity(0.4),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.palette2,
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
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.palette3,
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
                              color: AppTheme.palette3,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  state.myUser.username ?? 'Not Found',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.myUser.email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.myUser.mod == true ? 'Moderator' : 'User',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.text,
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
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            color: AppTheme.palette2,
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
                              color: AppTheme.text.withOpacity(0.5),
                            ),
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
                    color: AppTheme.palette3.withOpacity(0.2),
                    child: const Icon(
                      Icons.book,
                      color: AppTheme.palette3,
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
              color: AppTheme.text.withOpacity(0.6),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
