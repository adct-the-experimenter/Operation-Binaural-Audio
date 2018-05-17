import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

Menu
{
    id:menu
    visible: false
    property bool menuActive: false //used to prevent repeating calls to popup menu
    property bool loopingEnabled:false //indicate if audio source can be looped

    MenuItem
    {
        id:position_menuitem
        text:"Position..."

        onTriggered:
        {
            position_editor.visible=true;
            position_editor.focus=true;
        }
    }

    PositionEditingInterface
    {
        id:position_editor
        visible: false

        onDoneEditing:{position_editor.visible=false;}
    }


    MenuItem
    {
        id:sample_menu
        text:"Sample..."

        onTriggered:
        {

        }
    }

    MenuItem
    {
        id:looping_menu
        text:"Looping"
        checkable: true
        checked:false

        onCheckableChanged:
        {
            loopingEnabled = looping_menu.checked;
        }
    }
}


