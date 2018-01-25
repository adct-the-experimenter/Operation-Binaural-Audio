#include "openalsoftaudioengine.h"

OpenAlSoftAudioEngine::OpenAlSoftAudioEngine(QObject *parent)
{
    //Initialize sound setup variables to point to nullptr
    gAudioDevice = nullptr;
    alContext = nullptr;

    //initialize listener position
    listener_position_x = 0;
    listener_position_y = 0;
    listener_position_z = 0;

    OpenAlSoftAudioEngine::initOpenALSoft();

    //clear testHRTF Results string
    testHRTF_Results.clear();
    loadSound_Results.clear();
}

OpenAlSoftAudioEngine::~OpenAlSoftAudioEngine()
{
    OpenAlSoftAudioEngine::close_openALSoft();
}

bool OpenAlSoftAudioEngine::initOpenALSoft()
{
    //function to initialize openal soft
    bool success = true;

    //use default audio device
    gAudioDevice = alcOpenDevice(NULL);
    if(gAudioDevice == nullptr){success = false;}

    //create context
    alContext = alcCreateContext(gAudioDevice, NULL);
    if(alContext == nullptr){success = false;}
    else{alcMakeContextCurrent(alContext);}

    //define listener, what is hearing the sound

    //For 2D sound, we tell openAL soft that listener
    alListener3f(AL_POSITION, 0, 0, 0);//is at the origin
    alListener3f(AL_VELOCITY, 0, 0, 0);//is not moving in 3d space
    alListener3f(AL_ORIENTATION, 0, 0, -1);//Orientation is default

    if(success){qDebug() << " Open AL Soft Initialized! \n";}
    else{qDebug() << "OpenAL Soft was unable to initialize! \n";}

    return success;

}

void OpenAlSoftAudioEngine::close_openALSoft()
{
    alcDestroyContext(alContext);	//delete context
    alcCloseDevice(gAudioDevice);	//close device
}

//Listener Position Functions

void OpenAlSoftAudioEngine::setListenerPositionX(qreal x)
{
    //if x is different from listener position x
    if(listener_position_x != x)
    {
        listener_position_x = x; //assign x to listener position x
        emit listenerPositionXChanged(); //emit signal change for listener position x
        alListener3f(AL_POSITION, x, listener_position_y, listener_position_z);//change OpenAL Soft internal listener position
    }
}

qreal OpenAlSoftAudioEngine::getListenerPositionX(){return listener_position_x;}

void OpenAlSoftAudioEngine::setListenerPositionY(qreal y)
{
    //if y is different from listener position y
    if(listener_position_y != y)
    {
        listener_position_y = y; //assign y to listener position y
        emit listenerPositionYChanged(); //emit signal change for listener position y
        alListener3f(AL_POSITION, listener_position_x, y, listener_position_z);//change OpenAL Soft internal listener position
    }
}

qreal OpenAlSoftAudioEngine::getListenerPositionY(){return listener_position_y;}

void OpenAlSoftAudioEngine::setListenerPositionZ(qreal z)
{
    //if z is different from listener position z
    if(listener_position_z != z)
    {
        listener_position_z = z; //assign z to listener position z
        emit listenerPositionZChanged(); //emit signal change for listener position z
        alListener3f(AL_POSITION, listener_position_x, listener_position_y, z);//change OpenAL Soft internal listener position
    }
}

qreal OpenAlSoftAudioEngine::getListenerPositionZ(){return listener_position_z;}

//HRTF
//define functions for hrtf
static LPALCGETSTRINGISOFT alcGetStringiSOFT;
static LPALCRESETDEVICESOFT alcResetDeviceSOFT;

void OpenAlSoftAudioEngine::testHRTF()
{

    //call after initOpenALSoft

    ALCint hrtf_state; //state of hrtf, enabled or disabled
    ALCint num_hrtf; //variable for number of hrtf avaiable

    /* Check for HRTF support. */

    if(!alcIsExtensionPresent(gAudioDevice, "ALC_SOFT_HRTF"))
    {
        //fprintf(stderr, "Error: ALC_SOFT_HRTF not supported\n");
        qDebug() << " Error: ALC_SOFT_HRTF not supported! \n"; //output error to console
        testHRTF_Results.append("Error: ALC_SOFT_HRTF not supported! \n");
    }
    else
    {
        qDebug() << " ALC_SOFT_HRTF is supported! \n";
        testHRTF_Results.append(" ALC_SOFT_HRTF is supported! \n");

        /* Define a macro to help load the function pointers. */
        #define LOAD_PROC_alcGetStringiSOFT(d, x)  ((x) = (LPALCGETSTRINGISOFT)alcGetProcAddress((d), #x))
            LOAD_PROC_alcGetStringiSOFT(gAudioDevice, alcGetStringiSOFT);
        #undef LOAD_PROC__alcGetStringiSOFT

        #define LOAD_PROC_alcResetDeviceSOFT(d, x)  ((x) = (LPALCRESETDEVICESOFT)alcGetProcAddress((d), #x))
            LOAD_PROC_alcResetDeviceSOFT(gAudioDevice, alcResetDeviceSOFT);
        #undef LOAD_PROC_alcResetDeviceSOFT

        /* Check for the AL_EXT_STEREO_ANGLES extension to be able to also rotate
         * stereo sources.
         */
        ALboolean has_angle_ext = alIsExtensionPresent("AL_EXT_STEREO_ANGLES");

        //printf("AL_EXT_STEREO_ANGLES%s found\n", has_angle_ext?"":" not");
        if(has_angle_ext )
        {
            qDebug() << "AL_EXT_STEREO_ANGLES support found. Stereo sources can be rotated. \n";
            testHRTF_Results.append("AL_EXT_STEREO_ANGLES support found. Stereo sources can be rotated. \n");
        }
        else
        {
            qDebug() << "AL_EXT_STEREO_ANGLES support not found. Stereo sources cannot be rotated. \n";
            testHRTF_Results.append("AL_EXT_STEREO_ANGLES support not found. Stereo sources cannot be rotated. \n");
        }


        /* Enumerate available HRTFs, and reset the device using one. */
        alcGetIntegerv(gAudioDevice, ALC_NUM_HRTF_SPECIFIERS_SOFT, 1, &num_hrtf);
        if(!num_hrtf)
        {
            qDebug() << "No HRTFs found. \n";
            testHRTF_Results.append("No HRTFs found. \n");
        }
        else
        {
            ALCint i; //iterator

            qDebug() << "Available HRTFs:\n";
            testHRTF_Results.append("Available HRTFs:\n");
            for(i = 0;i < num_hrtf;i++)
            {
                const ALCchar *name = alcGetStringiSOFT(gAudioDevice, ALC_HRTF_SPECIFIER_SOFT, i);

                qDebug() << name << " " << i << "\n";
                testHRTF_Results.append(name);
                testHRTF_Results.append(" ");
                testHRTF_Results.append(i);
                testHRTF_Results.append(" \n");
            }
        }

        /* Check if HRTF is enabled, and show which is being used. */
        alcGetIntegerv(gAudioDevice, ALC_HRTF_SOFT, 1, &hrtf_state);
        if(!hrtf_state)
        {
            qDebug() << "HRTF not enabled!\n";
            testHRTF_Results.append("HRTF not enabled!\n");
        }
        else
        {
            const ALchar *name = alcGetString(gAudioDevice, ALC_HRTF_SPECIFIER_SOFT);
            //printf("HRTF enabled, using %s\n", name);
            qDebug() << "HRTF enabled, using " << name << "\n";
            testHRTF_Results.append("HRTF enabled, using ");
            testHRTF_Results.append(name);
            testHRTF_Results.append("\n");
        }
    }
}


void OpenAlSoftAudioEngine::clear_testHRTFResults(){testHRTF_Results.clear();}

//function to set target
void OpenAlSoftAudioEngine::setTarget(const QQmlProperty &prop){ m_targetProperty = prop; }

void OpenAlSoftAudioEngine::playSound()
{
}

void OpenAlSoftAudioEngine::loadSound(const QString& filename)
{
    /*Code modified from Chris Robinson's OpenAL-Soft example for loading sound file.
      Uses QT_Multimedia QAudioDecoder .*/
    ALuint buffer; //temporary variable to sture buffer
    ALenum err; //variable for error flag
    ALenum format; //ALenum variable for format of sound sample e.g. 8-bit 16-bit
    uint32_t slen; //Size in bytes of the buffer data.
	
	QAudioDecoder audioDecoder; //audio decoder to extract data from audio sample
    QAudioBuffer audioBufferRead; //variable  to store audio buffer that is read from audio decoder

    /* Open the audio file */
    //Check if file exists
	if(QFile::exists(filename))
	{
		audioDecoder.setSourceFilename(filename); //input filename to audio decoder
        audioDecoder.start();
        while(!audioDecoder.bufferAvailable()){} //wait for buffer to be available for reading
        if(audioDecoder.bufferAvailable()){audioBufferRead = audioDecoder.read();} //read buffer
        if(!audioBufferRead.isValid())
        {
            loadSound_Results.append("The audio buffer read is not valid! \n");
            loadSound_Results.append(audioDecoder.errorString());
            return;
        }
	}
	else
	{
		loadSound_Results.append("Could not open file. File does not exist! \n");
		return;
	}
	
	
    /* Get the sound format, and figure out the OpenAL format */

    //check for number of channels
    //if audio sample has only 1 channel
    if(audioBufferRead.format().channelCount() == 1)
    {
		//if audio sample format is 8-bit, set ALenum format variable to mono 8-bit
        if(audioBufferRead.format().sampleSize() == 8){format = AL_FORMAT_MONO8;}
        //if audio sample format is 16-bit, set ALenum format variable to mono 8-bit
        else if(audioBufferRead.format().sampleSize() == 16){format = AL_FORMAT_MONO16;}
		//else notify that sample format is unsupported        
		else
        {
            //fprintf(stderr, "Unsupported sample format: 0x%04x\n", sample->actual.format);
			loadSound_Results.append("Unsupported sample format for mono. Must be 8-bit or 16-bit");
			return;
        }
    }
    //else if audio sample has 2 channels
    else if(audioBufferRead.format().channelCount() == 2)
    {
		//if audio sample format is 8-bit, set ALenum format variable to stereo 8-bit
        if(audioBufferRead.format().sampleSize() == 8){format = AL_FORMAT_STEREO8;}
		//if audio sample format is 16-bit, set ALenum format variable to stereo 8-bit
        else if(audioBufferRead.format().sampleSize() == 16){format = AL_FORMAT_STEREO16;}
		//else notify that sample format is unsupported         
		else
        {
            //fprintf(stderr, "Unsupported sample format: 0x%04x\n", sample->actual.format);
			loadSound_Results.append("Unsupported sample format for stereo. Must be 8-bit or 16-bit.");            
            return;
        }
    }
	//else notify that channel count is unsupported 
    else
    {
        //fprintf(stderr, "Unsupported channel count: %d\n", sample->actual.channels);
        loadSound_Results.append("Unsupported channel count. Must be 1 or 2 channels.\n");
        return;
    }

    /* Decode the whole audio stream to a buffer. */
    
    slen = audioBufferRead.byteCount(); //get size of data in bytes
	//if sample buffer is null or size of buffer data is zero, notify of error
    if(!audioBufferRead.isValid() || slen == 0)
    {
        loadSound_Results.append("Failed to read audio from file.\n");
        return;
    }

    /* Buffer the audio data into a new buffer object, then free the data and
     * close the file. */
    buffer = 0; //initialize temp buffer
    alGenBuffers(1, &buffer);//request 1 buffer
	//set buffer data
    alBufferData(buffer, format, audioBufferRead.data(), slen, audioBufferRead.format().sampleRate() );

    /* Check if an error occured, and clean up if so. */
    err = alGetError();
    if(err != AL_NO_ERROR)
    {
        //fprintf(stderr, "OpenAL Error: %s\n", alGetString(err));
		loadSound_Results.append("OpenAL Error: ");
		loadSound_Results.append(alGetString(err));
		loadSound_Results.append("\n");
        if(buffer && alIsBuffer(buffer)){alDeleteBuffers(1, &buffer);}
        return;
    }

    m_buffer = buffer; //assign temp buffer to m_buffer
}

void OpenAlSoftAudioEngine::clear_LoadSoundResults(){loadSound_Results.clear();}
