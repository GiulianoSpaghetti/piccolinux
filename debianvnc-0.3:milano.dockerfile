FROM debian:latest
LABEL maintainer "Giulio Sorrentino <gsorre84@gmail.com>"
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y locales
RUN echo "LC_ALL=it_IT.UTF-8" >> /etc/environment
RUN echo "it_IT.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen it_IT.UTF8
RUN apt-get update && apt-get install -y \
	task-xfce-desktop \
	tightvncserver
ENTRYPOINT [ "bash" ]
