# Argument check
if [ $# -lt 1 ]; then
            echo "Usage: suspend_until HH:MM"
                exit
fi

# Check whether specified time today or tomorrow
DESIRED=$((`date +%s -d "$1"`))
NOW=$((`date +%s`))
if [ $DESIRED -lt $NOW ]; then
DESIRED=$((`date +%s -d "$1"` + 24*60*60))
fi

sudo rtcwake -l -m disk -t $DESIRED &

#sudo rtcwake -m disk -l -t $(date +%s -d ‘tomorrow 08:30’)
