require_relative "conf"

def make_systemd_service(appname)
  script = Dir.pwd + '/run.rb'

  <<~EOS
  [Unit]
  Description = #{appname} daemon

  [Service]
  ExecStart = /usr/local/bin/ruby #{script}
  Restart = always
  Type = simple
  User = #{ENV['USER']}

  [Install]
  WantedBy = multi-user.target
  EOS
end

if __FILE__ == $0
  appname = ARGV.shift || exit
  fname = "app-#{appname}.service"
  File.write(fname, make_systemd_service(appname))
  system("sudo cp #{fname} /etc/systemd/system/")
end