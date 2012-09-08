require 'spec_helper'

describe Article do
  it "is not valid without a name" do
    FactoryGirl.build(:article, :title => nil).should_not be_valid
  end

  it "is not valid without content" do
    FactoryGirl.build(:article, :content => nil).should_not be_valid
  end

  it "is not valid without category" do
    FactoryGirl.build(:article, :category => nil).should_not be_valid
  end

  it "has a valid factory" do
    FactoryGirl.build(:article).should be_valid
  end
end
