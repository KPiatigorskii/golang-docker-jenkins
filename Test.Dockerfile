ARG BASE_TAG
ARG IMAGE_NAME
FROM ${IMAGE_NAME}-base:${BASE_TAG}

RUN go install github.com/jstemmer/go-junit-report/v2@latest

CMD go test ./app/... -v 2>&1 | go-junit-report > report/report.xml