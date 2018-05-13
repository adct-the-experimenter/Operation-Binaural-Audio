#ifndef INTERFACE3DENGINE_H
#define INTERFACE3DENGINE_H

#include <Qt3DRender/qcamera.h>
#include <Qt3DCore/qentity.h>
#include <Qt3DRender/qcameralens.h>
#include <Qt3DRender>
#include <Qt3DInput>
#include <Qt3DExtras>

#include <QQmlPropertyValueSource>
#include <QQmlProperty> //For QML property
#include <QObject> //for QObject definition
#include <QtMath> //for qAtan, qSqrt
#include <QDebug> //for qDebug

class Interface3DEngine : public QObject, public QQmlPropertyValueSource
{
    Q_OBJECT
    //for setting property value to be read in qml
    Q_INTERFACES(QQmlPropertyValueSource)
public:
    Interface3DEngine(QObject* parent = nullptr);
    ~Interface3DEngine();

    //Q QML Property Interface
    virtual void setTarget(const QQmlProperty &prop);

    void initView();


//Notifies changes in variables
signals:


//Functions to react to changes in variables
private slots:


private:
    //for qml properties
    QQmlProperty m_targetProperty;

};

#endif // QT3DINTERFACEENGINE_H
