# encoding: utf-8
require 'nokogiri'
require 'makers-mark'
require 'haml'

class SlideDown
  attr_accessor :stylesheets, :title
  attr_reader :classes
  def self.render(source_path, template = "default")
    # slideshow = new()
    # slideshow.render(template)
  end

  # Ensures that the first slide has proper !SLIDE declaration
  def initialize(source_path, opts = {})
    raw = File.new(source_path).read
    @raw = raw =~ /\A!SLIDE/ ? raw : "!SLIDE\n#{raw}"
    extract_classes!

    self.stylesheets = opts[:stylesheets] || local_stylesheets
    self.title =       opts[:title]       || "Slides"
  end

  def slides
    @slides ||= lines.map { |text| Slide.new(text, *@classes.shift) }
  end

  def render(name)
    Haml::Engine.new(File.new("#{name}.haml", "r:UTF-8").read).render(self)
    # File.new("#{name}.haml", 'r:UTF-8').read
  end

  private

  def lines
    @lines ||= @raw.split(/^!SLIDE\s*([a-z\s]*)$/).reject { |line| line.empty? }
  end

  def local_stylesheets
    Dir[Dir.pwd + '/*.stylesheets']
  end

  def javascripts
    Dir[Dir.pwd + '/*.javascripts'].map { |path| File.read(path) }
  end

  def extract_classes!
    @classes = []
    @raw.gsub!(/^!SLIDE\s*([a-z\s]*)$/) do |klass|
      @classes << klass.to_s.chomp.gsub('!SLIDE', '')
      "!SLIDE"
    end
    @classes
  end

  def extract_notes!
    @raw.gsub!(/^!NOTES\s*(.*)!SLIDE$/m) do |note|
      '!SLIDE'
    end
    @raw.gsub!(/^!NOTES\s*(.*\n)$/m) do |note|
      ''
    end
  end
end
