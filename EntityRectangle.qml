import QtQuick 2.15

Rectangle {
    id: entityRectangle
    color: "gold"
    border.width: 1
    border.color: "grey"

    signal entityRectangleMovedSignal(int refObj, double mouseXCoord, double mouseYCoord)


    Text{
        id: entityRectangleText
        anchors.centerIn: parent
        font.pointSize: 16

        text: entityRectangle.objectName
    }


    MouseArea{
        id: mouseArea
        anchors.fill: parent
        drag.target: entityRectangle

        onPositionChanged: entityRectangleMovedSignal(entityRectangle.objectName, mouseX, mouseY)
    }
}
