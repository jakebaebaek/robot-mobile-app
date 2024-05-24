import 'package:flutter/material.dart';

class PointsTableWidget extends StatefulWidget {
  PointsTableWidget({Key? key}) : super(key: key);

  @override
  _PointsTableWidgetState createState() => _PointsTableWidgetState();
}

class _PointsTableWidgetState extends State<PointsTableWidget> {
  List<String> points = List.generate(4, (index) => 'POINT_$index')..add('+');
  int? selectedRowIndex;

  void addPoint() {
    setState(() {
      int newIndex = points.length - 1;  // '+'를 제외한 새 인덱스
      points.insert(newIndex, 'POINT_$newIndex');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(  // 스크롤 가능하게 만들기
        scrollDirection: Axis.vertical,  // 세로 방향 스크롤
        child: Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(),  // 열 너비를 유연하게 조절
          },
          border: TableBorder.all(color: Colors.black),  // 모든 셀에 테두리 추가
          children: List<TableRow>.generate(
            points.length,
                (index) {
              return TableRow(
                decoration: BoxDecoration(
                  color: selectedRowIndex == index ? Colors.purple[50] : Colors.transparent,  // 선택된 행의 색상 변경
                ),
                children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,  // 세로 중앙 정렬
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (points[index] == '+') {
                            addPoint();
                          } else {
                            selectedRowIndex = index;  // 선택된 행 인덱스 갱신
                          }
                        });
                      },
                      child: Container(
                        height: 50,  // 셀 높이 지정
                        alignment: Alignment.center,  // 텍스트 중앙 정렬
                        child: Text(points[index], style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: PointsTableWidget()));
}
