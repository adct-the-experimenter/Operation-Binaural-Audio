import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

import QtQuick.Scene3D 2.0
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Extras 2.0
import Qt3D.Input 2.0

import QtQuick.Window 2.2

Entity
{
    id:root
    property real x: 0
    property real y: 0
    property real z: 0
    property MouseDevice mouseDevice
    property Camera camera
    property int renderAreaWidth
    property int renderAreaHeight

    SphereEntity
    {
        id:sphere; x:root.x; y:root.y; z:root.z; color:"gray";
        radius: 3;
    }

    MouseHandler
    {
        id:mouseOperator
        sourceDevice: mouseDevice
        //mouse position on click
        property int clickPosX
        property int clickPosY
        property bool rightClick: false
        property bool leftClick: false
        property bool press: false
        property bool pressHold: false

        onPressed:
        {
            clickPosX = mouse.x; clickPosY = mouse.y;
            mouse.button == MouseEvent.RightButton ? rightClick=true : rightClick=false;
            mouse.button == MouseEvent.LeftButton ? leftClick=true : leftClick=false;
            press = true; pressHold=false;
        }

        onPressAndHold:
        {
            clickPosX = mouse.x; clickPosY = mouse.y;
            mouse.button == MouseEvent.RightButton ? rightClick=true : rightClick=false;
            mouse.button == MouseEvent.LeftButton ? leftClick=true : leftClick=false;
            press = false; pressHold = true;
        }

        onReleased:
        {
            clickPosX = 0; clickPosY = 0;
            rightClick = false; leftClick = false; press = false; pressHold = false;
        }

    }

    MenuGraphicalAudioSource
    {
        id:menu
    }

    Item
    {
        id:logic_event
        property int currentEvent: event_enum.none
        property bool sphereClickedOn: false
    }

    Item
    {
        id:event_enum
        property int none: 0
        property int rightclickonspherepress: 1
        property int rightclickonspherepresshold: 2
        property int leftclickonspherepress: 3
        property int leftclickonspherepresshold: 4
    }

    function audioSourceLogic()
    {
        checkIfSphereClickedOn();
        if(logic_event.sphereClickedOn){operationSphereClickedOn();}
        else{logic_event.currentEvent = event_enum.none;}
        actOnEvents();
    }

    function checkIfSphereClickedOn()
    {
        logic_event.sphereClickedOn = false;

        var centerScreenCoord = get2DScreenCoordFrom3DWorld_SphereCenter();
        var rightScreenCoord = get2DScreenCoordFrom3DWorld_SphereRight();
        var topScreenCoord = get2DScreenCoordFrom3DWorld_SphereTop();

        if(centerScreenCoord.x >= 0 && centerScreenCoord.x <= renderAreaWidth
           && centerScreenCoord.y >= 0 && centerScreenCoord.y <= renderAreaHeight)
        {
            var boundBoxWidth = Math.abs((rightScreenCoord.x-centerScreenCoord.x));
            var boundBoxHeight = Math.abs((topScreenCoord.y-centerScreenCoord.y));

            if(mouseOperator.rightClick || mouseOperator.leftClick)
            {
                if(mouseOperator.clickPosX >= centerScreenCoord.x - boundBoxWidth &&
                   mouseOperator.clickPosX <= centerScreenCoord.x + boundBoxWidth)
                {
                    if(mouseOperator.clickPosY >= centerScreenCoord.y - boundBoxHeight &&
                       mouseOperator.clickPosY <= centerScreenCoord.y + boundBoxHeight)
                    {
                        logic_event.sphereClickedOn = true;
                    }
                }

            }
        }
    }

    function operationSphereClickedOn()
    {
        if(mouseOperator.rightClick)
        {
            if(mouseOperator.press)
                logic_event.currentEvent = event_enum.rightclickonspherepress;
            else if(mouseOperator.pressHold)
                logic_event.currentEvent = event_enum.rightclickonspherepresshold;
        }
        else if(mouseOperator.leftClick)
        {
            if(mouseOperator.press)
                logic_event.currentEvent = event_enum.leftclickonspherepress;
            else if(mouseOperator.pressHold)
                logic_event.currentEvent = event_enum.leftclickonspherepresshold;
        }
        else{logic_event.currentEvent = event_enum.none;}
    }

    function actOnEvents()
    {
        switch(logic_event.currentEvent)
        {
            case event_enum.none:{/*do nothing*/break;}
            //if cursor right click on sphere
            case event_enum.rightclickonspherepress:
            {
                menu.popup();
                break;
            }
            //if cursor right click on sphere and held
            case event_enum.rightclickonspherepresshold:
            {
                menu.popup();
                break;
            }
            //if cursor left click on sphere
            case event_enum.leftclickonspherepress:
            {
                break;
            }
            //if cursor left click on sphere and held
            case event_enum.leftclickonspherepresshold:
            {
                break;
            }

            default:{break;}
        }
    }

    function get2DScreenCoordFrom3DWorld_SphereCenter()
    {
        var u,v;

        var viewProjectionMatrix = Qt.matrix4x4();
        viewProjectionMatrix = camera.projectionMatrix.times(camera.viewMatrix);


        //Matrix4 viewProjectionMatrix = projectionMatrix * viewMatrix;
        //transform world to clipping coordinates
        var point3DCamera = Qt.vector3d(0,0,0);
        point3DCamera = viewProjectionMatrix.times(Qt.vector3d(sphere.x,sphere.y,sphere.z));
        //int winX = (int) Math.round((( point3D.getX() + 1 ) / 2.0) *
        //                          width );
        u = Math.round( 0.5*(point3DCamera.x+1)*renderAreaWidth);
        //we calculate -point3D.getY() because the screen Y axis is
        //oriented top->down
        //int winY = (int) Math.round((( 1 - point3D.getY() ) / 2.0) *
        //                          height );
        //
        v = Math.round( 0.5*(1-point3DCamera.y)*renderAreaHeight);

        return Qt.vector2d(u,v);
    }

    function get2DScreenCoordFrom3DWorld_SphereRight()
    {
        var u,v;

        var viewProjectionMatrix = Qt.matrix4x4();
        viewProjectionMatrix = camera.projectionMatrix.times(camera.viewMatrix);


        //Matrix4 viewProjectionMatrix = projectionMatrix * viewMatrix;
        //transform world to clipping coordinates
        var point3DCamera = Qt.vector3d(0,0,0);
        point3DCamera = viewProjectionMatrix.times(Qt.vector3d(sphere.x+sphere.radius,sphere.y,sphere.z));
        //int winX = (int) Math.round((( point3D.getX() + 1 ) / 2.0) *
        //                          width );
        u = Math.round( 0.5*(point3DCamera.x+1)*renderAreaWidth);
        //we calculate -point3D.getY() because the screen Y axis is
        //oriented top->down
        //int winY = (int) Math.round((( 1 - point3D.getY() ) / 2.0) *
        //                          height );
        //
        v = Math.round( 0.5*(1-point3DCamera.y)*renderAreaHeight);

        return Qt.vector2d(u,v);
    }

    function get2DScreenCoordFrom3DWorld_SphereTop()
    {
        var u,v;

        var viewProjectionMatrix = Qt.matrix4x4();
        viewProjectionMatrix = camera.projectionMatrix.times(camera.viewMatrix);


        //Matrix4 viewProjectionMatrix = projectionMatrix * viewMatrix;
        //transform world to clipping coordinates
        var point3DCamera = Qt.vector3d(0,0,0);
        point3DCamera = viewProjectionMatrix.times(Qt.vector3d(sphere.x,sphere.y+sphere.radius,sphere.z));
        //int winX = (int) Math.round((( point3D.getX() + 1 ) / 2.0) *
        //                          width );
        u = Math.round( 0.5*(point3DCamera.x+1)*renderAreaWidth);
        //we calculate -point3D.getY() because the screen Y axis is
        //oriented top->down
        //int winY = (int) Math.round((( 1 - point3D.getY() ) / 2.0) *
        //                          height );
        //
        v = Math.round( 0.5*(1-point3DCamera.y)*renderAreaHeight);

        return Qt.vector2d(u,v);
    }
}
