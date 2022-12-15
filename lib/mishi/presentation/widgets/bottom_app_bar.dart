import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mishi/mishi/presentation/manager/controllers/bottom_app_bar_controller.dart';
import 'package:mishi/mishi/presentation/utils/app_colors.dart';
import 'package:mishi/mishi/presentation/utils/enums.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomAppBarController());
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CustomAppBarButton(
              isSelected:
                  BottomAppItems.home == controller.selectedBottom.value,
              icon: "assets/svg/home.svg",
              title: "HOME",
              onTap: () {
                controller.changeBottomItem(BottomAppItems.home);
              },
            ),
          ),
          Expanded(
            child: CustomAppBarButton(
              isSelected:
                  BottomAppItems.search == controller.selectedBottom.value,
              icon: "assets/svg/search.svg",
              title: "SEARCH",
              onTap: () {
                controller.changeBottomItem(BottomAppItems.search);
              },
            ),
          ),
          Expanded(
            child: CustomAppBarButton(
              isSelected:
                  BottomAppItems.downloads == controller.selectedBottom.value,
              icon: "assets/svg/download.svg",
              title: "DOWNLOADS",
              onTap: () {
                controller.changeBottomItem(BottomAppItems.downloads);
              },
            ),
          ),
          Expanded(
            child: CustomAppBarButton(
              isSelected:
                  BottomAppItems.premium == controller.selectedBottom.value,
              icon: "assets/svg/diamond.svg",
              title: "PREMIUM",
              onTap: () {
                controller.changeBottomItem(BottomAppItems.premium);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBottomAppBarWeb extends StatelessWidget {
  const CustomBottomAppBarWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomAppBarController());
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          CustomAppBarButtonWeb(
            isSelected: BottomAppItems.home == controller.selectedBottom.value,
            icon: "assets/svg/home.svg",
            title: "HOME",
            onTap: () {
              controller.changeBottomItem(BottomAppItems.home);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          CustomAppBarButtonWeb(
            isSelected:
                BottomAppItems.search == controller.selectedBottom.value,
            icon: "assets/svg/search.svg",
            title: "SEARCH",
            onTap: () {
              controller.changeBottomItem(BottomAppItems.search);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          // CustomAppBarButtonWeb(
          //   isSelected:
          //       BottomAppItems.downloads == controller.selectedBottom.value,
          //   icon: "assets/svg/download.svg",
          //   title: "DOWNLOADS",
          //   onTap: () {
          //     controller.changeBottomItem(BottomAppItems.downloads);
          //   },
          // ),

          CustomAppBarButtonWeb(
            isSelected:
                BottomAppItems.premium == controller.selectedBottom.value,
            icon: "assets/svg/diamond.svg",
            title: "PREMIUM",
            onTap: () {
              controller.changeBottomItem(BottomAppItems.premium);
            },
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class CustomAppBarButton extends StatelessWidget {
  final bool isSelected;
  final String icon;
  final String title;
  final Function onTap;

  const CustomAppBarButton(
      {Key? key,
      required this.isSelected,
      required this.icon,
      required this.title,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, right: 0.0, left: 0.0),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: isSelected
              ? const BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25)))
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                width: 20,
                height: 20,
                color: isSelected ? Colors.white : Colors.white60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  title,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white60,
                      fontSize: 12),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBarButtonWeb extends StatelessWidget {
  final bool isSelected;
  final String icon;
  final String title;
  final Function onTap;

  const CustomAppBarButtonWeb(
      {Key? key,
      required this.isSelected,
      required this.icon,
      required this.title,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, right: 8.0, left: 8.0),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          height: 50,
          decoration: isSelected
              ? const BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(25)))
              : null,
          child: Center(
            child: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SvgPicture.asset(
                    icon,
                    width: 20,
                    height: 20,
                    color: isSelected ? Colors.white : Colors.white60,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      title,
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white60,
                          fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
