import 'package:flutter/material.dart';

class StarsPainter extends CustomPainter {
  static const double designWidth = 76;
  static const double designHeight = 11.5;
  static const double designSpacing = 4;
  static const double whProportion = designWidth / designHeight;

  // Upper half star X offsets
  static const double secondPointXOffset = 4.55;
  static const double thirdPointXOffset = 1.45;
  static const double forthPointXOffset = 1.45;
  static const double fifthPointXOffset = 4.55;

  // Upper half star Y offsets
  static const double secondPointYOffset = 0;
  static const double thirdPointYOffset = -4.5;
  static const double forthPointYOffset = 4.5;
  static const double fifthPointYOffset = 0;

  // Bottom half star X offsets
  static const double sixthPointXOffset = 3.71;
  static const double seventhPointXOffset = -1.42;
  static const double eighthPointXOffset = 3.71;
  static const double ninthPointXOffset = 3.71;
  static const double tenthPointXOffset = -1.42;
  static const double eleventhPointXOffset = 3.71;

  // Bottom half star Y offsets
  static const double sixthPointYOffset = 2.64;
  static const double seventhPointYOffset = 4.36;
  static const double eighthPointYOffset = -2.7;
  static const double ninthPointYOffset = 2.7;
  static const double tenthPointYOffset = -4.36;
  static const double eleventhPointYOffset = -2.64;

  static const List<double> upperHalfXOffsets = [
    secondPointXOffset,
    thirdPointXOffset,
    forthPointXOffset,
    fifthPointXOffset
  ];

  static const List<double> upperHalfYOffsets = [
    secondPointYOffset,
    thirdPointYOffset,
    forthPointYOffset,
    fifthPointYOffset
  ];

  static const List<double> bottomHalfXOffsets = [
    sixthPointXOffset,
    seventhPointXOffset,
    eighthPointXOffset,
    ninthPointXOffset,
    tenthPointXOffset,
    eleventhPointXOffset
  ];

  static const List<double> bottomHalfYOffsets = [
    sixthPointYOffset,
    seventhPointYOffset,
    eighthPointYOffset,
    ninthPointYOffset,
    tenthPointYOffset,
    eleventhPointYOffset
  ];

  double logicWidth;
  double logicHeight;
  double fullWidth;
  double targetPercent;
  double targetWidth;
  double currentPercent;
  double currentMaxWidth;
  Color color;

  StarsPainter({@required this.targetPercent, @required this.currentPercent, this.color: Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 && size.height != 0) {
      logicHeight = size.height;
      logicWidth = size.height * whProportion;
    } else if (size.width != 0 && size.height == 0) {
      logicWidth = size.width;
      logicHeight = size.width / whProportion;
    } else {
      logicHeight = size.height;
      logicWidth = size.width;
    }
    fullWidth = logicWidth;
    targetWidth = fullWidth / 100.0 * targetPercent;
    currentMaxWidth = fullWidth / 100.0 * currentPercent;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeJoin = StrokeJoin.bevel
      ..strokeWidth = 1.0
      ..color = color;

    double startX = logicWidth / 2 - targetWidth / 2;
    double startY = logicHeight / 2;

    double maxXOffset = startX + currentMaxWidth;

    double currentX = startX;
    double currentY = startY;

    for (int i = 0; i < 5; i++) {
      if (currentX >= maxXOffset) break;
      Offset resultingOffset = _addSpaceForNextStar(canvas, _drawStar(canvas, paint, currentX, currentY, maxXOffset));
      currentX = resultingOffset.dx;
      currentY = resultingOffset.dy;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  Offset _drawStar(Canvas canvas, Paint paint, double x, double y, double maxXOffset) {
    double firstPointX = x;
    double firstPointY = y;

    double lastUpperPointX;
    double lastUpperPointY;
    var path = Path()..fillType = PathFillType.evenOdd;

    // Upper half star points
    path.moveTo(x, y);
    int upperPointIndex = 0;
    while (upperPointIndex < 4 && x + getAxisX(upperHalfXOffsets[upperPointIndex]) <= maxXOffset) {
      x += getAxisX(upperHalfXOffsets[upperPointIndex]);
      y += getAxisY(upperHalfYOffsets[upperPointIndex]);
      path.lineTo(x, y);
      upperPointIndex++;
    }
    if (upperPointIndex < 4) {
      double xDiff = maxXOffset - x;
      x = maxXOffset;
      double tang = getAxisY(upperHalfYOffsets[upperPointIndex]) / getAxisX(upperHalfXOffsets[upperPointIndex]);
      y += (tang == 0) ? 0 : tang * xDiff;
      path.lineTo(x, y);
    }
    lastUpperPointX = x;
    lastUpperPointY = y;

    //Bottom half star points
    x = firstPointX;
    y = firstPointY;
    path.moveTo(x, y);
    int bottomPointIndex = 0;
    while (bottomPointIndex < 6 && x + getAxisX(bottomHalfXOffsets[bottomPointIndex]) <= maxXOffset) {
      x += getAxisX(bottomHalfXOffsets[bottomPointIndex]);
      y += getAxisY(bottomHalfYOffsets[bottomPointIndex]);
      path.lineTo(x, y);
      bottomPointIndex++;
    }
    if (bottomPointIndex < 6) {
      double xDiff = maxXOffset - x;
      x = maxXOffset;
      double tang = getAxisY(bottomHalfYOffsets[bottomPointIndex]) / getAxisX(bottomHalfXOffsets[bottomPointIndex]);
      y += (tang == 0) ? 0 : tang * xDiff;
      path.lineTo(x, y);
    }
    path.lineTo(lastUpperPointX, lastUpperPointY);
    canvas.drawPath(path, paint);
    return Offset(x, y);
  }

  Offset _addSpaceForNextStar(Canvas canvas, Offset offset) {
    var path = Path();
    double nextX = offset.dx + getAxisX(designSpacing);
    path.moveTo(nextX, offset.dy);
    canvas.drawPath(path, Paint());
    return Offset(nextX, offset.dy);
  }

  double getAxisX(double w) {
    return (w * logicWidth) / designWidth;
  }

  double getAxisY(double h) {
    return (h * logicHeight) / designHeight;
  }
}
