#ifndef OPENALSOFTAUDIOENGINE_H
#define OPENALSOFTAUDIOENGINE_H


#include "AL/al.h" //header for OpenAL Soft
#include "AL/alc.h" //header for OpenAL Soft
#include "AL/alext.h" //header for OpenAL Soft

#include <QQmlPropertyValueSource>
#include <QQmlProperty> //For QML property
#include <QObject> //for QObject definition
#include <QtMath> //for qAtan, qSqrt
#include <QDebug> //for qDebug

#include <QAudioDecoder>
#include <QAudioBuffer>
#include <QAudioOutput>
#include <QFile>

#include <cstdint>

//class inherits from QQMLPropertValue
class OpenAlSoftAudioEngine : public QObject, public QQmlPropertyValueSource
{
    Q_OBJECT
    //for setting property value to be read in qml
    Q_INTERFACES(QQmlPropertyValueSource)
    //value name qml, READ value to read, WRITE function to set value, NOTIFY signal function
    //property of listener's x position
    Q_PROPERTY(qreal listener_pos_x READ getListenerPositionX WRITE setListenerPositionX NOTIFY listenerPositionXChanged)
    //property of listener's y position
    Q_PROPERTY(qreal listener_pos_y READ getListenerPositionY WRITE setListenerPositionY NOTIFY listenerPositionYChanged)
    //property of listener's z position
    Q_PROPERTY(qreal listener_pos_z READ getListenerPositionZ WRITE setListenerPositionZ NOTIFY listenerPositionZChanged)

public:

    OpenAlSoftAudioEngine(QObject* parent = nullptr);
    ~OpenAlSoftAudioEngine();

    //function to initialize openAl Soft
    bool initOpenALSoft();

    //function to clean up openAL Soft initialization
    void close_openALSoft();

//Listener Position Functions

    void setListenerPositionX(qreal x); //set x position of listener
    qreal getListenerPositionX(); //get x position of listener

    void setListenerPositionY(qreal y); //set y position of listener
    qreal getListenerPositionY(); //get y position of listener

    void setListenerPositionZ(qreal z); //set z position of listener
    qreal getListenerPositionZ(); //get z position of listener

//HRTF

    //function to perform tests for HRTF support
    void testHRTF();
    QString testHRTF_Results; //string variable to write results of test to
    void clear_testHRTFResults();

    //function to invoke from QML side, calls C++ function testHRTF
    Q_INVOKABLE void qmlfunc_testHRTF(){OpenAlSoftAudioEngine::testHRTF();}

    //function to return testHRTF_Results string to QML side
    Q_INVOKABLE QString qml_string_HRTF_result(){return testHRTF_Results;}

    //function to clear testHRTF_Results from QML side
    Q_INVOKABLE void qml_clear_HRTF_result(){OpenAlSoftAudioEngine::clear_testHRTFResults();}

//Sound Playback Related Functions
    //function to take in file path to sound file and load buffer info to ALuint
    void loadSound(const QString& filename);
    //function to invoke from QML side, calls C++ function loadSound
    Q_INVOKABLE void qmlfunc_loadSound(const QString& filename){OpenAlSoftAudioEngine::loadSound(filename);}

    QString loadSound_Results; //string variable to write results of test to
    //function to return testHRTF_Results string to QML side
    Q_INVOKABLE QString qml_string_LoadSound_result(){return loadSound_Results;}
    void clear_LoadSoundResults();
    //function to clear testHRTF_Results from QML side
    Q_INVOKABLE void qml_clear_LoadSound_result(){OpenAlSoftAudioEngine::clear_LoadSoundResults();}

    void playSound();

//Q QML Property Interface
    virtual void setTarget(const QQmlProperty &prop);




//Notifies changes in variables
signals:

    void listenerPositionXChanged(); //notifies listener x position change
    void listenerPositionYChanged(); //notifies listener y position change
    void listenerPositionZChanged(); //notifies listener z position change

//Functions to react to changes in variables
private slots:

private:
    //for q properties
    QQmlProperty m_targetProperty;

    //OpenAL Soft sound setup variables
    ALCdevice* gAudioDevice; //audio device to be used
    ALCcontext* alContext; //context of where audio is played

    //position of Listener
    qreal listener_position_x; //x position
    qreal listener_position_y; //y position
    qreal listener_position_z; //z position

    //buffer to play
    ALuint m_buffer;

    //error flag variable to test if there is error anywhere.
    ALenum test_error_flag;
    void error_check(QString location_str);
};

#endif // OPENALSOFTAUDIOENGINE_H
