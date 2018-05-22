import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

import QtQuick.Scene3D 2.0
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Extras 2.0

Item {
    id: item1
    width: 640
    height: 480
    property alias attribute_show_rect: attribute_show_rect
    property alias attributes_section: attributes_section
    property alias area_for_3drender: area_for_3drender
    property alias bindSourceButton: bindSourceButton
    property alias loadButton: loadButton
    property alias hrtfTestButton: hrtfTestButton
    property alias x_pos_display: x_pos_display
    property alias y_pos_display: y_pos_display
    property alias moveRightButton: moveRightButton
    property alias moveLeftButton: moveLeftButton
    property alias stopButton: stopButton
    property alias playButton: playButton
    property alias moveDownButton: moveDownButton
    property alias moveUpButton: moveUpButton

    Text {
        id: x_pos_text
        x: 23
        y: 413
        text: qsTr("X:")
        font.pixelSize: 12
    }

    Text {
        id: x_pos_display
        x: 41
        y: 413
        font.pixelSize: 12
        text: display_position.xvalue
    }

    Text {
        id: y_pos_text
        x: 23
        y: 433
        text: qsTr("Y:")
        font.pixelSize: 12
    }

    Text {
        id: y_pos_display
        x: 41
        y: 433
        font.pixelSize: 12
        text: display_position.yvalue
    }

    RowLayout {
        id: row1
        anchors.verticalCenterOffset: 135
        anchors.horizontalCenterOffset: -16
        anchors.centerIn: parent

        Button {
            id: playButton
            width: 60
            height: 20
            text: qsTr("Play Sound")
        }

        Button {
            id: stopButton
            width: 60
            height: 20
            text: qsTr("Stop Sound")
        }

        Button {
            id: loadButton
            width: 60
            height: 20
            text: qsTr("Load Sound File")
        }

        Button {
            id: bindSourceButton
            width: 60
            height: 20
            text: qsTr("Bind Sound to Source")
        }
    }

    RowLayout {
        id: row2
        x: 237
        y: 257
        width: 166
        height: 27
        anchors.horizontalCenterOffset: -17
        anchors.verticalCenterOffset: 31
        anchors.verticalCenter: row1.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: moveUpButton
            width: 60
            height: 20
            text: qsTr("Up")
        }

        Button {
            id: moveLeftButton
            width: 60
            height: 20
            text: qsTr("Left")
        }
    }

    RowLayout {
        id: row3
        x: 237
        y: 290
        width: 169
        height: 22
        anchors.horizontalCenterOffset: -17
        anchors.verticalCenterOffset: 61
        anchors.verticalCenter: row1.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: moveDownButton
            width: 60
            height: 20
            text: qsTr("Down")
        }

        Button {
            id: moveRightButton
            width: 60
            height: 20
            text: qsTr("Right")
        }
    }

    Button {
        id: hrtfTestButton
        x: 280
        y: 201
        text: qsTr("HRTF Test")
        anchors.verticalCenterOffset: -29
        anchors.verticalCenter: row1.verticalCenter
        anchors.horizontalCenterOffset: -17
        anchors.horizontalCenter: row1.horizontalCenter
    }

    Rectangle {
        id: area_for_3drender
        x: 96
        y: 28
        width: 415
        height: 282
        color: "#ffffff"
        anchors.bottom: hrtfTestButton.top
        anchors.bottomMargin: 20
        visible: false
    }

    Rectangle {
        id: attributes_section
        x: 517
        y: 32
        width: 120
        height: 300
        color: "#dcdada"
        visible: false
        anchors.right: parent.right
        anchors.rightMargin: 2
        border.width: 1

        Text {
            id: attributes_text
            x: 0
            y: 0
            width: 120
            height: 15
            text: qsTr("Attributes")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12
        }

        Rectangle {
            id: attribute_show_rect
            x: 110
            y: 290
            width: 100
            height: 100
            color: "#f9f8f8"
            z: 1
            anchors.top: attributes_section.bottom
            anchors.topMargin: -10
            anchors.bottom: attributes_section.top
            anchors.bottomMargin: -10
            anchors.left: attributes_section.right
            anchors.leftMargin: -10
            anchors.right: attributes_section.left
            anchors.rightMargin: -10
        }
    }
}
