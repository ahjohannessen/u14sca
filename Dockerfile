FROM drydock/u14:prod

ADD . /u14sca

RUN /u14sca/install.sh