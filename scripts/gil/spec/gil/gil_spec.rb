require File.dirname(__FILE__) + '/../spec_helper'

describe "Gil" do
  before(:each) do
    @lighthouseproject = mock("lighthouse")
    LighthouseProject.stub!(:new).and_return(@lighthouseproject)
    ticket_a = mock("ticket_a", :number => 1, :title => "The first ticket")
    ticket_b = mock("ticket_b", :number => 2, :title => "The second ticket")
    tickets = [ticket_a, ticket_b]
    @lighthouseproject.stub!(:get_tickets).and_return(tickets)
  end

  it "should use the ERB Formatter when passed a template file" do
    mockformatter = mock("ERBFormatter")
    fixture_path = get_fixture_path("simpletemplate.erb")
    mockformatter.should_receive(:format).with(:templatepath => fixture_path)
    ERBFormatter.should_receive(:new).and_return(mockformatter)
    g = Gil.new(:templatepath => fixture_path)
    g.summarise_commits
  end

  it "should default to the Plain Formatter when passed no options" do
    mockformatter = mock("PlainFormatter")
    fixture_path = get_fixture_path("simpletemplate.erb")
    mockformatter.should_receive(:format)
    PlainFormatter.should_receive(:new).and_return(mockformatter)
    g = Gil.new
    g.summarise_commits
  end
end
