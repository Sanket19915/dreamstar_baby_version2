// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:dream_baby/features/notifications/widgets/lazy_loaded_scrollbar.dart';
import 'package:dream_baby/features/notifications/widgets/loading_indicator_widget.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../shared/helper/app_images.dart';
import '../../../viewmodels/notification_view_model.dart';
import '../../auth/model/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  //------------------------ variable ------------------------------//
  NotificationViewModel get notificationViewModel => Provider.of<NotificationViewModel>(context, listen: false);
  NotificationData? notification;
  final LoadingIndicatorNotifier _loadingStatusNotifier = LoadingIndicatorNotifier();

  bool isNotificationLoading = false;
  final ValueNotifier _valueNotifier = ValueNotifier(true);
  final ValueNotifier notificationReadNotifier = ValueNotifier(true);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  getAllNotification();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            context.pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.blackColor,
            size: 20,
          ),
        ),
        actions: [
          ValueListenableBuilder(
              valueListenable: _valueNotifier,
              builder: (context, value, child) {
                return Visibility(
                  visible: notification?.data?.data?.isNotEmpty ?? false,
                  child: GestureDetector(
                    onTap: () => markAsAllread(),
                    child: Row(
                      children: [
                        Text(
                          "Mark as all Read",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(width: 5),
                        ValueListenableBuilder(
                            valueListenable: notificationReadNotifier,
                            builder: (context, value, child) {
                              return isNotificationLoading
                                  ? const Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: SizedBox(
                                        height: 10,
                                        width: 10,
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : Container();
                            })
                      ],
                    ),
                  ),
                );
              }),
        ],
        centerTitle: true,
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            color: AppColors.mainColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: LoadingIndicator(
        loadingStatusNotifier: _loadingStatusNotifier,
        child: ValueListenableBuilder(
            valueListenable: _valueNotifier,
            builder: (context, value, child) {
              return SafeArea(
                child: (notification?.data?.data?.isNotEmpty ?? false)
                    ? LazyLoadScrollView(
                        onEndOfPage: () async {
                          if (notification != null && notification?.data?.total != notification?.data?.data?.length) {
                            notificationViewModel.currentPage++;
                            notification = await notificationViewModel.getAllNotification();
                            _valueNotifier.notifyListeners();
                          } else {
                            return;
                          }
                        },
                        child: RefreshIndicator(
                            backgroundColor: Colors.white,
                            onRefresh: () async {
                              notification = await notificationViewModel.getAllNotification();
                              _valueNotifier.notifyListeners();
                            },
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: (notification?.data?.data?.length ?? 0),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              itemBuilder: (context, index) {
                                return Slidable(
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        // An action can be bigger than the others.
                                        flex: 1,
                                        onPressed: (context) async => await singleMakeAsReadAction(
                                            notificationId: notification?.data?.data?[index].id ?? 0),
                                        backgroundColor: AppColors.mainColor,
                                        foregroundColor: Colors.white,

                                        icon: (notification?.data?.data?[index].isRead ?? false)
                                            ? Icons.notifications_none_outlined
                                            : Icons.notification_add_sharp,
                                        label: 'Mark as read',
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child: (notification?.data?.data?[index].isRead ?? false)
                                                ? const Icon(
                                                    Icons.notifications_none_outlined,
                                                    color: Colors.grey,
                                                  )
                                                : Image.asset(
                                                    AppImages.bell,
                                                    height: 24,
                                                  ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            notification?.data?.data?[index].title ?? "",
                                                            // formatType(notifications: notification),
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .labelMedium
                                                                ?.copyWith(fontWeight: FontWeight.bold),
                                                          ),
                                                          const SizedBox(height: 5),
                                                          Text(
                                                            notification?.data?.data?[index].body ?? "",
                                                            // formatDescription(notifications: notification),
                                                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                                  color: Colors.black87,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      DateFormat('hh:mm a').format(
                                                          notification?.data?.data?[index].createdAt ?? DateTime.now()),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall
                                                          ?.copyWith(fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                            )),
                      )
                    : Center(
                        child: Text(
                          "All notifications are upto date",
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
              );
            }),
      ),
    );
  }

  //------------------ function ----------------------//
  Future<void> getAllNotification() async {
    try {
      _loadingStatusNotifier.show();
      notification = await notificationViewModel.getAllNotification();
      _valueNotifier.notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      _loadingStatusNotifier.hide();
    }
  }

  Future<void> singleMakeAsReadAction({required int notificationId}) async {
    try {
      _valueNotifier.notifyListeners();

      await notificationViewModel.singleNotificationRead(notificationId: notificationId);
      notification = await notificationViewModel.getAllNotification();
      _valueNotifier.notifyListeners();
    } catch (e) {
      _valueNotifier.notifyListeners();
    } finally {
      _valueNotifier.notifyListeners();
    }
  }

  Future<void> markAsAllread() async {
    try {
      isNotificationLoading = true;
      notificationReadNotifier.notifyListeners();
      final data = await notificationViewModel.readAllnotification();
      notification = await notificationViewModel.getAllNotification();
      _valueNotifier.notifyListeners();
      Fluttertoast.showToast(msg: data?["message"] ?? "All notifications marked as read");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      isNotificationLoading = false;
      notificationReadNotifier.notifyListeners();
    } finally {
      isNotificationLoading = false;
      notificationReadNotifier.notifyListeners();
    }
  }
}
