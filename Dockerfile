FROM drydock/u14jav:prod

ADD . /u14sca

RUN /u14sca/install.sh

# Temporary workaround to ensure letsencrypt certs are installed
RUN sudo /u14sca/install-letsencrypt-in-jdk.sh $(/usr/libexec/java_home -v '1.8*')