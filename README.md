# hisui
tools for my linux box

## todo

sudo systemctl enable app-powo
sudo systemctl start app-powo
sudo systemctl status app-powo

sudo cp default.conf.backup powo.conf
ホスト名変更
sudo nginx -t
sudo systemctl reload nginx
sudo certbot --nginx -d powo.druby.work

proxy_pass http://localhost:8001;


## remove letsencrypt

certbot revoke --cert-path /etc/letsencrypt/archive/${YOUR_DOMAIN}/cert1.pem

## periodic

git clone
vi run.rb

sudo cp powo3.conf periodic.conf
sudo vi periodic.conf
sudo nginx -t
sudo systemctl reload nginx

sudo certbot --nginx -d periodic.druby.work

## pgtips

cd hisui/src
ruby add_cname.rb pgtips
cd pgtips
ruby ../hisui/src/make_systemd_service.rb pgtips 8003
sudo systemctl enable app-pgtips
sudo systemctl start app-pgtips
sudo systemctl status app-pgtips
ruby ../hisui/src/make_nginx_conf.rb pgtips 8003
sudo systemctl reload nginx
sudo certbot --nginx -d pgtips.druby.work

## not

ruby ../hisui/src/add_cname.rb not
ruby ../hisui/src/make_systemd_service.rb not 8005

sudo /usr/local/bin/gem install webpush
sudo cp app-not.service /etc/systemd/system/app-not.service 
sudo systemctl enable app-not
sudo systemctl start app-not
sudo systemctl status app-not
ruby ../hisui/src/make_nginx_conf.rb not 8005
sudo systemctl reload nginx
sudo certbot --nginx -d not.druby.work
