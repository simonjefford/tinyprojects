class LighthouseProject
  def initialize
    validate_state
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
    init_cache
    init_lighthouse
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

  def init_cache
    if File.exist?(cache_file_name)
      @ticket_cache = YAML.load_file(cache_file_name)
    else
      @ticket_cache = {}
    end
  end

  def init_lighthouse
    Lighthouse.account = account
    Lighthouse.token = token
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
