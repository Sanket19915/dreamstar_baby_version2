import 'package:flutter/material.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

import 'loading_indicator_widget.dart';

// enum LoadingStatus { loading, stable }
typedef EndOfPageListenerCallback = Future<void> Function();

class LazyLoadScrollView extends StatefulWidget {
  final Widget child;
  final EndOfPageListenerCallback onEndOfPage;
  final int scrollOffset;
  final Axis scrollDirection;
  const LazyLoadScrollView({
    super.key,
    required this.child,
    required this.onEndOfPage,
    this.scrollDirection = Axis.vertical,
    this.scrollOffset = 100,
  });
  @override
  State<StatefulWidget> createState() => LazyLoadScrollViewState();
}

class LazyLoadScrollViewState extends State<LazyLoadScrollView> {
  LoadingStatus loadMoreStatus = LoadingStatus.hide;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          child: widget.child,
          onNotification: (notification) => _onNotification(notification, context),
        ),
        if (loadMoreStatus == LoadingStatus.show)
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: NutsActivityIndicator(),
          ),
      ],
    );
  }

  bool _onNotification(ScrollNotification notification, BuildContext context) {
    if (widget.scrollDirection == notification.metrics.axis) {
      if (notification is ScrollUpdateNotification) {
        if (notification.metrics.maxScrollExtent > notification.metrics.pixels &&
            notification.metrics.maxScrollExtent - notification.metrics.pixels <= widget.scrollOffset) {
          _loadMore();
        }
        return true;
      }
      if (notification is OverscrollNotification) {
        if (notification.overscroll > 0) {
          _loadMore();
        }
        return true;
      }
    }
    return false;
  }

  void _loadMore() async {
    if (loadMoreStatus == LoadingStatus.hide) {
      setState(() {
        loadMoreStatus = LoadingStatus.show;
      });
      try {
        await widget.onEndOfPage();
      } finally {
        if (mounted) {
          setState(() {
            loadMoreStatus = LoadingStatus.hide;
          });
        }
      }
    }
  }
}
