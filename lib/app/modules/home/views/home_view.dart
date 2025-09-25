import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motor_sport_easy/app/routes/app_pages.dart';
import '../../widgets/custom_appbar_title.dart';
import '../controllers/home_controller.dart';
import '../widgets/custom_racing_card_button.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 120 / 752,
        title: CustomAppbarTitle(),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchAllRaces();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: screenWidth * .556,
                      child: Text(
                        'Select racing series',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 24 / 360,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      child: InkWell(
                        onTap: () {
                          controller.showRequestDialog(context);
                        },
                        child: Container(
                          width: screenWidth*90/360,
                          padding: const EdgeInsets.all(4),
                          decoration: ShapeDecoration(
                            color: const Color(0x4CF93939),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 2,
                            children: [
                              Icon(Icons.add,size: screenWidth*23/360,),
                              Text(
                                'Request',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF3A3A3A),
                                  fontSize: screenWidth*12/360,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth*30/360,
                      child: InkWell(
                          onTap: () {
                            controller.signOut();
                          },
                          child: Icon(Icons.logout,size: screenWidth*23/360,)
                      ),

                    )
                  ],
                ),
              ),
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }else if(controller.allRacesList.isEmpty){
                return SliverToBoxAdapter(
                  child: Center(child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Text("You have no race"),
                  )),
                );
              }else {
                return SliverList.builder(
                  itemCount: controller.allRacesList.length,
                  itemBuilder: (context, index) {
                    final race = controller.allRacesList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 7,
                      ),
                      child: CustomRacingCardButton(
                        racingName: race.name,
                        sponsorLogo: race.imageLogo,
                        onTap: () {
                          final String raceName = race.name;
                          print("raceName: $raceName");
                          print("race id: ${race.id}");
                          Get.toNamed(
                            "${Routes.RACING_DETAILS}/${race.id}/${Uri.encodeComponent(race.name)}",
                          );
                        },
                      ),
                    );
                  },
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
