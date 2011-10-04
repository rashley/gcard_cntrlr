class GCardStatus
  attr_accessor :temp, :mem_clock, :core_clock, :pid, :fan_speed

  def start_proc(*params)
    `export LD_LIBRARY_PATH=/usr/local/ati-stream-sdk-v2.3-lnx64/lib/x86_64/:$LD_LIBRARY_PATH; . ~/.miner.txt > ~/.bmout.txt 2>&1 &`
    @pid = $?.pid
  end

  def stop_proc
    `kill -9 #{@pid}`
  end

  def ati_setup
    `aticonfig --od-enable`
  end

  def ati_persist
    `aticonfig --odcc`
  end
  
  def ati_config(*params)
    ati_results = `aticonfig #{params}`
    ati_results =~ /(\d{2}\.\d+) C.*/
    @temp = $1 if $1
    ati_results =~ /(\d*)\%/
    @fan_speed = $1 if $1
    ati_results =~ /New Core Peak\s*\:\s+(\d*)/
    @core_clock = $1 if $1
    ati_results =~ /New Memory Peak\s*\:\s+(\d*)/
    @mem_clock = $1 if $1
  end
  
end

