import QtQuick 2.15

Item {
    id: entityDeleteItem
    width: entityDeleteIcon.width
    height: entityDeleteIcon.height
    z: 3

    signal deleteEntitySignal(int refObj)

    function entityDelete(){
        deleteEntitySignal(entityDeleteItem.objectName)
    }

    Image{
        id: entityDeleteIcon
        source: "delete_icon.png"
        width: 16
        height: 16

    }

    MouseArea{
        anchors.fill: parent
        onClicked: entityDelete()
    }
}
