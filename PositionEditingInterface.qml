import QtQuick 2.0
import QtQuick.Controls 1.5
import QtQuick.Dialogs 1.2

Item
{
    id:root
    property real position_x: 0
    property real position_y: 0
    property real position_z: 0


    //signal to return when finished editing
    signal doneEditing();
    property alias ztextField: ztextField

    anchors.fill: parent

    visible: true

    Rectangle
    {
        id: rectangle1

        x:200
        y:10
        width: 287
        height: 201
        color: "#f5f3f3"
        opacity: 1

        Item
        {
            id:temp_values
            property real temp_x: 0
            property real temp_y: 0
            property real temp_z: 0
        }

        Row {
            id: x_row
            x: 164
            y: 20
            width: 200
            height: 28
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 30

            Text {
                id: xtext
                width: 50
                height: 22
                text: qsTr("x:")
                font.pixelSize: 12
            }

            TextField {
                id: xtextField
                text: position_x
                validator: DoubleValidator {bottom: -100; top: 100; decimals: 4;}

                //If input accepted
                onAccepted:
                {
                    //parse number from text and assign it to temp_x
                    temp_values.temp_x = parseFloat(xtextField.text);
                }
            }


        }

        Row {
            id: y_row
            x: 164
            y: 58
            width: 200
            height: 28
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 0
            Text {
                id: ytext
                width: 50
                height: 22
                text: qsTr("y:")
                font.pixelSize: 12
            }

            TextField {
                id: ytextField
                text: position_y
                validator: DoubleValidator {
                    top: 100
                    bottom: -100
                    decimals: 4
                }

                //If input accepted
                onAccepted:
                {
                    //parse number from text and assign it to temp_y
                    temp_values.temp_y = parseFloat(ytextField.text);
                }
            }
            anchors.top: x_row.bottom
        }

        Row {
            id: z_row
            x: 164
            y: 96
            width: 200
            height: 28
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 0

            Text {
                id: ztext
                width: 50
                height: 22
                text: qsTr("z:")
                font.pixelSize: 12
            }

            TextField {
                id: ztextField
                text: position_z
                validator: DoubleValidator {
                    top: 100
                    decimals: 4
                    bottom: -100
                }

                //If input accepted
                onAccepted:
                {
                    //parse number from text and assign it to temp_z
                    temp_values.temp_z = parseFloat(ztextField.text);
                }
            }

            anchors.top: y_row.bottom
        }

        Row {
            id: button_row
            x: 150
            y: 134
            width: 228
            height: 32
            anchors.horizontalCenter: z_row.horizontalCenter
            anchors.top: z_row.bottom
            anchors.topMargin: 10

            Button {
                id: ok_button
                x: -2
                text: qsTr("OK")
                onClicked:
                {
                    //save temporary value to final value of voltage supplied
                    root.position_x = temp_values.temp_x;
                    root.position_y = temp_values.temp_y;
                    root.position_z = temp_values.temp_z;
                    doneEditing(); //return doneEditing signal
                }
            }

            Button
            {
                id: cancel_button
                x: 126
                text: qsTr("Cancel")

                onClicked:{doneEditing();}
            }

        }

        Text {
            id: position_title
            x: 121
            y: 8
            text: qsTr("Position")
            font.pixelSize: 12
        }





    }










}
