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
    id: root
    property real x: 20
    property real y: 0
    property real z: 0
    property real radius: 3
    property color color: "silver"
    property Transform transform: sphereTransform

    components: [ sphereMesh, material, sphereTransform ]

    function placeSphere(newX,newY,newZ)
    {
        x = newX;
        y = newY;
        z = newZ;
    }

    SphereMesh
    {
        id: sphereMesh
        radius: root.radius
    }

    Transform
    {
        id: sphereTransform
        matrix:
        {
            var m = Qt.matrix4x4();
            m.rotate(0.0, Qt.vector3d(0, 1, 0));
            m.translate(Qt.vector3d(x, y, z));
            return m;
        }
    }

    GoochMaterial
    {
        id: material
        cool: "black"
        warm:root.color
        specular:"black"
    }
}



