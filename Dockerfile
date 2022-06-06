FROM gradescope/auto-builds:ubuntu-20.04
ARG jdk_version=openjdk-17-jdk
ARG kotlin_version=1.6.20

# Add OpenJDK PPA and install JDK
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update && apt-get -y install ${jdk_version}

# Install Kotlin compiler
RUN wget -O /kotlin.zip \
  https://github.com/JetBrains/kotlin/releases/download/v${kotlin_version}/kotlin-compiler-${kotlin_version}.zip
RUN mkdir -p /usr/lib/kotlin && \
  ln -s . /usr/lib/kotlin/kotlinc && \
  unzip -d /usr/lib/kotlin/ /kotlin.zip && \
  rm /usr/lib/kotlin/kotlinc /kotlin.zip
RUN ln -s /usr/lib/kotlin/bin/kotlinc /usr/bin/kotlinc

COPY src /
