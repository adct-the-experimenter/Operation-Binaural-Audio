import QtQml 2.2

import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Logic 2.0

import Qt3D.Extras 2.0

Entity {
    id: root

    /*

    */

    property Entity cameraToControl
    property real mouseSensitivity: .5 // Units.dp
    property real cameraSpeed: 2


    FirstPersonCameraController
    {
        camera: cameraToControl
        linearSpeed: cameraSpeed
        lookSpeed: cameraSpeed*10
    }


}


