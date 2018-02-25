import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import com.vas.openalsoftaudioengine 1.0 //for OpenAlSoftAudioEngine

ApplicationWindow
{
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

    //main form to display
    MainForm
    {
        anchors.fill: parent
        //if play button is pressed
        playButton.onClicked:
        {
             //play soundEffect
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
