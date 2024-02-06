FROM sogimu/astralinux:latest

EXPOSE 5900

RUN rm -r /etc/apt/sources.list /etc/apt/sources.list.d #broken anyway

RUN printf "deb http://dl.astralinux.ru/astra/frozen/2.12_x86-64/2.12.45/repository stable main contrib non-free" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y xvfb fly-all-main

RUN printf "\ndeb http://archive.debian.org/debian stretch main" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y --allow-unauthenticated debian-archive-keyring x11vnc dirmngr locales xserver-xorg-video-dummy

ENV \
  	DEBIAN_FRONTEND="nonintractive" \
  	X11VNC_PASSWORD="password" \
	  DISPLAY=:99.0 

RUN echo 'Section "Device"' >> /etc/X11/xorg.conf \
    && echo '    Identifier  "Configured Video Device"' >> /etc/X11/xorg.conf \
    && echo '    Driver      "dummy"' >> /etc/X11/xorg.conf \
    && echo 'EndSection' >> /etc/X11/xorg.conf \
    && echo >> /etc/X11/xorg.conf \
    && echo 'Section "Monitor"' >> /etc/X11/xorg.conf \
    && echo '    Identifier  "Configured Monitor"' >> /etc/X11/xorg.conf \
    && echo '    HorizSync 31.5-48.5' >> /etc/X11/xorg.conf \
    && echo '    VertRefresh 50-70' >> /etc/X11/xorg.conf \
    && echo 'EndSection' >> /etc/X11/xorg.conf \
    && echo >> /etc/X11/xorg.conf \
    && echo 'Section "Screen"' >> /etc/X11/xorg.conf \
    && echo '    Identifier  "Default Screen"' >> /etc/X11/xorg.conf \
    && echo '    Monitor     "Configured Monitor"' >> /etc/X11/xorg.conf \
    && echo '    Device      "Configured Video Device"' >> /etc/X11/xorg.conf \
    && echo '    DefaultDepth 24' >> /etc/X11/xorg.conf \
    && echo '    SubSection "Display"' >> /etc/X11/xorg.conf \
    && echo '        Depth 24' >> /etc/X11/xorg.conf \
    && echo '        Modes "1024x800"' >> /etc/X11/xorg.conf \
    && echo '    EndSubSection' >> /etc/X11/xorg.conf \
    && echo 'EndSection' >> /etc/X11/xorg.conf

RUN adduser dockeruser

RUN echo "dockeruser:password" | chpasswd #CHANGEME

ADD ./entrypoint.sh /opt/entrypoint.sh

CMD su dockeruser --command /opt/entrypoint.sh
