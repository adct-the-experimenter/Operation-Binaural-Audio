#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml> //for qmlRegisterType

#include "openalsoftaudioengine.h"


int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    //Register OpenAlSoftAudioEngine C++ class derived from QObject as qml type
    //call with import com.vas.openalsoftaudioengine 1.0
    //qmlName is OpenAlSoftAudioEngine
    qmlRegisterType<OpenAlSoftAudioEngine>("com.vas.openalsoftaudioengine", 1, 0, "OpenAlSoftAudioEngine");
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
