#!/bin/sh

test -e  ~/go/bin/qrbase45tool|| \
	go install github.com/confiks/qrbase45tool@latest

for i in 01 02 03 04 05 06 06 07 09 
do
	openssl rand 500 > $i.bin

	~/go/bin/qrbase45tool -e -i $i.bin -o $i.base45
	cat $i.bin |  base64 > $i.base64

	# comparison: Q is 25% error correction - closest to aztec 23%
	qrencode -l Q -m 0 -s 1 -8 -o  $i.qr8.png -r $i.bin
	qrencode -l Q -m 0 -s 1 -i -o  $i.qr2.png -r $i.base45

	# 23% error correction is the default.
	cat $i.bin | ~/bin/aztec-png -b 0 -s 1 -f - $i.az.png
done

