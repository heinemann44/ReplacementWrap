import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class _RunMetrics {
  _RunMetrics(this.mainAxisExtent, this.crossAxisExtent, this.children,
      this.haveOverflowWidget);

  final double mainAxisExtent;
  final double crossAxisExtent;

  final List<RenderBox> children;
  final bool haveOverflowWidget;
}

class WrapParentData extends ContainerBoxParentData<RenderBox> {}

class RenderReplacementWrap extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, WrapParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, WrapParentData> {

  RenderReplacementWrap({
    List<RenderBox> children,
    Axis direction = Axis.horizontal,
    double spacing = 0.0,
    WrapAlignment runAlignment = WrapAlignment.start,
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.start,
    TextDirection textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
  })  : assert(direction != null),
        assert(spacing != null),
        assert(runAlignment != null),
        assert(crossAxisAlignment != null),
        _direction = direction,
        _spacing = spacing,
        _runAlignment = runAlignment,
        _crossAxisAlignment = crossAxisAlignment,
        _textDirection = textDirection,
        _verticalDirection = verticalDirection;

  Axis get direction => _direction;
  Axis _direction;

  set direction(Axis value) {
    assert(value != null);
    if (_direction == value) return;
    _direction = value;
    markNeedsLayout();
  }

  double get spacing => _spacing;
  double _spacing;

  set spacing(double value) {
    assert(value != null);
    if (_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  WrapAlignment get runAlignment => _runAlignment;
  WrapAlignment _runAlignment;

  set runAlignment(WrapAlignment value) {
    assert(value != null);
    if (_runAlignment == value) return;
    _runAlignment = value;
    markNeedsLayout();
  }

  WrapCrossAlignment get crossAxisAlignment => _crossAxisAlignment;
  WrapCrossAlignment _crossAxisAlignment;

  set crossAxisAlignment(WrapCrossAlignment value) {
    assert(value != null);
    if (_crossAxisAlignment == value) return;
    _crossAxisAlignment = value;
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection != value) {
      _textDirection = value;
      markNeedsLayout();
    }
  }

  VerticalDirection get verticalDirection => _verticalDirection;
  VerticalDirection _verticalDirection;

  set verticalDirection(VerticalDirection value) {
    if (_verticalDirection != value) {
      _verticalDirection = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! WrapParentData)
      child.parentData = WrapParentData();
  }

  double _computeIntrinsicHeightForWidth(double width) {
    assert(direction == Axis.horizontal);
    double height = 0.0;
    double runWidth = 0.0;
    double runHeight = 0.0;
    int childCount = 0;
    RenderBox child = firstChild;
    while (child != null) {
      final double childWidth =
          math.min(child.getMaxIntrinsicWidth(double.infinity), width);
      final double childHeight = child.getMaxIntrinsicHeight(childWidth);
      if (childCount > 0 && runWidth + childWidth + spacing > width) {
        height += runHeight;
        runWidth = 0.0;
        runHeight = 0.0;
        childCount = 0;
      }
      runWidth += childWidth;
      runHeight = math.max(runHeight, childHeight);
      if (childCount > 0) runWidth += spacing;
      childCount += 1;
      child = childAfter(child);
    }
    height += runHeight;
    return height;
  }

  double _computeIntrinsicWidthForHeight(double height) {
    assert(direction == Axis.vertical);
    double width = 0.0;
    double runHeight = 0.0;
    double runWidth = 0.0;
    int childCount = 0;
    RenderBox child = firstChild;
    while (child != null) {
      final double childHeight =
          math.min(child.getMaxIntrinsicHeight(double.infinity), height);
      final double childWidth = child.getMaxIntrinsicWidth(childHeight);
      if (childCount > 0 && runHeight + childHeight + spacing > height) {
        width += runWidth;
        runHeight = 0.0;
        runWidth = 0.0;
        childCount = 0;
      }
      runHeight += childHeight;
      runWidth = math.max(runWidth, childWidth);
      if (childCount > 0) runHeight += spacing;
      childCount += 1;
      child = childAfter(child);
    }
    width += runWidth;
    return width;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    switch (direction) {
      case Axis.horizontal:
        double width = 0.0;
        RenderBox child = firstChild;
        while (child != null) {
          width = math.max(width, child.getMinIntrinsicWidth(double.infinity));
          child = childAfter(child);
        }
        return width;
      case Axis.vertical:
        return _computeIntrinsicWidthForHeight(height);
    }
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    switch (direction) {
      case Axis.horizontal:
        double width = 0.0;
        RenderBox child = firstChild;
        while (child != null) {
          width += child.getMaxIntrinsicWidth(double.infinity);
          child = childAfter(child);
        }
        return width;
      case Axis.vertical:
        return _computeIntrinsicWidthForHeight(height);
    }
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    switch (direction) {
      case Axis.horizontal:
        return _computeIntrinsicHeightForWidth(width);
      case Axis.vertical:
        double height = 0.0;
        RenderBox child = firstChild;
        while (child != null) {
          height =
              math.max(height, child.getMinIntrinsicHeight(double.infinity));
          child = childAfter(child);
        }
        return height;
    }
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    switch (direction) {
      case Axis.horizontal:
        return _computeIntrinsicHeightForWidth(width);
      case Axis.vertical:
        double height = 0.0;
        RenderBox child = firstChild;
        while (child != null) {
          height += child.getMaxIntrinsicHeight(double.infinity);
          child = childAfter(child);
        }
        return height;
    }
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  double _getMainAxisExtent(RenderBox child) {
    switch (direction) {
      case Axis.horizontal:
        return child.size.width;
      case Axis.vertical:
        return child.size.height;
    }
  }

  double _getCrossAxisExtent(RenderBox child) {
    switch (direction) {
      case Axis.horizontal:
        return child.size.height;
      case Axis.vertical:
        return child.size.width;
    }
  }

  Offset _getOffset(double mainAxisOffset, double crossAxisOffset) {
    switch (direction) {
      case Axis.horizontal:
        return Offset(mainAxisOffset, crossAxisOffset);
      case Axis.vertical:
        return Offset(crossAxisOffset, mainAxisOffset);
    }
  }

  double _getChildCrossAxisOffset(bool flipCrossAxis, double runCrossAxisExtent,
      double childCrossAxisExtent) {
    final double freeSpace = runCrossAxisExtent - childCrossAxisExtent;
    switch (crossAxisAlignment) {
      case WrapCrossAlignment.start:
        return flipCrossAxis ? freeSpace : 0.0;
      case WrapCrossAlignment.end:
        return flipCrossAxis ? 0.0 : freeSpace;
      case WrapCrossAlignment.center:
        return freeSpace / 2.0;
    }
  }

  final List<RenderBox> childrenToRender = List();

  RenderBox overflowChild;

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    this.overflowChild = lastChild;
    this.childrenToRender.clear();
    RenderBox child = firstChild;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    BoxConstraints childConstraints;
    double mainAxisLimit = 0.0;
    bool flipMainAxis = false;
    bool flipCrossAxis = false;
    switch (direction) {
      case Axis.horizontal:
        childConstraints = BoxConstraints(maxWidth: constraints.maxWidth);
        mainAxisLimit = constraints.maxWidth;
        if (textDirection == TextDirection.rtl) flipMainAxis = true;
        if (verticalDirection == VerticalDirection.up) flipCrossAxis = true;
        break;
      case Axis.vertical:
        childConstraints = BoxConstraints(maxHeight: constraints.maxHeight);
        mainAxisLimit = constraints.maxHeight;
        if (verticalDirection == VerticalDirection.up) flipMainAxis = true;
        if (textDirection == TextDirection.rtl) flipCrossAxis = true;
        break;
    }
    assert(childConstraints != null);
    assert(mainAxisLimit != null);
    final double spacing = this.spacing;

    _RunMetrics runMetric;
    double mainAxisExtent = 0.0;
    double crossAxisExtent = 0.0;
    double runMainAxisExtent = 0.0;
    double runCrossAxisExtent = 0.0;
    int childCount = 0;

    // Define o tamanho do componente
    this.overflowChild.layout(childConstraints, parentUsesSize: true);
    // largura do overflow child
    final double overflowMainAxisExtent = this._getMainAxisExtent(this.overflowChild);
    // altura do overflow child
    final double overflowCrossAxisExtent = this._getCrossAxisExtent(this.overflowChild);

    // Percorre os children
    while (child != null && child != this.overflowChild) {
      // Define o tamanho do componente
      child.layout(childConstraints, parentUsesSize: true);
      // largura child
      double childMainAxisExtent = this._getMainAxisExtent(child);
      // altura child
      final double childCrossAxisExtent = this._getCrossAxisExtent(child);

      // Todos os children não cabem na linha
      // Não é o 1 child && largura atual da linha + espaco + largura child > largura limite da linha
      if (childCount > 0 && runMainAxisExtent + spacing + childMainAxisExtent > mainAxisLimit) {
        // altura atual da linha = maior( altura atual da linha ou altura componente overflow )
        runCrossAxisExtent = math.max(runCrossAxisExtent, overflowCrossAxisExtent);
        // altura do componente += altura atual linha
        crossAxisExtent += runCrossAxisExtent;

        // Os children atuais mais o overflow não cabem na linha
        // largura atual da linha + espaço + largura overflow child > largura limite da linha
        while (runMainAxisExtent + spacing + overflowMainAxisExtent > mainAxisLimit) {
          // removo o tamanho do child atual
          runMainAxisExtent -= childMainAxisExtent;
          // diminuo a quantidade
          childCount--;
          // retiro da lista
          childrenToRender.removeLast();
          // atualizo a largura altual do child
          childMainAxisExtent = this._getMainAxisExtent(childrenToRender.last);
        }

        // largura da linha atual += largura overflow child
        runMainAxisExtent += overflowMainAxisExtent;

        // largura do componente = maior( largura do componente ou largura altural linha )
        mainAxisExtent = math.max(mainAxisExtent, runMainAxisExtent);

        runMetric = _RunMetrics(runMainAxisExtent, runCrossAxisExtent, childrenToRender, true);
        // Zera largura altual linha
        runMainAxisExtent = 0.0;
        // Zera altura altual linha
        runCrossAxisExtent = 0.0;
        // Zera quantidade de childs
        childCount = 0;
      }

      // largura atual linha += largura child
      runMainAxisExtent += childMainAxisExtent;

      // Não é o 1 child
      if (childCount > 0) {
        // largura atual linha += espaco
        runMainAxisExtent += spacing;
      }
      // altura atual linha = maior valor ( altura atual linha ou altura child )
      runCrossAxisExtent = math.max(runCrossAxisExtent, childCrossAxisExtent);
      childCount += 1;

      if (runMetric != null) {
        // altura atual linha = maior valor ( altura atual linha ou altura overflow )
        runCrossAxisExtent = math.max(runCrossAxisExtent, overflowCrossAxisExtent);
        // já foi criada a linha, então não precisa mais percorrer os childrens
        break;
      }

      childrenToRender.add(child);

      final WrapParentData childParentData = child.parentData as WrapParentData;

      child = childParentData.nextSibling;
    }

    // Adiciona a ultima linha
    // Não é 1 child
    if (runMetric == null) {
      // largura do componente = maior( largura do componente, largura atual linha )
      mainAxisExtent = math.max(mainAxisExtent, runMainAxisExtent);
      // altura do componente = maior( altura do componente, altura atual linha )
      crossAxisExtent += runCrossAxisExtent;

      // lista de linhas ADD linha( largura atual linha, altura atual linha, quantidade de childs )
      runMetric = _RunMetrics(runMainAxisExtent, runCrossAxisExtent, childrenToRender, false);
    }

    // quantidade de linhas
    // final int runCount = runMetrics.length;
    final int runCount = 1;
    assert(runCount > 0);

    double containerMainAxisExtent = 0.0;
    double containerCrossAxisExtent = 0.0;

    switch (direction) {
      case Axis.horizontal:
        size = constraints.constrain(Size(mainAxisExtent, crossAxisExtent));
        // largura do componente
        containerMainAxisExtent = size.width;
        // altura do componente
        containerCrossAxisExtent = size.height;
        break;
      case Axis.vertical:
        size = constraints.constrain(Size(crossAxisExtent, mainAxisExtent));
        containerMainAxisExtent = size.height;
        containerCrossAxisExtent = size.width;
        break;
    }

    final double crossAxisFreeSpace =
        math.max(0.0, containerCrossAxisExtent - crossAxisExtent);
    double runLeadingSpace = 0.0;
    double runBetweenSpace = 0.0;
    // feito para fins de alinhamento interno do child
    switch (runAlignment) {
      case WrapAlignment.start:
        break;
      case WrapAlignment.end:
        runLeadingSpace = crossAxisFreeSpace;
        break;
      case WrapAlignment.center:
        runLeadingSpace = crossAxisFreeSpace / 2.0;
        break;
      case WrapAlignment.spaceAround:
        runLeadingSpace = runBetweenSpace / 2.0;
        break;
      case WrapAlignment.spaceEvenly:
        runLeadingSpace = runBetweenSpace;
        break;
    }

    double crossAxisOffset = flipCrossAxis
        ? containerCrossAxisExtent - runLeadingSpace
        : runLeadingSpace;

    final _RunMetrics metrics = runMetric;
    // largura
    runMainAxisExtent = metrics.mainAxisExtent;
    // altura
    runCrossAxisExtent = metrics.crossAxisExtent;

    double childLeadingSpace = 0.0;
    double childBetweenSpace = 0.0;

    childBetweenSpace += spacing;
    double childMainPosition = flipMainAxis
        ? containerMainAxisExtent - childLeadingSpace
        : childLeadingSpace;

    if (flipCrossAxis) {
      crossAxisOffset -= runCrossAxisExtent;
    }

    // varrer os children da linha
    for (RenderBox childToRender in metrics.children) {
      final WrapParentData childParentData = childToRender.parentData as WrapParentData;
      // largura child
      final double childMainAxisExtent = _getMainAxisExtent(childToRender);
      // altura child
      final double childCrossAxisExtent = _getCrossAxisExtent(childToRender);
      //
      final double childCrossAxisOffset = _getChildCrossAxisOffset(flipCrossAxis, runCrossAxisExtent, childCrossAxisExtent);
      if (flipMainAxis) {
        childMainPosition -= childMainAxisExtent;
      }

      // seta o offset do child
      childParentData.offset = _getOffset(childMainPosition, crossAxisOffset + childCrossAxisOffset);
      if (flipMainAxis) {
        childMainPosition -= childBetweenSpace;
      } else {
        childMainPosition += childMainAxisExtent + childBetweenSpace;
      }
    }

    if (metrics.haveOverflowWidget) {
      this.childrenToRender.add(this.overflowChild);
      final WrapParentData childParentData = overflowChild.parentData as WrapParentData;
      // largura
      final double childMainAxisExtent = _getMainAxisExtent(this.overflowChild);
      // altura
      final double childCrossAxisExtent = _getCrossAxisExtent(this.overflowChild);

      final double childCrossAxisOffset = _getChildCrossAxisOffset(flipCrossAxis, runCrossAxisExtent, childCrossAxisExtent);

      if (flipMainAxis) {
        childMainPosition -= childMainAxisExtent;
      }

      childParentData.offset = _getOffset(childMainPosition, crossAxisOffset + childCrossAxisOffset);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    this.childrenToRender.forEach((element) {
      doPaint(context, offset, element);
    });
  }

  void doPaint(PaintingContext context, Offset offset, RenderBox child) {
    if (child != null) {
      final BoxParentData parentData = child.parentData as BoxParentData;
      context.paintChild(child, parentData.offset + offset);
    }
  }
}
