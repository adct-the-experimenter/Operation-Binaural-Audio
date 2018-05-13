#ifndef OPENALSOFTAUDIOENGINE_H
#define OPENALSOFTAUDIOENGINE_H


#include "AL/al.h" //header for OpenAL Soft
#include "AL/alc.h" //header for OpenAL Soft
#include "AL/alext.h" //header for OpenAL Soft

#ifdef Q_OS_WIN
#include <windows.h> // for Sleep
#endif

#include "sndfile.h"

#include <QQmlPropertyValueSource>
#include <QQmlProperty> //For QML property
#include <QObject> //for QObject definition
#include <QtMath> //for qAtan, qSqrt
#include <QDebug> //for qDebug


#include <QFile>

#include <cstdint>
#include <vector>
#include <map>

/*	This will be the length of the buffer used to hold frames while
**	we process them.
*/
#define		BUFFER_LEN	1024

/* libsndfile can handle more than 6 channels but we'll restrict it to 2. */
#define		MAX_CHANNELS	2


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

    //property of listener's orientation
    //property of listener's face vector
    Q_PROPERTY(qreal listener_forw_x READ getListenerForwardX WRITE setListenerForwardX NOTIFY listenerForwardXChanged)
    Q_PROPERTY(qreal listener_forw_y READ getListenerForwardY WRITE setListenerForwardY NOTIFY listenerForwardYChanged)
    Q_PROPERTY(qreal listener_forw_z READ getListenerForwardZ WRITE setListenerForwardZ NOTIFY listenerForwardZChanged)
    //property of listener's up vector
    Q_PROPERTY(qreal listener_upvec_x READ getListenerUpX WRITE setListenerUpX NOTIFY listenerUpXChanged)
    Q_PROPERTY(qreal listener_upvec_y READ getListenerUpY WRITE setListenerUpY NOTIFY listenerUpYChanged)
    Q_PROPERTY(qreal listener_upvec_z READ getListenerUpZ WRITE setListenerUpZ NOTIFY listenerUpZChanged)
public:

    OpenAlSoftAudioEngine(QObject* parent = nullptr);
    ~OpenAlSoftAudioEngine();

    //function to initialize openAl Soft
    bool initOpenALSoft();

    //function to clean up openAL Soft initialization
    void close_openALSoft();

//Listener Position Functions, functions for moving listener position

    void setListenerPositionX(qreal x); //set x position of listener
    qreal getListenerPositionX(); //get x position of listener
    void setListenerPositionY(qreal y); //set y position of listener
    qreal getListenerPositionY(); //get y position of listener
    void setListenerPositionZ(qreal z); //set z position of listener
    qreal getListenerPositionZ(); //get z position of listener

//Listener Orientation Functions, functions for moving listener head up,down,left,right

    void setListenerForwardX(qreal x); //set x of forward of listener
    qreal getListenerForwardX(); //get x of forward of listener
    void setListenerForwardY(qreal y); //set y of forward of listener
    qreal getListenerForwardY(); //get y of forward of listener
    void setListenerForwardZ(qreal z); //set z of forward of listener
    qreal getListenerForwardZ(); //get z of forward listener

    void setListenerUpX(qreal x); //set x of up of listener
    qreal getListenerUpX(); //get x of up of listener
    void setListenerUpY(qreal y); //set y of up of listener
    qreal getListenerUpY(); //get y of up of listener
    void setListenerUpZ(qreal z); //set z of up of listener
    qreal getListenerUpZ(); //get z of up of listener

//Audio Source functions, functions for creating object that make sound and moving these objects
    struct AudioSourceInfo
    {
        QString name; //name of source object
        ALuint source; //what holds info of source object
        ALuint genIndex; //id for alGenBuffers
        std::vector <float> position_vector;
    };

    void createAudioSource(QString &source_name);
    void bindBufferToAudioSource(QString &source_name, ALuint buffer);

    void setAudioSourcePositionX(QString &source_name,qreal x); //set x position of listener
    qreal getAudioSourcePositionX(QString &source_name); //get x position of listener
    void setAudioSourcePositionY(QString &source_name,qreal y); //set y position of listener
    qreal getAudioSourcePositionY(QString &source_name); //get y position of listener
    void setAudioSourcePositionZ(QString &source_name,qreal z); //set z position of listener
    qreal getAudioSourcePositionZ(QString &source_name); //get z position of listener

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

    //function to play sound from a buffer already loaded from using loadSound(filename)
    void playSound();

    void playSoundSource(QString& source_name);

    //cleanup functions
    void deleteSound();
    void deleteSource(QString &source_name);

//Q QML Property Interface
    virtual void setTarget(const QQmlProperty &prop);




//Notifies changes in variables
signals:

    void listenerPositionXChanged(); //notifies listener x position change
    void listenerPositionYChanged(); //notifies listener y position change
    void listenerPositionZChanged(); //notifies listener z position change

    void listenerForwardXChanged(); //notifies listener forward x change
    void listenerForwardYChanged(); //notifies listener forward y change
    void listenerForwardZChanged(); //notifies listener forward z change

    void listenerUpXChanged(); //notifies listener up x change
    void listenerUpYChanged(); //notifies listener up y change
    void listenerUpZChanged(); //notifies listener up z change

//Functions to react to changes in variables
private slots:

private:
    //for qml properties
    QQmlProperty m_targetProperty;

    //OpenAL Soft sound setup variables
    ALCdevice* gAudioDevice; //audio device to be used
    ALCcontext* alContext; //context of where audio is played

    //position of Listener
    std::vector <float> listener_position_vector;
    enum POSITION_INDEX { X=0,Y=1,Z=2 };

    //orientation of Listener
    std::vector<float> listener_orientation_vector; //vector to hold values of listener orientation
    //first 3 values are forward vector xyz , last 3 values are up vector xyz
    //enum to help set orientation vector
    enum ORIENTATION_INDEX { FORWARD_X=0,FORWARD_Y=1,FORWARD_Z=2,
                                                 UP_X=3, UP_Y=4, UP_Z=5 };

    //Vector to contain audio sources
    std::vector <AudioSourceInfo> m_sources;

    //Vector to contain buffers to play
    std::vector <ALuint> m_buffers;

    //registry of audio sources
    std::map <QString, AudioSourceInfo*> reg_audio_sources;
    //libsndfile file handle for input file
    SNDFILE	*infile;

    //error flag variable to test if there is error anywhere regarding OpenAL Soft.
    ALenum test_error_flag;
    void openal_error_check(QString location_str);
};

#endif // OPENALSOFTAUDIOENGINE_H
