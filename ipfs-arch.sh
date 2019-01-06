#!/bin/sh

case $(arch) in
    x86_64)
        echo amd64 ;;
    aarch64)
        echo arm ;;
    *)
        exit 1 ;;
esac
