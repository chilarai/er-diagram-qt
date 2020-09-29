import QtQuick 2.15

Rectangle {
    id: entityRectangle
    color: "gold"
    border.width: 1
    border.color: "grey"


    Text{
        id: entityRectangleText
        anchors.centerIn: parent
        font.pointSize: 16

        text: entityRectangle.objectName
    }  
}
