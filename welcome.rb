require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'nmap/xml'

known_macs = YAML::load_file "settings.yml"
known_macs ||= {}
found_macs = []
Nmap::XML.new('scan.xml') do |xml|
  xml.each_host do |host|
    host.each_address do |address|
      found_macs << address.addr if address.type == :mac 
    end
  end
end

cmds = []
found_macs.each do |mac|
  if known_macs[mac]
    known = known_macs[mac]
    if known[:addr].upcase == mac.upcase && known[:notify] == true
      if (DateTime.now - known[:last_seen]) > Rational(1,24 * 60)
        cmds << "notify-send -t 1000 -u low '#{known[:name]} is home'"
      end
      known_macs[mac][:last_seen] = DateTime.now
    end
  else
    puts "Adding " + mac
    known_macs[mac] = {
      :name => '',
      :addr => mac,
      :last_seen => DateTime.now,
      :notify => false
    }
  end
end if found_macs.any?

File.open(File.dirname(__FILE__) + "/settings.yml", "w+") do |file|
  file.write known_macs.to_yaml
end

cmds.each do |cmd|
  puts exec(cmd)
end
