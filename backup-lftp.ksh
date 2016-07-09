#!/bin/ksh

        print checking for previous backup processes...\\c
        [[ -n `pgrep lftp` ]] && print PREVIOUS FTP REVERSE MIRROR IS STILL RUNNING \
                && print "$tmp" && exit 1
        print done

        print calculating needed space...\\c
        needed=`du -s /data/backup/ | awk '{print $1}'`
        print $needed

        avail=$(df -h )
        print available space is $avail

        (($avail <= $needed)) && print NO SPACE LEFT ON REMOTE SITE && exit 1

        lftp -f "
open FTP_SERVER
user FTP_USER FTP_PASS
lcd /data/backup
mirror -R -c --delete-first --parallel=2
bye
"
#date=`date +%Y-%m-%d-`
#lftp: rm -rf /
#lftp: mput -c ${date}*
