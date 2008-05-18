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
  def initialize(options)
    @options = options
    validate_state
    Lighthouse.account = account
    Lighthouse.token = token
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
      ticket = Ticket.find(ticket_num, :params => {:project_id => project})
    end
  end

private
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
  def initialize(options)
    @lighthouse = LighthouseProject.new(options)
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