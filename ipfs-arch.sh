#!/bin/sh

case $(arch) in
    x86_64)
        echo amd64 ;;
    aarch64)
    armv6l)
        echo arm ;;
    *)
        exit 1 ;;
esac
