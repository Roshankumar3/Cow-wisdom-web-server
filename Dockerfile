FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y fortune cowsay netcat && \
    apt-get clean

COPY wisecow.sh /wisecow.sh
RUN chmod +x /wisecow.sh

EXPOSE 4499

CMD ["/wisecow.sh"]
