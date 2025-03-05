module WibrFake
    class UUID
        def self.session(iface)
            mac = WibrFake::Mac.show(iface, 0).gsub(':', '')
            time = Time.now.to_s.split('-').join.split(':').join.split(' ').join
            number = 3.times.map{"%02x" % rand(256)}.join
            id = iface + "-" + time + "-" + number + "-" + mac
            return id
        end
    end
end