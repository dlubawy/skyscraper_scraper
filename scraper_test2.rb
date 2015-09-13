require 'rest-client'
# tmp = temporary directory for storing html scrape files
tmp = "/var/tmp/"
# save = directory to store sorted html scrapes
save = "/home/drew/skyscraper_scraper/"

thread = 0
last_page = 0
unless thread > 0 && last_page >= 1
  print "Enter a thread number: "
  thread = gets.chomp
  print "Enter last page in thread: "
  last_page = gets.chomp.to_i
end

f = File.new("#{save}Supertall_#{thread}.html", 'w')
i = 1
while i <= last_page do
  f2 = File.new("#{tmp}test2.html", 'w')
  # initial scrape of entire html page
  page = (RestClient.get "http://www.skyscrapercity.com/showthread.php", :params => {:t => thread, :page => i}).encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  # put page into tmp file for easy sorting
  f2.puts(page)
  f2.close
  #f2 = File.open("#{tmp}test2.html", 'r')
  #f3 = File.new("#{tmp}test3.html", 'w')
  # sort for jpg, jpeg, and png files while rejecting avatars and banners
  #f3.puts(f2.grep(/jpg|jpeg|png/).reject {|l| l =~ /skyscrapercity/}.reject {|r| r =~ /Avatar/})
  #f2.close
  #f3.close
  # final sort to get rid of junk html and only return <img/> tags
  File.open("#{tmp}test2.html") do |file|
    file.each_line do |line|
      if line =~ /(http.*\.jpg|http.*\.jpeg|http.*\.png)/
        f.puts(line.match(/(http.*\.jpg|http.*\.jpeg|http.*\.png)/))
      end
    end
  end
  # puts percentage for how many pages scraped
  puts (((i+0.0)/last_page)*100.0).to_i.to_s + "%"
  i += 1
end
# delete temporary files
File.delete("#{tmp}test2.html")
File.delete("#{tmp}test3.html")
