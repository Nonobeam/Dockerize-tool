# GODZILLA #
## So what is Godzilla ##
This will simplify your work by build image and run local docker container for your project. <br>
This version is light weight, nothing more to config, ease to use. <br>

> [!WARNING]
> From now, this only build for Spring-boot project only. But if you like it and want to have more version like this for other language, contact me through my email or pull a request.

## How to use ##
First of all, this is just a built tool using sh so that basically it is not doing any magic stuff. You still need to build your source code, running docker in your machine, login your docker im terminal, and any other required setup.

### For first time, just use this ###
``./dockerize.sh --dir=${DIRECTORY_SOURCE}`` <br>
By default, the built image will be named godzilla-image and container will run on port 8080. <br>
```${DIRECTORY_SOURCE}```: Where you store your jar file

### For more custom, use this one ###

``./dockerize.sh --dir=${DIRECTORY_SOURCE} --name=${IMAGE_NAME} --port=${PORT} --option=${BUILD|RUN}`` <br>
<br>
```--dir```: Your source directory <br>
```--name```: Your image name (Choose the name base on what you want) <br>
```--containerport```: Your container port<br>
```--hostport```: Choose which port you want for your Docker container <br>
```--option```: Choose option BUILD | RUN. BUILD will only build docker image, no more. RUN will BUILD docker image then RUN the container.