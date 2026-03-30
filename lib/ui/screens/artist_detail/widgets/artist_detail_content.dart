import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/comment/comment.dart';
import '../../../../model/songs/song.dart';
import '../../../theme/theme.dart';
import '../../../utils/async_value.dart';
import '../view_model/artist_detail_view_model.dart';
import 'comment_tile.dart';

class ArtistDetailContent extends StatelessWidget {
  const ArtistDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ArtistDetailViewModel>();
    final artist = vm.artist;

    return Scaffold(
      appBar: AppBar(
        title: Text(artist.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Artist header
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(artist.imageUrl.toString()),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(artist.name, style: AppTextStyles.body),
                    Text(artist.genre, style: AppTextStyles.title),
                  ],
                ),
              ],
            ),

            SizedBox(height: 24),

            // Songs section
            Text("Songs", style: AppTextStyles.label),
            SizedBox(height: 8),
            _buildSongsSection(vm.songs),

            SizedBox(height: 24),

            // Comments section
            Text("Comments", style: AppTextStyles.label),
            SizedBox(height: 8),
            Expanded(child: _buildCommentsSection(vm.comments)),
          ],
        ),
      ),
      bottomNavigationBar: _CommentInput(
        onSubmit: (text) {
          vm.addComment(
            text,
            onError: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to post comment')),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSongsSection(AsyncValue<List<Song>> songsValue) {
    switch (songsValue.state) {
      case AsyncValueState.loading:
        return Center(child: CircularProgressIndicator());
      case AsyncValueState.error:
        return Text('Failed to load songs',
            style: TextStyle(color: Colors.red));
      case AsyncValueState.success:
        final songs = songsValue.data!;
        if (songs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('No songs yet', style: TextStyle(color: Colors.grey)),
          );
        }
        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage:
                          NetworkImage(song.imageUrl.toString()),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: 80,
                      child: Text(
                        song.title,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
    }
  }

  Widget _buildCommentsSection(AsyncValue<List<Comment>> commentsValue) {
    switch (commentsValue.state) {
      case AsyncValueState.loading:
        return Center(child: CircularProgressIndicator());
      case AsyncValueState.error:
        return Text('Failed to load comments',
            style: TextStyle(color: Colors.red));
      case AsyncValueState.success:
        final comments = commentsValue.data!;
        if (comments.isEmpty) {
          return Center(
            child: Text('No comments yet',
                style: TextStyle(color: Colors.grey)),
          );
        }
        return ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) => CommentTile(
            comment: comments[index],
          ),
        );
    }
  }
}

class _CommentInput extends StatefulWidget {
  const _CommentInput({required this.onSubmit});

  final void Function(String text) onSubmit;

  @override
  State<_CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<_CommentInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSubmit(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onSubmitted: (_) => _submit(),
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.send, color: Colors.blue),
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
