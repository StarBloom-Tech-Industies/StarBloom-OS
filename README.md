Docker Command: docker run --rm -it -v "%cd%":/root/env myos-buildenv

make build-x86_64
qemu-system-x86_64 -cdrom dist/x86_64/kernel.iso   