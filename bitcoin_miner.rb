#
#
require 'g_card_status'

t = GCardStatus.new
t.ati_setup 
t.ati_config("--pplib-cmd 'set fanspeed 0 65'")
t.ati_config("--pplib-cmd 'get fanspeed 0'")
t.ati_config("--odsc=800,750")
t.ati_persist
# all status parameters are now set

t.start_proc

while true
  t.ati_config("--odgt")
  puts t.inspect
  if t.temp.to_i > 73
    # 3 things to try
    # 1) increase fanspeed (max is 75%)
    # 2) decrease core clock (min is 700)
    # 3) run a video
    # 4) if none of these work, shut down the minor temporarily
    # (then start it back up in 5 min)
    if t.fan_speed.to_i < 75
      newfanspeed = t.fan_speed.to_i + 2
      t.ati_config("--pplib-cmd 'set fanspeed 0 #{newfanspeed}'")
      t.ati_config("--pplib-cmd 'get fanspeed 0'")
      next
    end
    if t.core_clock.to_i >= 800
      new_clock = t.core_clock.to_i - 50
      t.ati_config("--odsc=#{new_clock},750")
      next
    end
    # run a video if it's not already running
    
    if t.pid
      t.stop_proc
    else
      t.start_proc
    end
    
  end
      
  sleep(30)
  
end

   
