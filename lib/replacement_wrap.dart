import 'package:flutter/widgets.dart';
import 'package:replacement_wrap/render_replacement_wrap.dart';

class ReplacementWrap extends MultiChildRenderObjectWidget {
  ReplacementWrap({
    Key key,
    this.direction = Axis.horizontal,
    this.spacing = 0.0,
    this.runAlignment = WrapAlignment.center,
    this.crossAxisAlignment = WrapCrossAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.children,
    Widget overflowWidget,
  })  : assert(overflowWidget != null),
        super(key: key, children: children){
    children.add(overflowWidget);
  }

  final List<Widget> children;
  final Axis direction;
  final double spacing;
  final WrapAlignment runAlignment;
  final WrapCrossAlignment crossAxisAlignment;
  final TextDirection textDirection;
  final VerticalDirection verticalDirection;

  @override
  RenderReplacementWrap createRenderObject(BuildContext context) {
    return RenderReplacementWrap(
      direction: direction,
      spacing: spacing,
      runAlignment: runAlignment,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection ?? Directionality.of(context),
      verticalDirection: verticalDirection,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderReplacementWrap renderObject) {
    renderObject
      ..direction = direction
      ..spacing = spacing
      ..runAlignment = runAlignment
      ..crossAxisAlignment = crossAxisAlignment
      ..textDirection = textDirection ?? Directionality.of(context)
      ..verticalDirection = verticalDirection;
  }
}
