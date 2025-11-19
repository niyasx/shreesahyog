// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  CustomTable({
    Key? key,
    required this.columns,
    required this.rows,
  }) : super(key: key);

  final List<DataColumn> columns;
  final List<DataRow> rows;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(const Color(0xffF6F6F6)),
            headingRowHeight: 48,
            horizontalMargin: 1,
            dataRowMinHeight: 35,
            dataRowMaxHeight: 35,
            columnSpacing: 0,
            border: TableBorder.all(
              color: const Color(0xff727272),
              width: 0.5,
            ),
            columns: columns,
            rows: rows,
          ),
        ),
      ),
    );
  }
}
