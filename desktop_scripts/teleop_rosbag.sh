#!/bin/bash
cd `rospack find oit_minibot_heavy_v6`/launch/real
roslaunch teleop.launch rosbag:=true
