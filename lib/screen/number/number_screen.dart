import 'package:babyspark/widgets/secondary_app_bar.dart';
import 'package:flutter/material.dart';
import '../../widgets/my_text_button.dart';
import '../../widgets/number_tile.dart';
import 'number_detail_screen.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final List<Color> _numberColors = [
    Colors.redAccent,
    Colors.indigo,
    Colors.blue,
    Colors.orange
  ];

  final List<int> _displayedNumbers = List.generate(20, (index) => index + 1);
  bool _isLoadingMore = false;

  void _loadMoreNumbers() {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        final lastNumber = _displayedNumbers.last;
        _displayedNumbers
            .addAll(List.generate(20, (index) => lastNumber + index + 1));
        _isLoadingMore = false;
      });
    });
  }

  void _navigateToNumberDetail(BuildContext context, int number) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NumberDetailScreen(
          initialNumber: number - 1,
          maxNumber: _displayedNumbers.last,
        ),
      ),
    );
  }

  /// Tablet
  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: size.height * 0.2,
          flexibleSpace: const SecondaryAppBar(title: "Number"),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              /// Grid item
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemCount: _displayedNumbers.length,
                itemBuilder: (context, index) {
                  return NumberTile(
                    number: _displayedNumbers[index],
                    color: _numberColors[index % _numberColors.length],
                    isTablet: isTablet(context),
                    onTap: () {
                      _navigateToNumberDetail(
                          context, _displayedNumbers[index]);
                    },
                  );
                },
              ),
              _isLoadingMore
                  ? const CircularProgressIndicator()
                  : Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: MyTextButton(
                            btnText: "Learn More Number",
                            onPress: _loadMoreNumbers),
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
