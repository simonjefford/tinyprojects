require File.dirname(__FILE__) + '/../spec_helper'

describe "Base Formatter Class" do
  it "should be constructed with some tickets" do
    f = Formatter.new(["A ticket"])
    f.tickets.should == ["A ticket"]
  end
end

describe "Plain Formatter" do
  before(:each) do
    ticket_a = mock("ticket_a", :number => 1, :title => "The first ticket")
    ticket_b = mock("ticket_b", :number => 2, :title => "The second ticket")
    @tickets = [ticket_a, ticket_b]
  end

  it "should output a list of tickets" do
    p = PlainFormatter.new(@tickets)
    formatted = p.format.split("\n")
    formatted.length.should == 2
  end

  it "should output the name and title of each ticket" do
    p = PlainFormatter.new(@tickets)
    formatted = p.format.split("\n")
    formatted[0].should == "#1 - The first ticket"
    formatted[1].should == "#2 - The second ticket"
  end
end

describe "ERB Formatter" do
  before(:each) do
    ticket_a = mock("ticket_a", :number => 1, :title => "The first ticket")
    ticket_b = mock("ticket_b", :number => 2, :title => "The second ticket")
    @tickets = [ticket_a, ticket_b]
  end

  it "should require a template to be passed in the options" do
    f = ERBFormatter.new(@tickets)
    lambda {
      f.format
    }.should raise_error(RuntimeError, "Need a template to render using ERB")
  end

  it "should require either a template path or a template string - not both" do
    f = ERBFormatter.new(@tickets)
    lambda {
      f.format(:template_path => ".", :template => "mytemplate")
    }.should raise_error(RuntimeError, "You need to pass either a template path or a template string")
  end

  it "should render an ERB template using the tickets" do
    template = <<-EOF
<%- @tickets.each do |ticket| -%>
#<%= ticket.number %> - <%= ticket.title %>
<%- end -%>
    EOF
    f = ERBFormatter.new(@tickets)
    formatted = f.format(:template => template).split("\n")
    formatted.length.should == 2
    formatted[0].should == "#1 - The first ticket"
    formatted[1].should == "#2 - The second ticket"
  end

  it "should read the template from a file when passed the template_path option" do
    f = ERBFormatter.new(@tickets)
    template_path = get_fixture_path("simpletemplate.erb")
    formatted = f.format(:template_path => template_path).split("\n")
    formatted[0].should == "#1 - The first ticket"
    formatted[1].should == "#2 - The second ticket"
  end
end
