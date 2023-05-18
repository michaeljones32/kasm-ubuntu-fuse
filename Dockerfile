FROM kasmweb/core-ubuntu-jammy:latest
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########


RUN apt-get update && apt-get upgrade -y 
# && apt-get install -y \
#     fuse \
#     libfuse2 \
#     && rm -rf /var/lib/apt/lists/*


COPY BambuStudio/install_bambuStudio.sh $INST_SCRIPTS/bambuStudio/install_bambuStudio.sh
RUN bash $INST_SCRIPTS/bambuStudio/install_bambuStudio.sh  && rm -rf $INST_SCRIPTS/bambuStudio/

COPY BambuStudio/custom_startup.sh $STARTUPDIR/custom_startup.sh
RUN chmod +x $STARTUPDIR/custom_startup.sh
RUN chmod 755 $STARTUPDIR/custom_startup.sh


# Update the desktop environment to be optimized for a single application
RUN cp $HOME/.config/xfce4/xfconf/single-application-xfce-perchannel-xml/* $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
RUN cp /usr/share/extra/backgrounds/bg_kasm.png /usr/share/extra/backgrounds/bg_default.png
RUN apt-get remove -y xfce4-panel

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000