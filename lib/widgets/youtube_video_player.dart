import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final double? aspectRatio;
  final bool autoPlay;
  final bool showControls;

  const YouTubeVideoPlayer({
    super.key,
    required this.videoUrl,
    this.aspectRatio,
    this.autoPlay = false,
    this.showControls = true,
  });

  @override
  State<YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<YouTubeVideoPlayer> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    // Extract video ID from YouTube URL
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: widget.autoPlay,
          mute: false,
          enableCaption: true,
          captionLanguage: 'ar', // Arabic captions for Algeria content
          showLiveFullscreenButton: true,
          controlsVisibleAtStart: widget.showControls,
        ),
      );
      
      _controller.addListener(_onPlayerStateChange);
    }
  }

  void _onPlayerStateChange() {
    if (_controller.value.isReady && !_isPlayerReady) {
      setState(() {
        _isPlayerReady = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onPlayerStateChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    
    if (videoId == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              SizedBox(height: 8),
              Text('Invalid YouTube URL'),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Theme.of(context).colorScheme.primary,
            aspectRatio: widget.aspectRatio ?? 16 / 9,
            onReady: () {
              setState(() {
                _isPlayerReady = true;
              });
            },
            onEnded: (metaData) {
              // Handle video end if needed
            },
          ),
          builder: (context, player) {
            return Column(
              children: [
                player,
                // You can add additional controls or information here if needed
              ],
            );
          },
        ),
      ),
    );
  }
}

// Widget for displaying YouTube video thumbnail with play button overlay
class YouTubeVideoThumbnail extends StatelessWidget {
  final String videoUrl;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const YouTubeVideoThumbnail({
    super.key,
    required this.videoUrl,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    
    if (videoId == null) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Icon(Icons.error_outline, color: Colors.red),
        ),
      );
    }

    final thumbnailUrl = YoutubePlayer.getThumbnail(
      videoId: videoId,
      quality: ThumbnailQuality.high,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.error_outline, color: Colors.red),
                    ),
                  );
                },
              ),
              Container(
                color: Colors.black.withOpacity(0.3),
              ),
              Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
