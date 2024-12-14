// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class SortBottomSheet extends StatefulWidget {
  final Function(String) onSortSelected;
  final VoidCallback onClearSort;

  SortBottomSheet({
    Key? key,
    required this.onSortSelected,
    required this.onClearSort,
  }) : super(key: key);

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Row(
              children: [
                Text('Sort by', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    widget.onClearSort();
                    Navigator.pop(context);
                  },
                  child: Text('Clear Filter'),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          ListTile(
            leading: Icon(Icons.sort),
            title: Text('IRR (lowest to highest)'),
            onTap: () {
              widget.onSortSelected('IRR (lowest to highest)');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.sort),
            title: Text('IRR (Highest to Lowest)'),
            onTap: () {
              widget.onSortSelected('IRR (Highest to Lowest)');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.sort),
            title: Text('Asset Value (Highest to Lowest)'),
            onTap: () {
              widget.onSortSelected('Asset Value (Highest to Lowest)');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.sort),
            title: Text('Asset Value (lowest to highest)'),
            onTap: () {
              widget.onSortSelected('Asset Value (lowest to highest)');
              Navigator.pop(context);
            },
          ),
          // Add more sorting options here
        ],
      ),
    );
  }
}

class LocationBottomSheet extends StatefulWidget {
  final Function(String?) onLocationSelected;
  final String currentLocation;

  LocationBottomSheet({
    Key? key,
    required this.onLocationSelected,
    required this.currentLocation,
  }) : super(key: key);

  @override
  _LocationBottomSheetState createState() => _LocationBottomSheetState();
}

class _LocationBottomSheetState extends State<LocationBottomSheet> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
        text:
            widget.currentLocation != 'Location' ? widget.currentLocation : '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Filter by location',
                style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by location',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    widget.onLocationSelected(null);
                    Navigator.pop(context);
                  },
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  widget.onLocationSelected(value);
                }
              },
              onSubmitted: (value) {
                widget.onLocationSelected(value.isNotEmpty ? value : null);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BuilderBottomSheet extends StatefulWidget {
  final Function(String?) onBuilderSelected;
  final String currentBuilder;

  BuilderBottomSheet({
    Key? key,
    required this.onBuilderSelected,
    required this.currentBuilder,
  }) : super(key: key);

  @override
  _BuilderBottomSheetState createState() => _BuilderBottomSheetState();
}

class _BuilderBottomSheetState extends State<BuilderBottomSheet> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
        text: widget.currentBuilder != 'Builder' ? widget.currentBuilder : '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Filter by builder',
                style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by builder',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    widget.onBuilderSelected(null);
                    Navigator.pop(context);
                  },
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  widget.onBuilderSelected(value);
                }
              },
              onSubmitted: (value) {
                widget.onBuilderSelected(value.isNotEmpty ? value : null);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyBottomSheet extends StatelessWidget {
  final Function(String) onPropertySelected;

  PropertyBottomSheet({super.key, required this.onPropertySelected});

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('Filter by Property',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by Property',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            ListTile(
              title: Text('Property 1'),
              onTap: () {
                onPropertySelected('Property 1');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Property 2'),
              onTap: () {
                onPropertySelected('Property 2');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GreenGradientContainer extends StatelessWidget {
  String rating;

  GreenGradientContainer({
    Key? key,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 300, // Adjust width as needed
      // height: 100, // Adjust height as needed
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green, // Green color for the left side
            Color.fromARGB(255, 172, 214,
                124), // Light green gradient color for the right side
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(4), // Optional: for rounded corners
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 0.5),
          child: Row(
            children: [
              Text(
                rating,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(
                width: 0.3.h,
              ),
              Icon(
                Icons.star,
                size: 20,
                color: AppColors.whiteColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CostItem {
  final String name;
  final Color color;
  final int amount;

  CostItem(this.name, this.color, this.amount);
}

class CostItemWidget extends StatelessWidget {
  final String expenseType;
  final int cost;

  const CostItemWidget(
      {Key? key, required this.expenseType, required this.cost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Container(
          //   width: 8.w,
          //   height: 3.h,
          //   color: item.color,
          // ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              expenseType,
              style: TextStyle(
                  fontFamily: 'Maven Pro',
                  fontSize: 4.w,
                  color: AppColors.lightTextColor,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Text(
            '₹ ${(cost)} ',
            style: TextStyle(fontSize: 5.w, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class DownloadCard extends StatelessWidget {
  final String title;
  final String fileType;
  final VoidCallback onTap;

  const DownloadCard({
    Key? key,
    required this.title,
    required this.fileType,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 180,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.file_download_outlined,
              size: 30,
              color: Colors.grey,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Maven Pro',
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const CustomButton({
    Key? key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    this.borderColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 45.w,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Maven Pro',
              color: textColor,
              fontSize: 4.w,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class RatingWidget extends StatelessWidget {
  final int rating;
  final int totalStars;

  RatingWidget({
    required this.rating,
    required this.totalStars,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalStars, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: index < rating ? Colors.green : Colors.grey,
        );
      }),
    );
  }
}

// class BookmarkIcon extends StatefulWidget {
//   final Property property;
//   final VoidCallback onBookmarkChanged;

//   BookmarkIcon({required this.property, required this.onBookmarkChanged});

//   @override
//   _BookmarkIconState createState() => _BookmarkIconState();
// }

// class _BookmarkIconState extends State<BookmarkIcon> {
//   void _toggleBookmark() {
//     setState(() {
//       widget.property.isBookmarked = !widget.property.isBookmarked;
//     });
//     widget.onBookmarkChanged();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: _toggleBookmark,
//       child: Icon(
//         widget.property.isBookmarked
//             ? Icons.bookmark
//             : Icons.bookmark_border_outlined,
//         color: widget.property.isBookmarked
//             ? Colors.green
//             : AppColors.lightTextColor,
//       ),
//     );
//   }
// }

class ShareIconWidget extends StatelessWidget {
  const ShareIconWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await _shareContent();
      },
      child: Icon(
        Icons.share_outlined,
        color: AppColors.lightTextColor,
      ),
    );
  }

  Future<void> _shareContent() async {
    await FlutterShare.share(
      title: 'Share Content',
      text: 'Check out this awesome content!',
      linkUrl: 'https://example.com', // Optional: Link to share
    );
  }
}
