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
    property real cameraSpeed: 5.

    QtObject {
        id: d

        property real fineScale: fineModifier.active ? .1 : 1. // with shift key
        property real mouseSensitivity: root.mouseSensitivity*fineScale
        property real cameraSpeed: root.cameraSpeed*fineScale
        property bool lookActionActived: false
        property bool orbitActionActived: false
        property bool moveActionActived: false
    }

    KeyboardDevice {
        id: keyboardDevice
    }

    KeyboardHandler
    {
        sourceDevice: keyboardDevice
    }

    MouseDevice {
        id: mouseDevice
        sensitivity: d.mouseSensitivity
    }

    MouseHandler {
        sourceDevice: mouseDevice
    }

    LogicalDevice {
        // The LogicalDevice, the "managed flag bits"

        enabled: true
        actions: [
            Action {
                // Generally with ActionInput, for button pressing
                // including single key press, key chord and key sequence

                id: lookAction
                ActionInput {
                    sourceDevice: mouseDevice
                    buttons: [MouseEvent.LeftButton]
                }
            },
            Action {
                id: orbitAction
                ActionInput {
                    sourceDevice: mouseDevice
                    buttons: [MouseEvent.RightButton]
                }
            },
            Action {
                id: moveAction
                ActionInput {
                    sourceDevice: mouseDevice
                    buttons: [MouseEvent.MiddleButton]
                }
            },
            Action {
                id: leftMove
                ActionInput {
                    sourceDevice: keyboardDevice
                    buttons: [Qt.Key_Left, Qt.Key_A]
                }
            },
            Action {
                id: rightMove
                ActionInput {
                    sourceDevice: keyboardDevice
                    buttons: [Qt.Key_Right, Qt.Key_D]
                }
            },
            Action {
                id: upMove
                ActionInput {
                    sourceDevice: keyboardDevice
                    buttons: [Qt.Key_Up, Qt.Key_W]
                }
            },
            Action {
                id: downMove
                ActionInput {
                    sourceDevice: keyboardDevice
                    buttons: [Qt.Key_Down, Qt.Key_S]
                }
            },
            Action {
                id: fineModifier
                ActionInput {
                    sourceDevice: keyboardDevice
                    buttons: [Qt.Key_Shift]
                }
            }
        ]
        axes: [
            Axis {
                // Generally with AxisInput, for analog device value changing
                // usually for mouses and joysticks

                id: xAxis
                AnalogAxisInput {
                    sourceDevice: mouseDevice
                    axis: MouseDevice.X
                }
            },
            Axis {
                id: yAxis
                AnalogAxisInput {
                    sourceDevice: mouseDevice
                    axis: MouseDevice.Y
                }
            },
            Axis {
                id: wAxis
                AnalogAxisInput {
                    sourceDevice: mouseDevice
                    axis: MouseDevice.WheelY
                }
            }
        ]
    }

    function cameraControllerLogic()
    {
            var position = root.camera.position;

            if (upMove.active)
                //position = position.plus(root.camera.frontVector.times(d.cameraSpeed * dt));
                console.log("up key pressed! \n");
            if (downMove.active)
                position = position.minus(root.camera.frontVector.times(d.cameraSpeed * dt));
            if (rightMove.active)
                position = position.plus(root.camera.rightVector.times(d.cameraSpeed * dt));
            if (leftMove.active)
                position = position.minus(root.camera.rightVector.times(d.cameraSpeed * dt));

            root.camera.position = position;
    }
}

