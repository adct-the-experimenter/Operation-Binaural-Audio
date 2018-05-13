#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml> //for qmlRegisterType

#include <QQuickView>
#include <Qt3DQuickExtras/qt3dquickwindow.h>

#include <QSurfaceFormat>

#include "openalsoftaudioengine.h"
#include "interface3dengine.h"

int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    /*
     * Might use later if needed.
    QSurfaceFormat format;
    if (QOpenGLContext::openGLModuleType() == QOpenGLContext::LibGL) {
        format.setVersion(2, 3);
        format.setProfile(QSurfaceFormat::CoreProfile);
    } else if (QOpenGLContext::openGLModuleType() == QOpenGLContext::LibGLES) {
        format.setVersion(2, 0);
    }


    format.setAlphaBufferSize(0);
    format.setDepthBufferSize(0);
    format.setRenderableType(QSurfaceFormat::OpenGL);
    format.setSamples(4);
    format.setStencilBufferSize(0);
    format.setSwapBehavior(QSurfaceFormat::TripleBuffer);
    format.setSwapInterval(0);

    QSurfaceFormat::setDefaultFormat(format);
    */

    QQmlApplicationEngine engine;


    //Register OpenAlSoftAudioEngine C++ class derived from QObject as qml type
    //call with import com.vas.openalsoftaudioengine 1.0
    //qmlName is OpenAlSoftAudioEngine
    qmlRegisterType<OpenAlSoftAudioEngine>("com.vas.openalsoftaudioengine", 1, 0, "OpenAlSoftAudioEngine");
    qmlRegisterType<Interface3DEngine>("com.vas.interface3dengine", 1, 0, "Interface3DEngine");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
