require 'rails_helper'

RSpec.describe ShortUrl, type: :model do
    before(:all) do
        @url = build(:short_url)
      end
    
      it "should validate with valid attribute" do
        expect(@url).to be_valid
      end
  
end
