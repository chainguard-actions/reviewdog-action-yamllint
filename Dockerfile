FROM python:3.14.7-alpine3.24

ENV REVIEWDOG_VERSION=v0.21.0

RUN wget -q -O /tmp/install-reviewdog.sh https://raw.githubusercontent.com/reviewdog/reviewdog/fd59714416d6d9a1c0692d872e38e7f8448df4fc/install.sh \
    && sh /tmp/install-reviewdog.sh -b /usr/local/bin/ ${REVIEWDOG_VERSION} \
    && rm /tmp/install-reviewdog.sh
RUN apk --no-cache add git

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
