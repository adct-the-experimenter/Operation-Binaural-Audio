TEMPLATE = app

QT += qml quick 3dcore 3drender 3dinput 3dextras 3dquickextras gui

CONFIG += c++11 g

SOURCES += main.cpp \
    openalsoftaudioengine.cpp \
    interface3dengine.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += openalsoftaudioengine.h \
    interface3dengine.h

LIBS += -L/usr/local/lib -lopenal -lsndfile

INCLUDEPATH += $$_PRO_FILE_PWD_/include
DEPENDPATH += $$_PRO_FILE_PWD_/include

