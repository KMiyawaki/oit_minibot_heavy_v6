define lds ranger
(
  sensor(                         
    range [ 0.0  30.0 ]
    fov 270.25
    samples 1081
  )
  # generic model properties
  color "black"
  size [ 0.06 0.06 0.09 ]
  update_interval 25
)

define YDLIDAR_X4 ranger
(
  sensor(                         
    range [ 0.0  11.0 ]
    fov 360
    samples 720
  )
  # generic model properties
  color "black"
  size [ 0.05 0.05 0.1 ]
  update_interval 25
)

define robot position
(
  size   [0.61 0.38 1.12]
  origin [-0.045 0 0 0] # 0.26 - 0.61 / 2 
  gui_nose 1
  drive "diff"
  # LRF1
  lds(pose [ 0.1 0 -0.12 0 ])
  #YDLIDAR_X4(pose [ -0.0475 0 0 0 ])
  # https://answers.ros.org/question/66124/stage-velocity-limit/
  # [ xmin xmax ymin ymax zmin zmax amin amax ]				
  velocity_bounds     [-1.2 1.2 0 0 0 0 -270 270]
  acceleration_bounds [-1.2 1.2 0 0 0 0 -270 270]
  update_interval 25 # http://rtv.github.io/Stage/group__model.html
)
