require File.dirname(__FILE__) + '/../spec_helper'

describe "LighthouseProject" do
  it "should use the Git class to verify the lighthouse account information when constructed" do
    Git.should_receive(:get_config_value).with("gil.account").and_return("account")
    Git.should_receive(:get_config_value).with("gil.project").and_return("11111")
    Git.should_receive(:get_config_value).with("gil.token").and_return("token")
    LighthouseProject.new
  end

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
