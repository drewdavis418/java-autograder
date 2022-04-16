FROM gradescope/auto-builds:ubuntu-20.04
ARG jdk_version=openjdk-17-jdk
ARG kotlin_version=1.6.20

# Add OpenJDK PPA and install JDK
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update && apt-get -y install ${jdk_version}

# Install Kotlin compiler
RUN wget -O /kotlin.zip \
  https://github.com/JetBrains/kotlin/releases/download/v${kotlin_version}/kotlin-compiler-${kotlin_version}.zip
RUN unzip /kotlin.zip -d /usr/lib/kotlin
RUN ln -s /usr/lib/kotlin/kotlinc/bin/kotlinc /usr/local/bin/kotlinc

COPY . /autograder/source/
COPY ./run_autograder /autograder/

# Remove extra autograder script
RUN rm /autograder/source/run_autograder
