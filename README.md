# docker-truestudio
  
Debian docker with installed TrueSTUDIO from Atollic for headless builds.  

# Executing a TrueSTUDIO build

The primary utility of this image is to execute builds defined in a TrueSTUDIO project. The following is an example of how to run a build on a directory with a TrueSTUDIO project at the base.

```
docker build --tag=docker-truestudio .

cd /path/to/code/base

docker run --volume $(pwd):/data --workdir /data --rm docker-truestudio /opt/Atollic_TrueSTUDIO_for_STM32_9.1.0/ide/TrueSTUDIO --launcher.suppressErrors -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -importAll . -build all
```

Build results will be available on the host machine as they would if TrueSTUDIO build was executed from the GUI.

# License
  
Dockerfile is under MIT license.  
TrueSTUDIO from Atollic is under their license.  

# Additional Notes
Additional packages required are `libgtk2.0-0 libxtst6 xvfb`

Without `xvfb`, the headless TrueSTUDIO may not start properly. Need to do this before running the build command. 
```
    Xvfb :1 -ac -screen 0 1024x768x8 &
    export DISPLAY=:1
```

(For more details see https://developer.ibm.com/answers/questions/364224/encountered-a-few-issues-in-using-rule-designer-he/)

Relative paths do not work well with `headless.sh`, so it is easier to call `/opt/Atollic_TrueSTUDIO_for_STM32_9.1.0/ide/TrueSTUDIO` directly using the flags in `headless.sh`. 
