require 'sqlite3'

module WibrFake
    class Listing
        def self.ouis_mac(filter=0, show_all=true)
            database = SQLite3::Database.new(File.join(File.dirname(__FILE__), '../DataBase/ouis.db'))
            show_ouis = database.execute("SELECT * FROM ouis_mac")
            puts " " * 2 + "#{'ID' + ' ' * 3} | #{' ' + 'OUIs' + ' ' * 27} | #{'Organization' + ' ' * 6}"
            puts "=" * 8 + "+" + "=" * 34 + "+" + "=" * 20
            salt = " "
            if(show_all==true)
                show_ouis.each {|info_oui|
                    puts " " * 2 + "#{info_oui[0]}" + " " * 4 + salt + "|" + " " * 2 + "#{info_oui[1].ljust(31)} | #{info_oui[2].ljust(8)}"
                }
            else
                if(filter =~ /^[a-z]+$/)
                    puts "Continuara..."              
                elsif(filter =~ /^\d+\.\.\d+$/)
                    start, finish = filter.split('..').map(&:to_i)
                    range = (start..finish)
                    range.each {|r|
                        if(r>=0) and (r<=9)
                            salt_number = 4
                        elsif(r>=10) and (r<=99)
                            salt_number = 3
                        elsif(r>=100) and (r<=999)
                            salt_number = 2
                        elsif(r>=1000) and (r<=9999)
                            salt_number = 1
                        else
                            salt_number = 0
                        end
                        puts " " * 2 + "#{show_ouis[r-1][0]}" + " " * salt_number + salt + "|" + " " * 2 + "#{show_ouis[r-1][1].ljust(31)} | #{show_ouis[r-1][2].ljust(8)}"
                    }
                else
                    filter = filter.to_i
                    if(filter>=0) and (filter<=9)
                        salt_number = 4
                    elsif(filter>=10) and (filter<=99)
                        salt_number = 3
                    elsif(filter>=100) and (filter<=999)
                        salt_number = 2
                    elsif(filter>=1000) and (filter<=9999)
                        salt_number = 1
                    else
                        salt_number = 0
                    end
                    puts " " * 2 + "#{show_ouis[filter-1][0]}" + " " * salt_number + salt + "|" + " " * 2 + "#{show_ouis[filter-1][1].ljust(31)} | #{show_ouis[filter-1][2].ljust(8)}"
                end
            end
        end
    end
end