import 'package:bhumii/Models/Saved_model.dart';
import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/navigator.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:flutter/material.dart';

class PropertyComparison extends StatefulWidget {
  final UserModel user;

  PropertyComparison({required this.user});

  @override
  State<PropertyComparison> createState() => _PropertyComparisonState();
}

class _PropertyComparisonState extends State<PropertyComparison> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Compare Properties",
                style: TextStyle(
                    fontFamily: 'Maven Pro',
                    fontSize: 6.w,
                    fontWeight: FontWeight.w600),
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    navigateBack(context);
                  },
                  icon: Icon(
                    Icons.close,
                    size: 30,
                  ))
            ],
          ),
          SizedBox(
            height: 4.h,
          ),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (widget.user.savedProperties.isEmpty) {
      return Center(
        child: Text(
          "No saved properties",
          style: TextStyle(
            fontSize: 5.w,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor,
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          columnWidths: {
            0: IntrinsicColumnWidth(),
            for (int i = 1; i <= widget.user.savedProperties.length; i++)
              i: IntrinsicColumnWidth(),
          },
          children: _buildRows(),
        ),
      );
    }
  }

  List<TableRow> _buildRows() {
    List<TableRow> rows = [
      TableRow(
        children: [
          TableCell(child: _buildHeader('')),
          ...widget.user.savedProperties
              .map((prop) => TableCell(
                  child: _buildHeader(prop.userDetails.companyLogoUrl ?? '')))
              .toList(),
        ],
      ),
    ];
    rows.add(
        _buildDataRow('', (prop) => prop.userDetails.companyName ?? 'N/A', 8));
    rows.add(_buildDataRow(
        'Property\n', (prop) => prop.userDetails.companyName ?? 'N/A', 0));
    rows.add(_buildDataRow('Min \nInvestment',
        (prop) => prop.adminInputs.fundedValue?.toString() ?? 'N/A', 1));
    rows.add(_buildDataRow(
        'IRR\n', (prop) => prop.adminInputs.targetIrr?.toString() ?? 'N/A', 2));
    rows.add(_buildDataRow(
        'Yield\n', (prop) => prop.adminInputs.yield?.toString() ?? 'N/A', 3));
    rows.add(_buildDataRow('Company \nRating', (prop) {
      final reviews = prop.adminInputs.propertyReviews;
      return reviews != null && reviews.isNotEmpty
          ? '${reviews[0].rating ?? 'N/A'} ★'
          : 'N/A';
    }, 4));
    rows.add(_buildDataRow('No. of Listed \nProperties',
        (prop) => '${widget.user.noOfListings ?? 0}', 5));
    rows.add(_buildDataRow('Funding Status\n', (prop) {
      final fundedValue = prop.adminInputs.fundedValue;
      final assetValue = prop.adminInputs.assetValue;
      return fundedValue != null && assetValue != null
          ? '${((assetValue / fundedValue) * 100).toStringAsFixed(2)}%'
          : 'N/A';
    }, 6));

    return rows;
  }

  TableRow _buildDataRow(
      String label, String Function(SavedProperty) getValue, int index) {
    return TableRow(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: index % 2 == 1
              ? Color.fromARGB(255, 229, 231, 231)
              : Colors.transparent,
        ),
        color: index % 2 == 1
            ? Color.fromARGB(255, 235, 244, 244)
            : Colors.transparent,
      ),
      children: [
        TableCell(child: _buildCell(label, isHeader: true)),
        ...widget.user.savedProperties.map((prop) {
          if (index == 8) {
            // Show company logo as an image
            return TableCell(child: _buildCell2(getValue(prop)));
          } else {
            // Show other data cells
            return TableCell(
              child: _buildCell(getValue(prop)),
            );
          }
        }).toList(),
      ],
    );
  }

  Widget _buildLogo(String logoUrl) {
    return Container(
      child: logoUrl.isNotEmpty
          ? Image.network(
              logoUrl,
              width: 30, // Adjust size as needed
              height: 30, // Adjust size as needed
              fit: BoxFit.contain,
            )
          : SizedBox(), // Placeholder if no logo URL available
    );
  }

  Widget _buildHeader(String text) {
    return Container(
      child: _buildLogo(text),
    );
  }

  Widget _buildCell(String text, {bool isHeader = false}) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.w500 : FontWeight.w500,
          fontSize: isHeader ? 4.w : 3.5.w,
          color: isHeader
              ? const Color.fromRGBO(116, 116, 116, 1)
              : AppColors.primaryColor,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildCell2(String text, {bool isHeader = false}) {
    return Container(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.w500 : FontWeight.w500,
            fontSize: isHeader ? 4.w : 3.w,
            color: isHeader
                ? const Color.fromRGBO(116, 116, 116, 1)
                : AppColors.blackColor,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
