#!/bin/sh

torrentid=$6
torrentname=$5
torrentpath=$4
torrentrootpath=$3
torrenttracker=$2
torrentcategory=$1

pathextraction=/mnt/downloads/torrent/extracting
pathconversion=/mnt/downloads/torrent/converting

pythonpath=/usr/local/sma/venv/bin/python3
smapath=/usr/local/sma
unrarpath=/unrarall/unrarall

if [ "$torrentcategory" = "bypass" ]; then
	#echo "skipping this since it's in the bypass category"
	exit 0
fi

if [[ -d "$torrentrootpath" ]]; then
	#echo "$torrentrootpath" + " is a directory"
	mkdir "$pathextraction/$torrentname"
	mkdir "$pathconversion/$torrentname"
	"$unrarpath" -v -o "$pathextraction/$torrentname" "$torrentrootpath"
	extracted=$?
	wait $!
	if [ $extracted -eq 0 ]; then
		if [[ -n $(find "$pathextraction/$torrentname" -type f -size +50M) ]]; then
			"$pythonpath" "$smapath/qBittorrentPostProcess.py" "$torrentcategory" "$torrenttracker" "$pathextraction/$torrentname" "$pathextraction/$torrentname" "$torrentname" "$torrentid"
		else
			"$pythonpath" "$smapath/qBittorrentPostProcess.py" "$torrentcategory" "$torrenttracker" "$torrentrootpath" "$torrentpath" "$torrentname" "$torrentid"
		fi
	else
		"$pythonpath" "$smapath/qBittorrentPostProcess.py" "$torrentcategory" "$torrenttracker" "$torrentrootpath" "$torrentpath" "$torrentname" "$torrentid"
	fi
	rm -rf "$pathextraction/$torrentname"
elif [[ -f "$torrentpath" ]]; then
	#echo "$torrentpath" + " is a file"
	"$pythonpath" "$smapath/qBittorrentPostProcess.py" "$torrentcategory" "$torrenttracker" "$torrentrootpath" "$torrentpath" "$torrentname" "$torrentid"
fi

exit 0
