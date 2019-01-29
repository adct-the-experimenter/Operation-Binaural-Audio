import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import com.vas.openalsoftaudioengine 1.0 //for OpenAlSoftAudioEngine

Item
{
    id:root
    property Rectangle area_for_editor
    property OpenAlSoftAudioEngine audioengine

    signal openSoundFileOpener();


    focus: false

    Rectangle
    {
        id: samples_section
        visible: true
        x: area_for_editor.x; y:area_for_editor.y; width: area_for_editor.width; height: area_for_editor.height
        color: "light gray"

        Text
        {
            id: samples_text
            x: 0
            width: 120
            height: 16
            text: qsTr("Samples")
            anchors.top: parent.top
            anchors.topMargin: 0
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12
        }


    }

    Rectangle
    {
        id: sample_show_rect
        x: area_for_editor.x+10;
        y: area_for_editor.y+15;
        width: area_for_editor.width-20
        height: area_for_editor.height-20
        color: "white"

        //current selection
        Rectangle
        {
            id: current_selection_rect
            color:"blue"
            width:sample_show_rect.width
            height:sample_show_rect.height/2
        }

        //bank with scroll wheel
        Rectangle
        {
            id: sample_bank_rect
            color:"red"
            y:current_selection_rect.height
            width: sample_show_rect.width
            height: sample_show_rect.height/2
        }

        Button
        {
            id:new_sample_button
            x: 0
            y: 0
            width: 30
            height: 23
            text: "New"

            onClicked:
            {
                //root.soundFileOpener.mode = "OpenSoundFile";
                //root.soundFileOpener.open();
                openSoundFileOpener();
            }

        }


    }

    MessageDialog
    {
        id: messageDialog

        function show(caption)
        {
            messageDialog.text = caption;
            messageDialog.open();
        }
    }


    function addNewSampleToAudioEngine()
    {
        audioengine.qmlfunc_loadSound(soundFileOpener.sound_filename); //load sound file to buffer
        messageDialog.title = "Load Sound Output";
        messageDialog.show(audioengine.qml_string_LoadSound_result()); //show result
        audioengine.qml_string_LoadSound_result(); //clear result string

    }

    function removeSampleFromAudioEngine()
    {

    }
}

