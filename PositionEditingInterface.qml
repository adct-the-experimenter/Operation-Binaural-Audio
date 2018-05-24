import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

import QtQuick.Window 2.2

Rectangle
{
    id:root
    property real position_x
    property real position_y
    property real position_z

    signal positionChanged(real x, real y, real z);

    signal editorClose();

    //Validator to use for text fields
    DoubleValidator
    {
        id:double_vaildator
        bottom: -20; top: 20; decimals: 1;
    }

    Rectangle
    {
        id: rectangle
        x: 0
        y: 0
        width: 100
        height: 200
        visible: true
        Text
        {
            id: position_title
            text: qsTr("Position")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
            font.pixelSize: 12
        }

        Rectangle
        {
            id: x_rect
            height:28;
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.top: position_title.bottom
            anchors.topMargin: 5

            TextField {
                id: xtextField
                x: 50
                y: 0
                width: 50
                height: 20
                text: position_x
                anchors.right: parent.right
                anchors.rightMargin: 0
                validator: double_vaildator

                //If input accepted
                onEditingFinished:
                {
                    //parse number from text and assign it to temp_x
                    temp_values.temp_x = parseFloat(xtextField.text);
                }
            }

            Text {
                id: xtext
                x: 0
                y: 0
                width: 50
                height: 22
                text: qsTr("x:")
                anchors.right: parent.right
                anchors.rightMargin: 20
                font.pixelSize: 12
            }


        }


        Rectangle
        {
            id:y_rect; height:28;
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.top: x_rect.bottom
            anchors.topMargin: 5

            TextField {
                id: ytextField
                x: 50
                y: 0
                width: 50
                height: 20
                text: position_y
                validator: double_vaildator

                //If input accepted
                onEditingFinished:
                {
                    //parse number from text and assign it to temp_y
                    temp_values.temp_y = parseFloat(ytextField.text);
                }
            }

            Text {
                id: ytext
                x: 0
                y: 0
                width: 50
                height: 22
                text: qsTr("y:")
                anchors.right: ytextField.right
                anchors.rightMargin: 20
                font.pixelSize: 12
            }


        }


        Rectangle
        {
            id:z_rect; height:28;
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: y_rect.bottom
            anchors.topMargin: 5

            TextField {
                id: ztextField
                x: 50
                y: 0
                width: 50
                height: 18
                text: position_z
                anchors.right: parent.right
                anchors.rightMargin: 0
                validator: double_vaildator

                //If input accepted
                onEditingFinished:
                {
                    //parse number from text and assign it to temp_z
                    temp_values.temp_z = parseFloat(ztextField.text);
                }
            }

            Text {
                id: ztext
                width: 50
                height: 22
                text: qsTr("z:")
                anchors.right: parent.right
                anchors.rightMargin: 20
                font.pixelSize: 12
            }


        }


        Button {
            id: ok_button
            text: qsTr("OK")
            anchors.horizontalCenterOffset: 0
            anchors.top: z_rect.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter

            property bool valueChange: false

            onClicked:
            {
                valueChange = false;

                //save temporary value to final value of position
                if(root.position_x != temp_values.temp_x)
                {
                    root.position_x = temp_values.temp_x;
                    valueChange = true;
                }

                if(root.position_y != temp_values.temp_y)
                {
                    root.position_y = temp_values.temp_y;
                    valueChange = true;
                }

                if(root.position_z != temp_values.temp_z)
                {
                    root.position_z = temp_values.temp_z;
                    valueChange = true;
                }

                if(valueChange){positionChanged(temp_values.temp_x,temp_values.temp_y,temp_values.temp_z)};
                root.editorClose();
            }
        }

        Button
        {
            id: cancel_button
            text: qsTr("Cancel")
            anchors.horizontalCenterOffset: 0
            anchors.top: ok_button.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter

            onClicked:{root.editorClose();}
        }

        Item
        {
            id:temp_values
            property real temp_x: root.position_x
            property real temp_y: root.position_y
            property real temp_z: root.position_z
        }
    }











}
