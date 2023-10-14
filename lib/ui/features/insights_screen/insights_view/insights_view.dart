import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/ui/features/custom_nav_bar/custom_navbar.dart';
import 'package:hospital_staff_management/ui/features/custom_nav_bar/page_index_class.dart';
import 'package:hospital_staff_management/ui/features/insights_screen/insights_controller/insights_controller.dart';
import 'package:hospital_staff_management/ui/features/insights_screen/insights_view/widgets/feeds_card.dart';
import 'package:hospital_staff_management/ui/shared/custom_appbar.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/screen_util/screen_util.dart';
import 'package:provider/provider.dart';

var log = getLogger('InsightsPageView');

class InsightsPageView extends StatefulWidget {
  const InsightsPageView({super.key});

  @override
  State<InsightsPageView> createState() => _InsightsPageViewState();
}

class _InsightsPageViewState extends State<InsightsPageView> {
  final _controller = Get.put(InsightsController());

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _controller.getFeeds();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalWillPopScope(
      onWillPop: () async {
        Provider.of<CurrentPage>(context, listen: false)
            .setCurrentPageIndex(0);
        context.pop();
        return false;
      },
      shouldAddCallback: true,
      child: GetBuilder<InsightsController>(
        init: InsightsController(),
        builder: (_) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(screenSize(context).width, 60),
              child: const CustomAppbar(
                title: "Insights",
              ),
            ),
            bottomNavigationBar: CustomNavBar(
              color: AppColors.plainWhite,
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue.shade700,
              child: Icon(
                Icons.post_add_rounded,
                color: AppColors.plainWhite,
              ),
              onPressed: () {
                log.w("Go to create Staff");
                context.push('/createInsightPageView');
              },
            ),
            body: GestureDetector(
              onTap: (() =>
                  SystemChannels.textInput.invokeMethod('TextInput.hide')),
              child: _controller.loading == true
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    )
                  : ListView.builder(
                      reverse: false,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _controller.feedData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FeedsCard(
                          feedData: _controller.feedData[index],
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}
