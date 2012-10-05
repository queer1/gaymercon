module LevelCalculator
  # exp curve from the original Final Fantasy
  # http://faqs.ign.com/articles/386/386613p1.html
  
  LEVELS = Hash[[[1, 0],
  [2, 28],
  [3, 84],
  [4, 196],
  [5, 392],
  [6, 700],
  [7, 1148],
  [8, 1764],
  [9, 2576],
  [10, 3612],
  [11, 4900],
  [12, 6468],
  [13, 8344],
  [14, 10556],
  [15, 13132],
  [16, 16100],
  [17, 19488],
  [18, 23324],
  [19, 27636],
  [20, 32452],
  [21, 37800],
  [22, 43708],
  [23, 50204],
  [24, 57316],
  [25, 65072],
  [26, 73500],
  [27, 82628],
  [28, 92484],
  [29, 103096],
  [30, 114492],
  [31, 126700],
  [32, 139748],
  [33, 153664],
  [34, 168476],
  [35, 184212],
  [36, 200900],
  [37, 218568],
  [38, 237244],
  [39, 256956],
  [40, 277732],
  [41, 299600],
  [42, 322588],
  [43, 346724],
  [44, 372036],
  [45, 398552],
  [46, 426300],
  [47, 455300],
  [48, 484299],
  [49, 513299],
  [50, 542298],
  [51, 571298],
  [52, 600297],
  [53, 629297],
  [54, 658296],
  [55, 687296],
  [56, 716295],
  [57, 745295],
  [58, 774294],
  [59, 803294],
  [60, 832293],
  [61, 861293],
  [62, 890292],
  [63, 919292],
  [64, 948291],
  [65, 977291],
  [66, 1006290],
  [67, 1035290],
  [68, 1064289],
  [69, 1093289],
  [70, 1122288],
  [71, 1151288],
  [72, 1180287],
  [73, 1209287],
  [74, 1238286],
  [75, 1267286],
  [76, 1296285],
  [77, 1325285],
  [78, 1354284],
  [79, 1383284],
  [80, 1412283],
  [81, 1441283],
  [82, 1470282],
  [83, 1499282],
  [84, 1528281],
  [85, 1557281],
  [86, 1586280],
  [87, 1615280],
  [88, 1644279],
  [89, 1673279],
  [90, 1702278],
  [91, 1731278],
  [92, 1760277],
  [93, 1789277],
  [94, 1818276],
  [95, 1847276],
  [96, 1876275],
  [97, 1905275],
  [98, 1934274],
  [99, 1963274]]
  ]
  class << self
    def levels
      LEVELS
    end
  
    def level(xp)
      return 99 if xp > 1963274
      prev = 1
      levels.each {|level, required| return prev if xp < required; prev = level }
    end
  
    def progress(xp)
      lvl = level(xp)
      diff = LEVELS[lvl+1] - LEVELS[lvl]
      percent = (xp - LEVELS[lvl]) / 100.0
    end
  end
  
end