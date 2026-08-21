import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/models/cycle_models.dart';
import 'package:dream_baby/services/conception_cycle_service.dart';

class ConceptionCalendarScreen extends StatefulWidget {
  const ConceptionCalendarScreen({super.key});

  @override
  State<ConceptionCalendarScreen> createState() =>
      _ConceptionCalendarScreenState();
}

class _ConceptionCalendarScreenState extends State<ConceptionCalendarScreen> {
  bool _isLoading = true;
  CycleStatusModel? _status;
  String? _error;

  DateTime _currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await ConceptionCycleService.getCycleStatus();
    if (result.isSuccess) {
      setState(() {
        _status = result.data;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = result.errorMessage ?? 'Failed to load cycle data';
        _isLoading = false;
      });
    }
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.blackColor),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Cycle Calendar',
          style: GoogleFonts.poppins(
            color: AppColors.blackColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor));
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadStatus,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMonthSelector(),
          _buildDaysOfWeek(),
          _buildCalendarGrid(),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _previousMonth,
          ),
          Text(
            DateFormat('MMMM yyyy').format(_currentMonth),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextMonth,
          ),
        ],
      ),
    );
  }

  Widget _buildDaysOfWeek() {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) {
          return Expanded(
            child: Text(
              day,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryTextColor,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    // Determine the first day of the month and total days
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;

    // Determine the starting weekday (0 = Sunday, 1 = Monday, etc.)
    // DateTime.weekday returns 1 = Monday, 7 = Sunday. We want 0 = Sunday.
    final startWeekday = firstDayOfMonth.weekday % 7;

    // Total cells in the grid
    final totalCells = ((daysInMonth + startWeekday) / 7).ceil() * 7;

    final today = DateTime.now();

    final totalRows = ((daysInMonth + startWeekday) / 7).ceil();
    final gridHeight = totalRows * 62.0;

    return SizedBox(
      height: gridHeight,
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: totalCells,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        if (index < startWeekday || index >= startWeekday + daysInMonth) {
          return const SizedBox.shrink(); // Empty cell
        }

        final dayNumber = index - startWeekday + 1;
        final date = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
        
        final isToday = date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;

        final color = _status!.getDayColor(date);
        final hasColor = color != null;

        return Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: hasColor ? color : (isToday ? AppColors.primaryColor.withValues(alpha: 0.1) : Colors.transparent),
              border: isToday && !hasColor
                  ? Border.all(color: AppColors.primaryColor, width: 2)
                  : null,
            ),
            child: Center(
              child: Text(
                '$dayNumber',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: (isToday || hasColor) ? FontWeight.w700 : FontWeight.w400,
                  color: hasColor
                      ? Colors.white
                      : (isToday ? AppColors.primaryColor : AppColors.primaryTextColor),
                ),
              ),
            ),
          ),
        );
      },
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem(const Color(0xFFE53935), 'Period'),
              _buildLegendItem(const Color(0xFF42A5F5), 'Fertile'),
              _buildLegendItem(const Color(0xFF2FBF71), 'Ovulation'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem(const Color(0xFFCE93D8), 'Follicular'),
              _buildLegendItem(const Color(0xFFF48FB1), 'Luteal Phase'),
              _buildLegendItem(const Color(0xFFE67700), 'Expected Next'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.secondaryTextColor,
          ),
        ),
      ],
    );
  }
}
