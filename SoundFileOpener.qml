import QtQuick 2.0
import QtQuick.Dialogs 1.2

Item
{
    id:root

    property string mode //mode, open file or create file
    property string sound_filepath:"" //filepath of sound file
    property string write_data_filepath:"" //filepath of file to write data to

    FileDialog
    {
          id: fileDialog
          folder: shortcuts.home
          visible: false
          selectMultiple: false
          title: fileDialog.getTitle()
          selectExisting: fileDialog.getOpenFileTrueBool() //if true, open file, if false, create file
          property string tempFilePath //path of file

          onAccepted:
          {
              fileDialog.tempFilePath = fileDialog.fileUrl;

              if(root.mode === "OpenSoundFile")
              {
                  openSoundFile();
              }
              else if(root.mode == "CreateWriteFile")
              {
                  createWriteFile();
              }
          }
          onRejected:
          {
              //console.log("Canceled")
          }

          function getOpenFileTrueBool()
          {
              if(root.mode === "OpenSourceCircuit"){return true;}
              else if(root.mode === "CreateWriteFile"){return false;}

              return false; //return false by default
          }

          function getTitle()
          {
              if(root.mode === "OpenSoundFile"){return "Please choose a file with .wav or other sound file extension";}
              else if(root.mode === "CreateWriteFile"){return "Please create a new file.";}
              return ""; //return empty string by default
          }
    }

    MessageDialog
    {
        id: messageDialog

        function show(caption)
        {
            messageDialog.text = caption;
            messageDialog.open();
        }
    }

    function open(){fileDialog.open()}

    function openSoundFile()
    {

        var extensionCheck = fileDialog.tempFilePath.substring(fileDialog.tempFilePath.length - 4,
                                                               fileDialog.tempFilePath.length);
        //check if filePath has .wav extension
        //if extension is .wav
        if(extensionCheck === ".wav" ||
           extensionCheck === ".mp3")
        {
            //take out the file://
            fileDialog.tempFilePath = fileDialog.tempFilePath.replace("file://","");

            //assign to source_circuit_filepath
            sound_filepath = fileDialog.tempFilePath;

            console.log("Sound file is "+sound_filepath);
        }
        else
        {
           messageDialog.show("Choose a file that ends with '.wav','.mp3' !\n");
        }

    }

    function createWriteFile()
    {

        //take out the file://
        fileDialog.tempFilePath = fileDialog.tempFilePath.replace("file://","");

        //add .raw extension
        fileDialog.tempFilePath = fileDialog.tempFilePath + ".raw";

        //assign to write_sim_data_filepath
        write_data_filepath = fileDialog.tempFilePath;

        console.log("file created is "+write_data_filepath );
    }

}
