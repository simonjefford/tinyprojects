require "yaml"

class Git
  class << self
    def get_config_value(value_name)
      `git config #{value_name}`.chomp
    end

    def get_log_entries(rev)
      `git log #{rev} --pretty=oneline --no-color`.split("\n")
    end
  end
end

class Gil
  def initialize(options = {})
    @lighthouse = LighthouseProject.new
    @options = options
  end

  def summarise_commits(rev = nil)
    logentries = Git.get_log_entries(rev)
    ticketnumbers = logentries.map { |entry| find_ticket_number(entry) }.compact.uniq
    tickets = @lighthouse.get_tickets(ticketnumbers)
    format(tickets)
  end

private
  def format(tickets)
    formatteroptions = {}
    if @options[:templatepath]
      formatter_klass = ERBFormatter
      formatteroptions[:templatepath] = @options[:templatepath]
    else
      formatter_klass = PlainFormatter
    end
    formatter_klass.new(tickets).format(formatteroptions)
  end

  def find_ticket_number(logentry)
    re = /\[\#(\d+).*state:resolved.*\]/
    match = re.match(logentry)
    match[1] if match
  end
end
