require 'spec_helper'

describe "Application_helper" do

	describe "full_title" do
		it "should include the page title" do
			expect(full_title("foo")).to match(/foo/)
		end

		it "should include base title" do
			expect(full_title("foo")).to match(/^TradeanEdge\.com/)
		end

		it "should not include a bar for the home page" do
			expect(full_title("")).not_to match(/\|/)
		end
	end
end