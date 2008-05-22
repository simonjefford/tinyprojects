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

class LighthouseProject
  def initialize
    validate_state
    Lighthouse.account = account
    Lighthouse.token = token

    if File.exist?(cache_file_name)
      @ticket_cache = YAML.load_file(cache_file_name)
    else
      @ticket_cache = {}
    end
  end

  def project
    Git.get_config_value('gil.project')
  end

  def token
    Git.get_config_value('gil.token')
  end

  def account
    Git.get_config_value('gil.account')
  end

  def get_tickets(ticketnumbers)
    ticketnumbers.map do |ticket_num|
      ticket = @ticket_cache[ticket_num]
      if (!ticket)
        ticket = Ticket.find(ticket_num, :params => {:project_id => project})
        @ticket_cache[ticket_num] = ticket
        save_cache
      end
      ticket
    end
  end

private
  def save_cache
    system("mkdir -p #{File.dirname(cache_file_name)}")
    File.open(cache_file_name, "w") do |cache_file|
      YAML.dump(@ticket_cache, cache_file)
    end
  end

  def cache_file_name
    File.expand_path("~/.gil/#{account}.#{project}.cache.yml")
  end

  def validate_state
    if project == ''
      raise "No project was found in .git config."
    end

    if token == ''
      raise "No token was found in .git config."
    end

    if account == ''
      raise "No account was found in .git config."
    end
  end
end

class Gil
  def initialize
    @lighthouse = LighthouseProject.new
  end

  def summarise_commits(rev)
    logentries = Git.get_log_entries(rev)
    ticketnumbers = logentries.map { |entry| find_ticket_number(entry) }.compact.uniq
    @lighthouse.get_tickets(ticketnumbers)
  end

private
  def find_ticket_number(logentry)
    re = /\[\#(\d+).*state:resolved.*\]/
    match = re.match(logentry)
    match[1] if match
  end
end