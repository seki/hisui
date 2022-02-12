require 'json'
require 'fileutils'

module Hisui
  module Config
    module_function
    FName = File.expand_path("~/.hisui.json")

    def load
      JSON.parse(File.read(FName)) rescue {}
    end

    def update(key, value)
      hash = load.update({key => value})
      File.write(FName + '.tmp', JSON.pretty_generate(hash) + "\n")
      FileUtils.mv(FName + '.tmp', FName)
      hash
    end
  end
end

if __FILE__ == $0
  pp Hisui::Config::load
  key = ARGV.shift || exit
  value = ARGV.shift || exit
  Hisui::Config::update(key, value)
  pp Hisui::Config::load
end