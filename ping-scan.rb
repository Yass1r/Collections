
#!/usr/bin/env ruby

require 'ipaddr'
require 'net/ping'
require 'colorize'
require 'net/ftp'

def help()
 puts "    _   __     __     _____".yellow
 puts "   / | / /__  / /_   / ___/_________ _____  ____  ___  _____".yellow
 puts "  /  |/ / _ \/ __/   \__ \/ ___/ __ `/ __ \/ __ \/ _ \/ ___/".yellow
 puts " / /|  /  __/ /_    ___/ / /__/ /_/ / / / / / / /  __/ /".yellow
 puts "/_/ |_/\___/\__/   /____/\___/\__,_/_/ /_/_/ /_/\___/_/".yellow
 puts " "
 puts "[+] ruby ipaddr.rb <ip-address> <netmask>".yellow

 puts "[+] example: ruby ipaddr.rb ".red + "192.168.1.200".yellow + " 24".green
 exit
end

def up?(host)
  check = Net::Ping::External.new(host)
  check.timeout=0.1
  check.ping?
end

ips, ms = ARGV
if ips.nil? == true then help end
if ms.nil? == true then help end
host = IPAddr.new(ips.to_s)
mask = host.mask(ms.to_i) 
ipList=[]

puts " "
puts "[+] This script is a part of APT Course / Level 2 ".green + "By @yasirfaraj".red
puts "[+] Scanning network: ".green + "#{mask}".yellow
for ip in mask.to_range
  if up?(ip.to_s) == true then
    ipList.push(ip)
    puts "#{ip} :".red + " UP".yellow
  end
end
puts "[+] Host(s): ".green + "#{ipList.count}".yellow
for ip in ipList
  ftp_stat = system("nc -n -z -w 1 #{ip} 21")
  if ftp_stat == true then
    puts "Connecting to FTP ".green + "#{ip}".yellow
    puts "  [-] Connected Successfully.".yellow
    ftp = Net::FTP.new(ip.to_s)
    puts "  [-] ".red + ftp.last_response.red
    ftp.close
  end
end

