FROM gradescope/auto-builds:ubuntu-20.04
ARG jdk_version=openjdk-15-jdk

# Add OpenJDK PPA and install JDK
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update && apt-get -y install ${jdk_version}

COPY . /autograder/source/
COPY ./run_autograder /autograder/

# Remove extra autograder script
RUN rm /autograder/source/run_autograder
