import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: mainWindow
    visible: true
    width: 1000
    height: 600
    title: qsTr("Simple ER Diagram with QML")


    // Dynamic properties
    property int counter : 0
    property var entityRectangleMap : new Map() // Holds the created EntityRectangle
    property var entityDeleteMap : new Map() // Holds the created EntityDelete
    property var entityLineMap : new Map() // Holds the created EntityLine
    property var frontEntityCoordinatesMap : new Map() // Holds the top-left corner coordinates of the EntityRectangle
    property var rearEntityCoordinatesMap : new Map() // Holds the top-right corner coordinates of the EntityRectangle

    property var entityRectangle : Qt.createComponent("EntityRectangle.qml");
    property var entityDelete : Qt.createComponent("EntityDelete.qml")
    property var entityLine : Qt.createComponent("EntityLine.qml")


    // Static properties
    property int entityRectangleWidth: 50
    property int entityRectangleHeight: 30
    property int initialDistance: 50

    property int initialEntityRectangleX : 5
    property int initialEntityRectangleY : 50


    // Dynamically add entity to the window
    // and join to the previous entity

    function addEntity(){

        let frontCoordinates = {x: 0, y: 0}
        let rearCoordinates = {x: 0, y: 0}
        let prevEntityRectangleFrontCoordinates = {x: 0, y: 0}
        let prevEntityRectangleRearCoordinates = {x: 0, y: 0}
        let x1 = 0 // entityLine start point
        let x2 = 0 // entityLine end point
        let y = 0
        let prevCounter = counter

        counter++

        if(counter === 1){

            // Create first entityRectangle

            entityRectangleMap.set(counter, entityRectangle.createObject(mainWindow, {x:initialEntityRectangleX, y: initialEntityRectangleY, height: entityRectangleHeight, width: entityRectangleWidth, objectName : counter}))

            // Enter front and rear coordinates
            // Save in map

            frontCoordinates = {x: initialEntityRectangleX, y: initialEntityRectangleY}
            rearCoordinates = {x: initialEntityRectangleX + entityRectangleWidth, y: initialEntityRectangleY}

            frontEntityCoordinatesMap.set(counter, frontCoordinates)
            rearEntityCoordinatesMap.set(counter, rearCoordinates)


        } else{


            prevEntityRectangleFrontCoordinates = frontEntityCoordinatesMap.get(prevCounter)
            prevEntityRectangleRearCoordinates = rearEntityCoordinatesMap.get(prevCounter)

            // Enter front and rear coordinates
            // Save in map

            frontCoordinates = {x: prevEntityRectangleRearCoordinates.x + initialDistance, y: prevEntityRectangleRearCoordinates.y}
            rearCoordinates = {x: prevEntityRectangleRearCoordinates.x + initialDistance + entityRectangleWidth, y: prevEntityRectangleRearCoordinates.y}

            frontEntityCoordinatesMap.set(counter, frontCoordinates)
            rearEntityCoordinatesMap.set(counter, rearCoordinates)


            entityRectangleMap.set(counter, entityRectangle.createObject(mainWindow, {x: frontEntityCoordinatesMap.get(counter).x, y: frontEntityCoordinatesMap.get(counter).y, height: entityRectangleHeight, width: entityRectangleWidth, objectName : counter}))
            entityDeleteMap.set(counter, entityDelete.createObject(mainWindow, {x: frontEntityCoordinatesMap.get(counter).x, y: frontEntityCoordinatesMap.get(counter).y, objectName : counter}))


            x1 = prevEntityRectangleRearCoordinates.x
            x2 = frontEntityCoordinatesMap.get(counter).x
            y = frontEntityCoordinatesMap.get(counter).y + entityRectangleHeight / 2

            entityLineMap.set(counter, entityLine.createObject(mainWindow, {x1: x1, y1: y, x2: x2, y2: y, objectName : counter}))

            // Dynamically connect `deleteEntitySignal` with `deleteEntitySlot()`
            // This will listen for delete entity signals

            entityDeleteMap.get(counter).deleteEntitySignal.connect(mainWindow.deleteEntitySlot)
        }

    }


    // Delete an entity relationship
    // when a delete signal is received by deleteEntity() slot

    function deleteEntitySlot(refObj){

        // Delete objects
        entityRectangleMap.get(refObj).destroy()
        entityDeleteMap.get(refObj).destroy()
        entityLineMap.get(refObj).destroy()

        // Delete all relevant data

        entityRectangleMap.delete(refObj)
        entityDeleteMap.delete(refObj)
        entityLineMap.delete(refObj)
        frontEntityCoordinatesMap.delete(refObj)
        rearEntityCoordinatesMap.delete(refObj)

        // Check if the refObj is not the last element
        // If not, then delete the entities behind

        if(refObj < counter){

            for(var i = refObj + 1; i <= counter ; i++){

                entityRectangleMap.get(i).destroy()
                entityDeleteMap.get(i).destroy()
                entityLineMap.get(i).destroy()

                entityRectangleMap.delete(i)
                entityDeleteMap.delete(i)
                entityLineMap.delete(i)
                frontEntityCoordinatesMap.delete(i)
                rearEntityCoordinatesMap.delete(i)
            }
        }

        // Set counter to the new value

        const newValue = refObj - 1
        counter = newValue <= 1 ? 1 : newValue
    }





    Button{
        id: addBtn
        text: qsTr("Add New Entity")
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.leftMargin: 5

        onClicked: addEntity()
    }
}
