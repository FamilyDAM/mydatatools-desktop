FROM gitpod/workspace-full-vnc:latest
SHELL ["/bin/bash", "-c"]
ENV ANDROID_HOME=$HOME/androidsdk \
    FLUTTER_VERSION=3.13.6-stable \
    QTWEBENGINE_DISABLE_SANDBOX=1
ENV PATH="$HOME/flutter/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"


# Install Open JDK for android and other dependencies
USER root
RUN bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh && \
    sdk install java 17.0.7-tem && \
    sdk default java 17.0.7-tem"     
ENV JAVA_HOME=/home/gitpod/.sdkman/candidates/java/current 


# Install  other dependencies
RUN install-packages \
        libgtk-3-dev \
        libnss3-dev \
        fonts-noto \
        fonts-noto-cjk 

        
# Install libsecret to get flutter_secure_storage working
# RUN apt-get update -y && \
# apt-get install --no-install-recommends -y libsecret-1-0 git && \
# apt-get install -y libjsoncpp-dev

RUN apt-get install libsecret-1-dev
RUN apt-get install -y libjsoncpp

# Make some changes for our vnc client and flutter chrome
# RUN sed -i 's|resize=scale|resize=remote|g' /opt/novnc/index.html \
#     && _gc_path="$(command -v google-chrome)" \
#     && rm "$_gc_path" && printf '%s\n' '#!/usr/bin/env bash' \
#                                         'chromium --start-fullscreen "$@"' > "$_gc_path" \
#     && chmod +x "$_gc_path" 

# Insall flutter and dependencies
USER gitpod
RUN wget -q "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}.tar.xz" -O - \
    | tar xpJ -C "$HOME" \
    && _file_name="commandlinetools-linux-8092744_latest.zip" && wget "https://dl.google.com/android/repository/$_file_name" \
    && unzip "$_file_name" -d $ANDROID_HOME \
    && rm -f "$_file_name" \
    && mkdir -p $ANDROID_HOME/cmdline-tools/latest \
    && mv $ANDROID_HOME/cmdline-tools/{bin,lib} $ANDROID_HOME/cmdline-tools/latest \
    && yes | sdkmanager "platform-tools" "build-tools;31.0.0" "platforms;android-31" \
    && flutter precache && for _plat in web linux-desktop; do flutter config --enable-${_plat}; done \
    && flutter config --android-sdk $ANDROID_HOME \
    && yes | flutter doctor --android-licenses \
    && flutter doctor

