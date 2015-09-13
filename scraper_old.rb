require 'rest-client'

thread = 0
last_page = 0
unless thread > 0 && last_page >= 1
  print "Enter a thread number: "
  thread = gets.chomp
  print "Enter last page in thread: "
  last_page = gets.chomp.to_i
end

f1 = File.new("/home/drew/Desktop/Supertall_#{thread}.html", 'w')
i = 1
while i <= last_page do
  f2 = File.new("/home/drew/Desktop/test.html", 'w')
  page = (RestClient.get "http://www.skyscrapercity.com/showthread.php", :params => {:t => thread, :page => i}).encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  f2.puts(page)
  f2.close
  f2 = File.open("/home/drew/Desktop/test.html", 'r')
  f1.puts(f2.grep(/jpg|jpeg/).reject {|l| l =~ /skyscrapercity/}.reject {|r| r =~ /Avatar/})
  f2.close
  puts (((i+0.0)/last_page)*100.0).to_i.to_s + "%"
  i += 1
end
f1.close
