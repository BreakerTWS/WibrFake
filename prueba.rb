require "packetfu"

iface = PacketFu::Capture.new(:iface => 'wlo1', :start => true)

#iface.each_packet {|p|
#	puts p
#}

iface = iface.next
puts iface
