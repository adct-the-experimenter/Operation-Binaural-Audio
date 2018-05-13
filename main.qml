import com.vas.openalsoftaudioengine 1.0 //for OpenAlSoftAudioEngine
import com.vas.interface3dengine 1.0 //for qt3dInterfaceEngine

import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

import QtQuick.Scene3D 2.0
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Extras 2.0
import Qt3D.Input 2.0
import Qt3D.Logic 2.0

import QtQuick.Window 2.2


ApplicationWindow
{
    id:appwindow
    visible: true
    width: 640
    height: 480
    title: qsTr("VAS Audio Application")

    //menu bar at top of main form
    menuBar: MenuBar
    {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered:
                {
                    customFileDialog.mode = "OpenSoundFile";
                    customFileDialog.open();
                }
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    //Object to help open files
    CustomFileDialog
    {
        id:customFileDialog
    }

    //QTObject variable to display position
    QtObject
    {
        id:display_position
        property string xvalue : "0"
        property string yvalue : "0"
        property string zvalue : "0"
    }

    //QtObject variable to represent position of listener
    QtObject
    {
        id:observer_position
        property real x: 0
        property real y: 0
        property real z: 0

    }

    QtObject
    {
        id:sound_data
        property string sound_filename: customFileDialog.sound_filepath
    }

    //Message Dialog entity to display messages
    MessageDialog
    {
        id: messageDialog

        function show(caption)
        {
            messageDialog.text = caption;
            messageDialog.open();
        }
    }

    //OpenAlSoftAudioEngine QML object
    OpenAlSoftAudioEngine
    {
        id:audioengine

        onListenerPositionXChanged:{display_position.xvalue = audioengine.listener_pos_x}
        onListenerPositionYChanged:{display_position.yvalue = audioengine.listener_pos_y}

    }


    //Interface3DEngine QML Object
    Interface3DEngine
    {
        id:interfaceengine        

    }

    Rectangle
    {
        id:render_rect
        x:mainform.area_for_3drender.x
        y:mainform.area_for_3drender.y
        width: mainform.area_for_3drender.width
        height: mainform.area_for_3drender.height
        color: "#ffffff"

        // 3D scene
        Scene3D
        {
            id: scene3d
            aspects: ["render", "input","logic"]
            anchors.fill: parent
            anchors.margins: 10
            focus: true

            Entity
            {
                id: scene_root

                Camera
                {
                    id: mainCamera
                    projectionType: CameraLens.PerspectiveProjection
                    fieldOfView: 45
                    nearPlane : 0.1
                    farPlane : 1000.0
                    position: Qt.vector3d( 0.0, 0.0, 40.0 )
                    upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
                    viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
                }

                VASCameraController
                {
                    id:camera_controller
                    camera: mainCamera
                }

                components:
                [
                    RenderSettings
                    {
                        activeFrameGraph: ForwardRenderer {
                            camera: mainCamera
                            clearColor: "transparent"
                            }
                        renderPolicy: RenderSettings.OnDemand
                    },

                    InputSettings {},
                    FrameAction
                    {
                        onTriggered:
                        {
                            camera_controller.cameraControllerLogic();
                        }
                    }

                ]

                //entity to render
                SphereEntity { id:spherelistener; x:0; y:0; z:0; }

            }

        }

    }




    //main form to display
    MainForm
    {
        id:mainform

        anchors.fill: parent

        //if play button is pressed
        playButton.onClicked:
        {
             //play sound loaded in buffer

        }
        //if stop button is pressed
        stopButton.onClicked:
        {
             //stop soundEffect
        }
        //if moveUpButton is pressed
        moveUpButton.onClicked:
        {
            observer_position.y -= 1 //decrement y position
            audioengine.listener_pos_y = observer_position.y
        }
        //if moveDownButton is pressed
        moveDownButton.onClicked:
        {
            observer_position.y += 1 //increment y position
            audioengine.listener_pos_y = observer_position.y
        }

        //if moveLeftButton is pressed
        moveLeftButton.onClicked:
        {
            observer_position.x -= 1 //decrement x position
            audioengine.listener_pos_x = observer_position.x
        }

        //if moveRightButton is pressed
        moveRightButton.onClicked:
        {
            observer_position.x += 1 //increment x position
            audioengine.listener_pos_x = observer_position.x
        }

        //if hrtfTestButton is pressed
        hrtfTestButton.onClicked:
        {
            audioengine.qmlfunc_testHRTF() //perform test
            messageDialog.title = "HRTF Test Output";
            messageDialog.show( audioengine.qml_string_HRTF_result()) //show result
            audioengine.qml_clear_HRTF_result() //clear result string
        }

        //if loadButton is pressed
        loadButton.onClicked:
        {
            audioengine.qmlfunc_loadSound(sound_data.sound_filename); //load sound file to buffer
            messageDialog.title = "Load Sound Output";
            messageDialog.show(audioengine.qml_string_LoadSound_result()); //show result
            audioengine.qml_string_LoadSound_result(); //clear result string
        }
    }



}

