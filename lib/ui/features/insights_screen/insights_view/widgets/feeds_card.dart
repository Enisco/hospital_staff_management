// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:hospital_staff_management/ui/features/insights_screen/insights_model/feed_model.dart';
import 'package:hospital_staff_management/ui/features/insights_screen/insights_view/widgets/animated_icon.dart';
import 'package:hospital_staff_management/ui/features/insights_screen/insights_view/widgets/carousel_index_widget.dart';
import 'package:hospital_staff_management/ui/shared/spacer.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/app_constants/app_styles.dart';
import 'package:hospital_staff_management/utils/screen_util/screen_util.dart';

class FeedsCard extends StatefulWidget {
  FeedsCard({super.key, required this.feedData});

  InsightsFeedModel? feedData;

  @override
  State<FeedsCard> createState() => _FeedsCardState();
}

class _FeedsCardState extends State<FeedsCard> with TickerProviderStateMixin {
  int activePage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 6,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 8,
      ),
      width: screenSize(context).width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(31),
        ),
        color: AppColors.plainWhite,
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                child: CircleAvatar(
                  backgroundColor: AppColors.blueGray,
                  radius: 21.5,
                  backgroundImage: CachedNetworkImageProvider(
                    '${widget.feedData?.userProfilePicsLink}',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                height: 43,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${widget.feedData?.fullName}',
                          style:
                              AppStyles.regularStringStyle(14, AppColors.black),
                        ),
                      ],
                    ),
                    CustomSpacer(4),
                    Row(
                      children: [
                        Text(
                          '${widget.feedData?.dateCreated}',
                          style: AppStyles.subStringStyle(
                            11,
                            AppColors.opaqueDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          CustomSpacer(12),
          SizedBox(
            width: screenSize(context).width,
            height: 300,
            child: CarouselSlider(
              options: CarouselOptions(
                height: 300.0,
                viewportFraction: 1.0,
                autoPlay: widget.feedData!.feedCoverPictureLink.length > 1
                    ? true
                    : false,
                enableInfiniteScroll:
                    widget.feedData!.feedCoverPictureLink.length > 1
                        ? true
                        : false,
                onPageChanged: (index, reason) {
                  setState(() {
                    activePage = index;
                  });
                },
              ),
              items: widget.feedData?.feedCoverPictureLink.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.blueGray,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            i,
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          CustomSpacer(3),
          widget.feedData!.feedCoverPictureLink.length > 1
              ? SizedBox(
                  width: 50,
                  height: 10,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.feedData?.feedCoverPictureLink.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 0,
                      ),
                      child: CarouselSliderWidget(
                        indexOn: activePage == index,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          CustomSpacer(5),
          Row(
            children: [
              CustomAnimatedIcon(
                posterUsername: widget.feedData!.fullName,
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomSpacer(8),
                  Text(
                    '${widget.feedData?.thumbsUp}',
                    style: AppStyles.regularStringStyle(12, AppColors.black),
                  ),
                ],
              ),
            ],
          ),
          CustomSpacer(5),
          ExpandablePanel(
            header: RichText(
              textScaleFactor: 1,
              text: TextSpan(
                text: '${widget.feedData?.feedName}  ',
                style: AppStyles.regularStringStyle(15, AppColors.black),
              ),
            ),
            collapsed: Text(
              '${widget.feedData?.feedDescription}',
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            expanded: Text(
              '${widget.feedData?.feedDescription}',
              softWrap: true,
            ),
            theme: ExpandableThemeData(
              iconPadding: const EdgeInsets.only(top: 0),
              iconColor: AppColors.kPrimaryColor,
              tapBodyToCollapse: true,
              tapBodyToExpand: true,
              tapHeaderToExpand: true,
              iconSize: 35,
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              iconPlacement: ExpandablePanelIconPlacement.right,
            ),
          ),
          CustomSpacer(10),
        ],
      ),
    );
  }
}
