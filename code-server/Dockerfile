FROM docker.io/codercom/code-server:debian

COPY setup.sh .
RUN ./setup.sh && rm setup.sh setup.log
ENTRYPOINT ["/usr/bin/entrypoint.sh", "--bind-addr", "0.0.0.0:8080", "."]
