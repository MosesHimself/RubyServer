def function
  ['one', 'two']
end

puts "Start"
message = "(HG)how you doin?"
if message.start_with?("(")
  message.each_char do |chr|
    if chr == ')'
      puts 'found that bitch'
      break
    else
      puts chr
    end
  end
end
puts "End"
