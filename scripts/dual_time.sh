#!/usr/bin/env bash

belfast_label="Belfast"
belfast_tz="Europe/London"
newyork_label="New York"
newyork_tz="America/New_York"
if [ "$1" = "military" ]; then
  time_fmt="%H:%M"
else
  time_fmt="%I:%M %p"
fi

belfast_time=$(env TZ=$belfast_tz /bin/date +"${belfast_label} ${time_fmt}")
newyork_time=$(env TZ=$newyork_tz /bin/date +"${newyork_label} ${time_fmt}")

echo "$belfast_time | $newyork_time"
