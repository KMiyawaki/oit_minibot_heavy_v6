# Minibot v6

このREADMEは [Minibot v3 README](https://github.com/KMiyawaki/oit_navigation_minibot_03) を参考に構築しています。

[中之島ロボットチャレンジ](https://www.nakanoshima-rc.jp/)用小型ロボットの説明。

## 必要なソフト・ハード

使用するロボットが搭載しているソフト・ハードに応じてインストールすること。

- RPLIDAR A3 : [rplidar](http://wiki.ros.org/rplidar)　`main` `2d_main`
- Velodyne VLP-16 : [Getting Started with the Velodyne VLP16](http://wiki.ros.org/velodyne/Tutorials/Getting%20Started%20with%20the%20Velodyne%20VLP16) `main`
- ZED2 : [Getting Started with ROS and ZED](https://www.stereolabs.com/docs/ros/) `main`
- Intel RealSense D435i : [Installing the packages](https://github.com/IntelRealSense/librealsense/blob/master/doc/distribution_linux.md) `main`

- テレオペや地図作成にはジョイスティックが必要。

## インストール

```shell
$ git clone https://github.com/KMiyawaki/oit_minibot_heavy_v6.git
$ cd ~/catkin_ws && catkin_make
```

**[RPLIDAR A3](https://www.slamtec.com/en/Lidar/A3)を上部に搭載しているロボットを使用する場合以下のコマンドを実行すること**

```shell
$ roscd oit_minibot_heavy_v6
$ git branch
  2d_main
* main    # 頭に * のついているのが現在のブランチ
$ git checkout 2d_main # もし、mainの頭に * がついている場合実行
$ git branch
* 2d_main
  main
```

## ロボットの起動方法

それぞれに[`rosbag`](https://qiita.com/srs/items/f6e2c36996e34bcc4d73)の記録ありとなしのバージョンがある。 
記録された`rosbag`は`~/.ros`ディレクトリに保存される。なお、容量が足りない場合は外付けSDカードに保存するように編集すること。参考：[rosbag Commandline](http://wiki.ros.org/rosbag/Commandline)
`rosbag`を記録した場合は**必ず`stop_recording.sh`を実行し、記録を停止してからもともとのスクリプトを終了させること**。

```shell
$ cp ~/catkin_ws/src/oit_minibot_heavy_v6/desktop_scripts/*.sh ~/ # ホームディレクトリに起動用の各種スクリプトを配置
$ cd
$ ls *.sh | grep -v stop
mapping.sh           # ジョイスティックでロボットを操作しながら地図を作成する。
mapping_rosbag.sh    # 同上。ただし、rosbagを同時に記録する。
navigation.sh        # 作成した地図でロボットを自律移動させる。
navigation_rosbag.sh # 同上。ただし、rosbagを同時に記録する。
teleop.sh            # ジョイスティックでロボットを操作する。
teleop_rosbag.sh     # 同上。ただし、rosbagを同時に記録する。
record_rosbag.sh     # rosbagを記録する。
stop_recording.sh    # rosbagの記録を停止する。
```

### テレオペの起動

ジョイスティックでロボットを操作する。搭載ソフト・ハードも起動する。ロボットの動作テストに用いる。  
下記２つのスクリプトのどちらかを起動する。

```shell
$ cd
# rosbag の記録あり
$ ./teleop_rosbag.sh
# rosbag の記録なし
$ ./teleop.sh
```

`rosbag`の記録ありを起動した場合、前項で記述した通りスクリプトを終了させる前に`stop_recording.sh`を必ず実行すること。  
具体的には新たなターミナルを開き、以下のコマンドを実行する。

```shell
$ cd
$ ./stop_recording.sh
```

その後、テレオペを終了する。具体的には`./teleop_rosbag.sh`もしくは`./teleop.sh`を起動したターミナルで`Ctrl+C`を押してスクリプトを終了させる。  
この起動時の手順は以降のスクリプトでも同様である。

### SLAMによる地図作成

ジョイスティックでロボットを操作する。搭載ソフト・ハードも起動する。ロボット周囲の環境の地図を作成する。

```shell
$ cd
# rosbag の記録あり
$ ./mapping_rosbag.sh
# rosbag の記録なし
$ ./mapping.sh
```

地図作成が終わったら、RVizや`./mapping_rosbag.sh`もしくは`./mapping.sh`を**絶対に終了させずに**別ターミナルで以下のコマンドを実行して地図を保存する。

```shell
$ roscd oit_minibot_heavy_v6/maps
$ rosrun map_server map_saver -f test # test の部分は任意の地図名をつける。
[ INFO] [1615598383.151895509]: Waiting for the map
[ INFO] [1615598383.434767477]: Received a 480 X 736 map @ 0.050 m/pix
[ INFO] [1615598383.434929931]: Writing map occupancy data to sample_01.pgm
[ INFO] [1615598383.449962167]: Writing map occupancy data to sample_01.yaml
[ INFO] [1615598383.450234503]: Done
```

保存ができたら、RVizや`./mapping_rosbag.sh`もしくは`./mapping.sh`を終了させてよい。ただし、前述したように、`./mapping_rosbag.sh`の場合は事前に`stop_recording.sh`を実行しておかなければならない。  
その後地図ファイルの有無を確認する。

```shell
$ roscd oit_minibot_heavy_v6/maps
$ ls
test.pgm  test.yaml
```

### ナビゲーション

前項で保存した地図を使いナビゲーション（自律移動）をする。  
まず、起動用スクリプトを編集し、ナビゲーションに使いたい地図の名前を入力しておく。  
ここで、地図の名前とは前項で保存した地図ファイル名から拡張子を取り除いたものである。

- 例：`test.pgm  test.yaml`の場合、地図名は`test`。

```shell
$ cd 
$ gedit navigation.sh # 任意のテキストエディタで開く。emacsでもOK。
#!/bin/bash
cd `rospack find oit_minibot_heavy_v6`/launch/real
roslaunch navigation.launch map_name:=test # map_name:=以降の文字をナビゲーション時に利用する地図名に変更する。
$ gedit navigation_rosbag.sh
#!/bin/bash
cd `rospack find oit_minibot_heavy_v6`/launch/real
roslaunch navigation.launch map_name:=test rosbag:=true # 同上
```

自己位置推定、ゴール指定方法はこれまで通り。

## rosbagを使う

`rosbag`の記録ありのスクリプトを起動した場合は、ロボット操作中のセンサデータが`rosbag`ファイルに記録されている。スクリプト停止前に指示通り`stop_recording.sh`を実行していたならば、`~/.ros`ディレクトリに拡張子`bag`のファイルができているはずである。
`rosbag`の各種コマンドラインは[rosbag Commandline](http://wiki.ros.org/rosbag/Commandline)を参考にすること。

```shell
$ cd ~/.ros
$ ls *.bag
2021-07-18-10-23-48.bag # ファイル名は rosbag を記録した日時によって変わる。
```

ここで、拡張子`bag`のファイルが見当たらないとき、以下のコマンドを実行して拡張子`active`のファイルが存在した場合は`rosbag`の完全な記録に失敗している。

```shell
$ cd ~/.ros
$ ls *.active
2021-07-18-10-23-48.bag.active
```

原因は`stop_recording.sh`を実行していないか、実行後にロボットの起動スクリプトの停止が早すぎたかのいずれかである。`active`ファイルを完全な`bag`ファイルに変換することも不可能ではないが、時間がかかるので、あきらめてもう一度きちんと記録しなおすこと。
`rosbag`の容量によっては少し保存されるまでに時間がかかるので`rosbag`に拡張子`active`が付かなくなるまで待つこと。

`bag`ファイルを再生するスクリプトはこのパッケージに用意してある。再生のために`bag`ファイルを移動させる。

```shell
$ cd ~/.ros
$ mv 2021-07-18-10-23-48.bag ~/catkin_ws/src/oit_minibot_heavy_v6/bags # このロボットで採取した bag ファイルでないといけない。
```

### rosbagを再生する

以下のコマンドで、`bag`ファイルを再生する。

```shell
$ roscd oit_minibot_heavy_v6/launch
$ ./play_rosbag.sh ../bags/2021-07-18-10-23-48.bag
... logging to /home/{user name}/.ros/log/2870ef18-ef78-11eb-ace6-a87eeaadf0a7/roslaunch-user-19115N-CLR-7031.log
Checking log directory for disk usage. This may take a while.
Press Ctrl-C to interrupt
Done checking log file disk usage. Usage is <1GB.

xacro: in-order processing became default in ROS Melodic. You can drop the option.
started roslaunch server http://user-19115N-CLR:34791/

SUMMARY
========

PARAMETERS
 * /robot_description: <?xml version="1....
```

再生は`Ctrl+C`で終了できる。

```shell
^C[playbag-3] killing on exit
[rviz-2] killing on exit
[rosout-1] killing on exit
[master] killing on exit
shutting down processing monitor...
... shutting down processing monitor complete
done
```

再生時に`rate:=数値`オプションをつけることで、早送り／スロー再生が可能である。

```shell
$ ./play_rosbag.sh ../bags/2021-07-18-10-23-48.bag rate:=2 # 倍速。rate:=0.5 でスロー再生。
```

### rosbagから地図を作成する

以下のコマンドで`bag`ファイルを再生し、記録されたセンサデータから地図を作成する。

```shell
$ roscd oit_minibot_heavy_v6/launch
$ ./play_rosbag_gmapping.sh ../bags/2021-07-18-10-23-48.bag 
... logging to /home/{user name}/.ros/log/5269cbfe-ef79-11eb-ace6-a87eeaadf0a7/roslaunch-user-19115N-CLR-8285.log
Checking log directory for disk usage. This may take a while.
Press Ctrl-C to interrupt
Done checking log file disk usage. Usage is <1GB.

xacro: in-order processing became default in ROS Melodic. You can drop the option.
started roslaunch server http://user-19115N-CLR:46557/

SUMMARY
========

PARAMETERS
 * /robot_description: <?xml version="1....
 * /rosdistro: melodic
```

前項同様、再生時に`rate:=数値`オプションをつけることで、早送り／スロー再生が可能である。ただし、あまりに早送りすぎると地図が歪む。停止方法も前項と同様である。
