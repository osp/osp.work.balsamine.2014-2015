#! /usr/bin/bash
for i in $(seq 1 40);
do
 curl http://osp.constantvzw.org:9999/p/balsa2014-2015-flyers/export/txt > content.html
 sleep 15
done



