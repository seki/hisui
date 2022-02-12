require 'aws-sdk-route53'
require_relative 'conf'

module Hisui
  module AWSRoute53
    module_function
    def valid_appname?(app)
      /^\w+$/ =~ app ? true : false
    end

    def create_cname_for_app(conf, app)
      it = Aws::Route53::Client.new
      resp = it.change_resource_record_sets(make_change_batch(conf, app))
    end

    def make_change_batch(conf, app)
      raise "invalid appname [#{app}]" unless valid_appname?(app)
      cname = [app, conf['domain']].join('.')
      hostname = conf['hostname']
      {
        change_batch: {
          changes: [
            {
              action: "CREATE", 
              resource_record_set: {
                name: cname, 
                resource_records: [
                  {
                    value: hostname, 
                  }, 
                ], 
                ttl: 300, 
                type: "CNAME", 
              }, 
            }, 
          ], 
          comment: "Web server for #{cname}", 
        }, 
        hosted_zone_id: conf['hosted-zone-id'], 
      }
    end
  end
end

if __FILE__ == $0
  require 'json'
  require 'pp'
  conf = Hisui::Config::load

  appname = ARGV.shift

  it = Hisui::AWSRoute53::create_cname_for_app(conf, appname)
  pp it.to_h
end