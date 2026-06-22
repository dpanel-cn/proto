# proto

Shared protobuf contracts for DPanel services.

## Layout

```text
service.proto
src/container
src/image
src/network
src/volume
gen/container
gen/image
gen/network
gen/volume
gen/go
```

`service.proto` defines the gRPC services used by master and agent.
`src/*` defines protobuf payloads for SDK commands sent between master and agent.
`gen/container`, `gen/image`, `gen/network`, and `gen/volume` contain generated SDK Go packages.
`gen/go` contains generated Go packages for `service.proto`.

After installing `protoc`, run `make proto` once to regenerate `gen`.

## Generate

Install the protobuf tools:

```bash
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```

Then regenerate Go files:

```bash
make proto
```

or:

```bash
./gen.sh
```
