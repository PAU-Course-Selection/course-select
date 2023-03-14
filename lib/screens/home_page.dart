import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_select/controllers/home_page_notifier.dart';
import 'package:course_select/controllers/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import '../controllers/course_notifier.dart';
import '../routes/routes.dart';
import '../shared_widgets/constants.dart';
import '../shared_widgets/course_card.dart';
import '../shared_widgets/courses_filter.dart';
import '../utils/firebase_data_management.dart';
import 'app_main_navigation.dart';
import 'my_courses_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ValueNotifier<double> valueNotifier;
  late final CourseNotifier courseNotifier;
  late final UserNotifier userNotifier;
  late Future futureData;

  final DatabaseManager _db = DatabaseManager();

  @override
  void initState() {
    courseNotifier = Provider.of<CourseNotifier>(context, listen: false);
    userNotifier = Provider.of<UserNotifier>(context, listen: false);
    futureData = getModels();
    valueNotifier = ValueNotifier(0.0);
    _db.getUsers(userNotifier);
    super.initState();
  }


  Future getModels() async{
    await _db.getUsers(userNotifier);
    userNotifier.updateUserName();
    userNotifier.updateAvatar();
    return _db.getCourses(courseNotifier);
  }


  @override
  Widget build(BuildContext context) {
    //final Size _size = MediaQuery.of(context).size;
    valueNotifier.value = 80.0;
    HomePageNotifier homePageNotifier = Provider.of<HomePageNotifier>(context, listen: true);

    return Scaffold(
      body: FutureBuilder(
          future: futureData,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            double screenWidth = MediaQuery.of(context).size.width;
            /// The snapshot data type have to be same of the result of your web service method
            if (snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.waiting) {
              /// When the result of the future call respond and has data show that data
              return Column(
                children: [
                  SafeArea(
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 100.h,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Hello,',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontFamily: 'Roboto'),
                                        ),
                                        Text(userNotifier.userName,
                                            style:
                                            kHeadlineMedium.copyWith(fontSize: 30)),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.pushNamed(context, PageRoutes.userProfile),
                                      child:  CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.white,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(45),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              imageUrl: userNotifier.avatar??'',
                                              placeholder: (context, url){
                                                return  CircularProgressIndicator(strokeWidth: 2, color: kPrimaryColour,);
                                              },
                                              errorWidget: (context, url, error) => const Icon(Icons.person, color: Colors.grey,),
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),//Name and Avatar
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap:(){
                                      showCupertinoModalBottomSheet(
                                        duration: const Duration(milliseconds: 100),
                                        topRadius: const Radius.circular(20) ,
                                        barrierColor: Colors.black54,
                                        elevation: 8,
                                        context: context,
                                        builder: (context) => const Material(child: MyCourses()),
                                      );
                                    },
                                    child: RaisedContainer(child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Search',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                                fontFamily: 'Roboto')),
                                        Icon(
                                          Icons.search,
                                          color: const Color(0xff0DAB76).withOpacity(0.7),
                                        )
                                      ],
                                    ), width: screenWidth * 0.73, bgColour: Colors.white,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: FilterButton(
                                        isFilterVisible: homePageNotifier.isFilterVisible,
                                      onPressed: (){
                                          homePageNotifier.isFilterVisible =!homePageNotifier.isFilterVisible;
                                      },
                                    ),
                                  )],
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () {
                        setState(() {
                          futureData = getModels();

                        });
                        return futureData;
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                                visible: homePageNotifier.isFilterVisible,
                                child: const CoursesFilter()), //Course Filters
                            const CategoryTitle(text: 'Currently Active'),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color:  kLightBackground.withOpacity(0.2),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                          image: const DecorationImage(image: AssetImage('assets/images/html.jpg'))),
                                      height: 70,
                                      width: 70,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text('Symmetry Theory', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text('2 lessons left', style: TextStyle(color: Colors.grey),)
                                      ],
                                    ),
                                    SimpleCircularProgressBar(
                                      animationDuration: 1,
                                      backColor: const Color(0xffD9D9D9),
                                      progressColors: [kSelected,kPrimaryColour],
                                      progressStrokeWidth: 8,
                                      backStrokeWidth: 8,
                                      size: 50,
                                      valueNotifier: valueNotifier,
                                      mergeMode: true,
                                      onGetText: (double value) {
                                        return Text('${value.toInt()}%');
                                      },
                                    ),
                                  ],
                                ),
                                width: double.infinity,),
                            ),//Courses Title
                            const CategoryTitle(text: 'Top Picks'), //Courses Title
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: SizedBox(
                                height: 300,
                                width: double.infinity,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: courseNotifier.courseList.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: CourseCard(
                                          courseTitle: courseNotifier
                                              .courseList[index].courseName,
                                          courseImage: 'assets/images/course_image.png',
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Oops...something happened',
                  style: TextStyle(color: Colors.black),
                ),
              );
            }
            // else if(snapshot.connectionState == ConnectionState.waiting){
            //   ///should be shimmer instead
            //   return const Center(child: Text('Shimmer for show'),);
            // }else{
            //   const Center(child: Text('waiting...'));
            // }

            /// While there is no data or error show some shimmer
            return const Center(child: Text('No data'));
          }),
    );
  }
}

class FilterButton extends StatefulWidget {
  final Function onPressed;
  const FilterButton({
    Key? key,
    required bool isFilterVisible, required this.onPressed,
  }) : _isFilterVisible = isFilterVisible, super(key: key);

  final bool _isFilterVisible;

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onPressed.call(),
      child: RaisedContainer(width: 50, bgColour: widget._isFilterVisible?kPrimaryColour:Colors.white,
        child: ImageIcon(const AssetImage('assets/icons/setting.png'), color: widget._isFilterVisible? Colors.white: kPrimaryColour),

      ),
    );
  }
}
