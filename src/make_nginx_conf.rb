require_relative 'conf'

def make_nginx_conf(conf, app, port)
  server_name = [app, conf['domain']].join('.')
  <<~EOS
  server {
    listen       80;
    server_name  #{server_name};

    proxy_http_version 1.1;
    location / {
        root   /usr/share/nginx/html;
        proxy_pass http://localhost:#{port};
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
  }
  EOS
end

if __FILE__ == $0
  conf = Hisui::Config::load
  appname = ARGV.shift || exit
  port = ARGV.shift || exit
  fname = "#{appname}.conf"
  File.write(fname, make_nginx_conf(conf, appname, port))
  system("sudo mv #{fname} /etc/nginx/conf.d/")
  system("sudo nginx -t")
end
