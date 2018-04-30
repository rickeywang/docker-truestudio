# docker-truestudio
  
Debian docker with installed TrueSTUDIO from Atollic for headless builds.  

# Executing a TrueSTUDIO build

The primary utility of this image is to execute builds defined in a TrueSTUDIO project. The following is an example of how to run a build on a directory with a TrueSTUDIO project at the base.

```
docker build --tag=docker-truestudio .

cd /path/to/code/base

docker run --volume $(pwd):/data --workdir /data --rm docker-truestudio /opt/Atollic_TrueSTUDIO_for_STM32_9.0.0/ide/TrueSTUDIO --launcher.suppressErrors -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -importAll . -build all
```

Build results will be available on the host machine as they would if TrueSTUDIO build was executed from the GUI.

# License
  
Dockerfile is under MIT license.  
TrueSTUDIO from Atollic is under their license.  

