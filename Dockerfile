FROM alpine:latest
COPY build/merritt /bin/app
ADD build/ui /bin/ui
WORKDIR /bin
ENTRYPOINT ["/bin/merritt"]
EXPOSE 8080
