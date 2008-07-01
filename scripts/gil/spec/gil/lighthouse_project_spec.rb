require File.dirname(__FILE__) + '/../spec_helper'

module LighthouseProjectSpecHelpers
  def mock_succesful_git_config
    Git.stub!(:get_config_value).with("gil.account").and_return("account")
    Git.stub!(:get_config_value).with("gil.project").and_return("11111")
    Git.stub!(:get_config_value).with("gil.token").and_return("token")
  end
end

describe "LighthouseProject - initialisation" do
  it "should complain if no account could be found" do
    Git.should_receive(:get_config_value).with("gil.account").and_return("")
    Git.should_receive(:get_config_value).with("gil.project").any_number_of_times.and_return("11111")
    Git.should_receive(:get_config_value).with("gil.token").any_number_of_times.and_return("token")
    lambda { LighthouseProject.new }.should raise_error(RuntimeError, "No account was found in .git config.")
  end

  it "should complain if no project could be found" do
    Git.should_receive(:get_config_value).with("gil.account").any_number_of_times.and_return("account")
    Git.should_receive(:get_config_value).with("gil.project").and_return("")
    Git.should_receive(:get_config_value).with("gil.token").any_number_of_times.and_return("token")
    lambda { LighthouseProject.new }.should raise_error(RuntimeError, "No project was found in .git config.")
  end

  it "should complain if no token could be found" do
    Git.should_receive(:get_config_value).with("gil.account").any_number_of_times.and_return("account")
    Git.should_receive(:get_config_value).with("gil.project").any_number_of_times.and_return("11111")
    Git.should_receive(:get_config_value).with("gil.token").and_return("")
    lambda { LighthouseProject.new }.should raise_error(RuntimeError, "No token was found in .git config.")
  end
end

describe "LighthouseProject - ticket fetching" do
  include LighthouseProjectSpecHelpers

  it "should have use the lighthouse api to find a ticket in the configured project" do
    mock_succesful_git_config
    l = LighthouseProject.new
    Ticket.should_receive(:find).with(1, :params => {:project_id => "11111"})
    l.get_tickets([1])
  end
end
