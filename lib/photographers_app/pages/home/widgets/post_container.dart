import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/photographers_app/clippers/tile_clipper.dart';
import 'package:flutter_projects/photographers_app/models/post.dart';
import 'package:flutter_projects/photographers_app/utils/photo_app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PostContainer extends StatefulWidget {
  final PhotoAppPost post;
  final bool isInverted;

  const PostContainer({
    Key key,
    @required this.post,
    @required this.isInverted,
  }) : super(key: key);

  @override
  _PostContainerState createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _scaleHeart;
  Animation<double> _downOpacity;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _scaleHeart = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(curve: Curves.decelerate, parent: _controller));
    _downOpacity = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        curve: Interval(
          0.5,
          1.0,
          curve: Curves.decelerate,
        ),
        parent: _controller));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Stack(
          children: [
            //==== IMAGE POST ===

            Positioned(
              top: 0,
              bottom: 40,
              right: 0,
              left: 0,
              child: GestureDetector(
                onDoubleTap: () {
                  _controller.forward();
                  setState(() {
                    widget.post.isLiked = true;
                  });
                },
                child: ClipPath(
                  clipper: TileClipper(inverted: widget.isInverted),
                  child: CachedNetworkImage(
                    imageUrl: widget.post.photoPost,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            //==== INFORMATION POST ===

            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Transform(
                    transform: Matrix4.identity()
                      ..rotateZ(pi * (widget.isInverted ? -.03 : 0.03))
                      ..setTranslationRaw(10, widget.isInverted ? -30 : -20, 0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          backgroundImage: CachedNetworkImageProvider(
                              widget.post.user.photoUrl),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.post.user.name.split(" ").first,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Transform(
                    transform: Matrix4.identity()
                      ..rotateZ(pi * (widget.isInverted ? .02 : -0.035))
                      ..setTranslationRaw(0, widget.isInverted ? -45 : -10, 0),
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.solidCommentDots, size: 18),
                        const SizedBox(width: 3),
                        Text(
                          widget.post.comments.toString(),
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: PhotoAppColors.kDarkBlue,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Transform(
                    transform: Matrix4.identity()
                      ..rotateZ(pi * (widget.isInverted ? .035 : -0.06))
                      ..setTranslationRaw(0, widget.isInverted ? -40 : -20, 0),
                    child: Row(
                      children: [
                        Icon(
                            widget.post.isLiked
                                ? FontAwesomeIcons.heart
                                : FontAwesomeIcons.solidHeart,
                            size: 18,
                            color: widget.post.isLiked
                                ? PhotoAppColors.kDarkBlue
                                : Colors.redAccent[700]),
                        const SizedBox(width: 3),
                        Text(
                          widget.post.likes.toString(),
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: PhotoAppColors.kDarkBlue,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            //==== HEART ANIMATED POST ===

            AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return Center(
                    child: Transform.scale(
                      scale: 20 * _scaleHeart.value,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white.withOpacity(
                          1 *
                              (_scaleHeart.value.clamp(0.0, .5) *
                                  _downOpacity.value),
                        ),
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
