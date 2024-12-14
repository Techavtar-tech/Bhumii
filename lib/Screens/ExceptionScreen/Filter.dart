import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

class Filter extends StatelessWidget {
  final VoidCallback onClearFilters;

  const Filter({Key? key, required this.onClearFilters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/filter.svg'),
            SizedBox(height: 15),
            Text(
              "No data found for the applied filters.",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Maven Pro",
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 15),
            InkWell(
              onTap: onClearFilters,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(159, 176, 192, 1)),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                    child: Text(
                  "Clear All Filters",
                  style: TextStyle(
                      color: Color.fromRGBO(159, 176, 192, 1),
                      fontFamily: "Maven Pro",
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
