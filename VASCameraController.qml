import QtQml 2.2

import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Logic 2.0

import "."

Entity {
    id: root

    /*
        With Qt3D Logic aspect, we can handle various input devices more easily
        the flag bits described with LogicalDevice, neat and tidy
        Refer: qthelp://org.qt-project.qt3d.570/qt3d/qml-qt3d-input-logicaldevice.html
        NOTE: Wheel Axis supported since Qt 5.8
        See: http://lists.qt-project.org/pipermail/interest/2016-August/024010.html
            and qt3d/src/input/backend/mousedevice.cpp
    */

    property Entity camera
    property real mouseSensitivity: .5 // Units.dp
    property real cameraSpeed: 2

    QtObject {
        id: d

        property real fineScale: fineModifier.active ? .1 : 1. // with shift key
        property real mouseSensitivity: root.mouseSensitivity*fineScale
        property real cameraSpeed: root.cameraSpeed*fineScale
        property bool moveActionActived: false
    }



    function cameraControllerLogic(upMove,downMove,rightMove,leftMove,dt)
    {

        var position = root.camera.position;

        if (upMove)
            position = position + root.camera.frontVector*(d.cameraSpeed * dt);
        if (downMove)
            position = position + -1.0*root.camera.frontVector*(d.cameraSpeed * dt);
        if (rightMove)
            position = position + root.camera.rightVector*(d.cameraSpeed * dt);
        if (leftMove)
            position = position + -1.0*root.camera.rightVector*(d.cameraSpeed * dt);

        root.camera.position = position;
    }
}

