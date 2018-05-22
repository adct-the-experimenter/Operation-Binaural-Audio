import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

Item
{
    id:root
    property Rectangle area_for_editor
    property GraphicalAudioSource graphicalAudioSource

    signal positionChanged(real x,real y, real z);

    Rectangle
    {
        id: attributes_section
        visible: true
        x: area_for_editor.x; y:area_for_editor.y; width: area_for_editor.width; height: area_for_editor.height
        color: "gray"

        Text
        {
            id: attributes_text
            x: 0
            width: 120
            height: 16
            text: qsTr("Attributes")
            anchors.top: parent.top
            anchors.topMargin: 0
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12
        }


    }

    Rectangle
    {
        id: attribute_show_rect
        x: area_for_editor.x+10;
        y: area_for_editor.y+15;
        width: area_for_editor.width-20
        height: area_for_editor.height-20
        color: "white"


        PositionEditingInterface
        {
            id:positionEditor
            visible: false
            anchors.fill: parent
            onEditorClose:
            {
                positionEditor.visible=false;
                if(root.graphicalAudioSource != null){root.graphicalAudioSource = null;}
                root.focus = false;
            }
            onPositionChanged:
            {
                if(root.graphicalAudioSource != null)
                {
                    root.graphicalAudioSource.x = x;
                    root.graphicalAudioSource.y = y;
                    root.graphicalAudioSource.z = z;
                }

            }
        }
    }



    function callPositionEditor()
    {
        root.focus=true;
        positionEditor.visible = true;
        if(root.graphicalAudioSource != null)
        {
            positionEditor.position_x = root.graphicalAudioSource.x;
            positionEditor.position_y = root.graphicalAudioSource.y;
            positionEditor.position_z = root.graphicalAudioSource.z;
        }
        else{console.log("audio source property is null! Set before calling position editor.\n");}


    }

}
