import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

Menu
{
    id:menu
    visible: false
    property bool menuActive: false //used to prevent repeating calls to popup menu
    property bool loopingEnabled:false //indicate if audio source can be looped

    signal xPositionChanged(real x);
    signal yPositionChanged(real y);
    signal zPositionChanged(real z);
    signal positionEditorCalled();

    MenuItem
    {
        id:move_menuitem
        text:"Move"

        onTriggered:
        {

        }
    }

    MenuItem
    {
        id:position_menuitem
        text:"Position..."


        onTriggered:
        {
            //var component = Qt.createComponent("PositionEditingInterface.qml");
            //var positionEditor = component.createObject(root);
            positionEditorCalled();
        }

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


