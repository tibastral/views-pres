# encoding: utf-8
task :sass do
  cd "stylesheets/sass"
  Dir["*.sass"].each do |e|
    sass = e.clone
    e["sass"] = "css"
    unless File::exists?("../compiled")
      mkdir "../compiled"
    end
    
    sh "sass #{sass} > ../compiled/#{e}"
  end
  cd "../.."
end


task :default => :sass do
  unless File::exists?("build")
    mkdir "build"
  end

  require File.join(File.dirname(__FILE__), 'lib/slide.rb')
  require File.join(File.dirname(__FILE__), 'lib/slidedown.rb')

  # File.open('build/presentation.html', 'w') {|f| f.write(SlideDown.render("src/presentation.md", "#{pwd}/views/import"))}
  res = SlideDown.new("src/presentation.md").render("#{pwd}/views/import")

  # sh "slidedown src/presentation.md -t #{pwd}/views/import" do |e, res|
  #   puts 'ooooo'
  #   puts e
  #   puts 'uuuuu'
  # end
  File.open('build/presentation.html', 'w:UTF-8') {|f| f.write(res) }
  puts "Presentation generated successfully"
  sh "open build/presentation.html"
end

task :clean do
  remove_dir "build", :force => true
end
