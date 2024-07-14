import 'package:dream_baby/services/auth_services.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestimonialScreen extends StatefulWidget {
  @override
  _TestimonialScreenState createState() => _TestimonialScreenState();
}

class _TestimonialScreenState extends State<TestimonialScreen> {
  List<Map<String, dynamic>> testimonials = [];
  bool isLoading = true; // Add this flag

  @override
  void initState() {
    super.initState();
    fetchTestimonials();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Testimonials',
          style: TextStyle(
              fontWeight: FontWeight.w600, color: AppColors.mainColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.rate_review, color: Colors.black),
            onPressed: () {
              _showRatingDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (isLoading)
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: LinearProgressIndicator(),
            ), // Show the LinearProgressIndicator when loading
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 90),
              height: height,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/bg.png'), // Your background image
                  fit: BoxFit.cover,
                ),
              ),
              child: isLoading
                  ? Container(
                      height: height,
                      child: Center(
                        child: SpinKitCircle(
                          color: AppColors.primaryColor,
                          size: 50.0,
                        ),
                      ),
                    )
                  : testimonials.isEmpty
                      ? const Center(
                          child: Text(
                            'No Reviews yet',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 40.0),
                          itemCount: testimonials.length,
                          itemBuilder: (context, index) {
                            final testimonial = testimonials[index];
                            final double stars = testimonial['rating'] is double
                                ? testimonial['rating']
                                : double.tryParse(
                                        testimonial['rating'].toString()) ??
                                    0;
                            final String? userImage = testimonial['user_image'];

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 5,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: userImage != null &&
                                                  userImage.isNotEmpty
                                              ? NetworkImage(userImage)
                                                  as ImageProvider<
                                                      Object> // Explicit cast to ImageProvider<Object>
                                              : const AssetImage(
                                                  'assets/images/logon.webp'),
                                          radius: 30,
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              testimonial['user_name'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              children:
                                                  List.generate(5, (starIndex) {
                                                return Icon(
                                                  starIndex < stars
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: Colors.amber,
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      testimonial['review'] ?? '',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      testimonial['created_at'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  void fetchTestimonials() async {
    var token = await AuthService.getToken();
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse('http://dreambaby.pro/api/get_testimonials');

    try {
      http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        setState(() {
          testimonials = List<Map<String, dynamic>>.from(responseData['data']);
          isLoading = false; // Set isLoading to false after data is loaded
        });
      } else {
        print('Failed to fetch testimonials: ${response.statusCode}');
        setState(() {
          isLoading = false; // Set isLoading to false even if there is an error
        });
      }
    } catch (e) {
      print('Error fetching testimonials: $e');
      setState(() {
        isLoading = false; // Set isLoading to false even if there is an error
      });
    }
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        double rating = 0.0;
        final TextEditingController feedbackController =
            TextEditingController();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Submit Your Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  rating = value;
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: feedbackController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your feedback',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () async {
                await _submitReview(rating, feedbackController.text, context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitReview(
      double rating, String review, BuildContext context) async {
    var token = await AuthService.getToken();
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse('http://dreambaby.pro/api/testimonials');
    var body = json.encode({
      'rating': rating.toString(),
      'review': review,
    });

    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      print('Unexpected response body: $body');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted successfully')),
        );
        fetchTestimonials();
      } else {
        var responseBody = response.body;
        var errorMessage = 'Failed to submit review';

        try {
          var errorResponse = json.decode(responseBody);
          if (errorResponse['message'] != null) {
            errorMessage =
                'Failed to submit review: ${errorResponse['message']}';
          }
        } catch (e) {
          errorMessage = 'Unexpected response from server';
          print('Unexpected response body: $responseBody');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }

    Navigator.of(context).pop();
  }
}
