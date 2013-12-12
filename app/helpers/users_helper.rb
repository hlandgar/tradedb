module UsersHelper
	include ApplicationHelper

	# Returns a Gravatar for the given user
	def gravatar_for(user, options = { size: 50 })
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		size = options[:size]
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
		image_tag(gravatar_url, alt: user.name, class: "gravatar")
		
	end

	def avg_price(trade)
		trade.avg_price
	end

	def open_pl(trade)
		trade.open_pl
	end









	def make_desc(fill,stop,sym)
		desc = find_sec(sym).description
		long_or_short(fill,stop) + " " + desc
	end

	private
		def long_or_short(fill,stop)
			fill>stop ? "Long " : "Short "
		end
end

	

