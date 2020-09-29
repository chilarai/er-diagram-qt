import QtQuick 2.15
import QtQuick.Shapes 1.15


// This is the dynamically generated line connecting two rectangles
// when a relation is to be shown between two entities

Item{
    id: entityLine
    property string lineColor
    property var x1
    property var y1
    property var x2
    property var y2
    property var objectName

    objectName: objectName

    Shape {
        containsMode: Shape.FillContains

        ShapePath {
            id:shapePath
            strokeColor: lineColor
            strokeWidth: 1
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            startX: x2
            startY: y2

            PathLine {
                id: secondRectCoord;
                x: x1
                y: y1
            }
        }
    }
}
