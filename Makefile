.PHONY: proto tidy verify

proto:
	./gen.sh

tidy:
	go mod tidy

verify: proto tidy
	go test ./...
