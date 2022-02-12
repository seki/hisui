require 'tempfile'
require_relative 'conf'

module Hisui
  module AWSRoute53
    module_function
    def valid_appname?(app)
      /^\w+$/ =~ app ? true : false
    end

    def make_batch_json(conf, app)
      raise "invalid appname [#{app}]" unless valid_appname?(app)
      cname = [app, conf['domain']].join('.')
      hostname = conf['hostname']
<<EOS
{
  "Comment": "CREATE cname record ",
  "Changes": [{
  "Action": "CREATE",
              "ResourceRecordSet": {
                          "Name": "#{cname}",
                          "Type": "CNAME",
                          "TTL": 300,
                        "ResourceRecords": [{ "Value": "#{hostname}"}]
}}]
}
EOS
    end
  end
end

if __FILE__ == $0
  require 'json'
  require 'pp'
  conf = Hisui::Config::load

  appname = ARGV.shift

  file = Tempfile.open("cname") do |fp|
    fp.write(Hisui::AWSRoute53::make_batch_json(conf, appname))
    fp
  end

  system("aws route53 change-resource-record-sets --hosted-zone-id #{conf['hosted-zone-id']} --change-batch file://#{file.path}")
end