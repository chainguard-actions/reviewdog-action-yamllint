FROM python:alpine

ENV REVIEWDOG_VERSION=v0.20.2

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}
RUN apk --no-cache add git

RUN pip install "pyyaml<=5.3.1" "yamllint"

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
