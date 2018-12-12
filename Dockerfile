FROM golang:1-alpine AS go-build

ENV etcd_version v3.3.4
RUN apk --no-cache add git build-base

RUN go get github.com/coreos/etcd/etcdctl \
	&& cd /go/src/github.com/coreos/etcd/ \
	&& git checkout -b $etcd_version \
	&& CFLAGS="-Wno-error" go install .

RUN ls -lah /go/bin

FROM golang:1-alpine

WORKDIR /
COPY --from=go-build /go/bin/etcdctl /

ENTRYPOINT ["/etcdctl"]
