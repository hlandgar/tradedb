module UsersHelper

	# Returns a Gravatar for the given user
	def gravatar_for(user, options = { size: 50 })
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		size = options[:size]
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
		image_tag(gravatar_url, alt: user.name, class: "gravatar")
		
	end

	def long_or_short(fill,stop)
		fill>stop ? "Long " : "Short "
	end

	def make_desc(fill,stop,sym_id, quantity)
		desc = current_user.securities.find(sym_id).description
		long_or_short(fill,stop) + "#{quantity} " + desc
	end



end

	

