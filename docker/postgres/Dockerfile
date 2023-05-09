FROM postgres:13.3

RUN apt-get update
RUN sed --in-place --regexp-extended "s/(\/\/)(archive\.ubuntu)/\1au.\2/" /etc/apt/sources.list && \
	apt-get update && apt-get upgrade --yes
RUN apt-get install -qq -y less vim tmux curl wget nano mc ssh pv
