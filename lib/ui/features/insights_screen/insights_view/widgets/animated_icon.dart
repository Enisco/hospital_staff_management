import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:hospital_staff_management/app/services/snackbar_service.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';

class CustomAnimatedIcon extends StatefulWidget {
  final String posterUsername;
  const CustomAnimatedIcon({super.key, required this.posterUsername});

  @override
  State<CustomAnimatedIcon> createState() => CustomAnimatedIconState();
}

class CustomAnimatedIconState extends State<CustomAnimatedIcon> {
  double turns = 0.0;
  bool glowThumb = false;

  void _changeRotation() {
    setState(() {
      glowThumb = true;
      turns -= 1.0 / 16.0;
    });
    showCustomSnackBar(
      context,
      Text('You gave ${widget.posterUsername} a thumb up'),
      () {},
      AppColors.kPrimaryColor,
      500,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5),
            child: AnimatedRotation(
              turns: turns,
              duration: const Duration(milliseconds: 250),
              child: AvatarGlow(
                glowColor: glowThumb ? AppColors.kPrimaryColor : Colors.white,
                endRadius: 10.0,
                duration: const Duration(milliseconds: 2000),
                repeat: true,
                showTwoGlows: true,
                animate: true,
                repeatPauseDuration: const Duration(milliseconds: 100),
                child: InkWell(
                  onTap: _changeRotation,
                  child: Icon(
                    glowThumb
                        ? CupertinoIcons.hand_thumbsup_fill
                        : CupertinoIcons.hand_thumbsup,
                    size: 25,
                    color: AppColors.kPrimaryColor,
                  ),
                ),
              ),
              onEnd: () {
                setState(() {
                  glowThumb = false;
                  turns = 0;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
