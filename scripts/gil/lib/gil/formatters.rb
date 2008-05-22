require "erb"

class Formatter
  def initialize(tickets)
    @tickets = tickets
  end
  attr_reader :tickets
end

class PlainFormatter < Formatter
  def format(options = {})
    output = []
    @tickets.each do |t|
      output << "##{t.number} - #{t.title}"
    end
    output.join("\n")
  end
end

class ERBFormatter < Formatter
  def format(options = {})
    template_path = options[:template_path]
    template = options[:template]
    raise "Need a template to render using ERB" unless template_path || template
    raise "You need to pass either a template path or a template string" if template_path && template
    if options[:template_path]
      template = File.read(template_path)
    end
    result = ERB.new(template, nil, "-").result(binding)
  end
end
