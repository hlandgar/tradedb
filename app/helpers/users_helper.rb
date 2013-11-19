module UsersHelper

	# Returns a Gravatar for the given user
	def gravatar_for(user, options = { size: 50 })
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		size = options[:size]
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
		image_tag(gravatar_url, alt: user.name, class: "gravatar")
		
	end

	def kelly(stop, fill, target1, target2, prob1, prob2, options = { stop2: fill } )
		
		# calucate the profit to 2nd half of trade if stopped out at stop2
		stop2 = options[:stop2]
		give_back = (fill - stop2).abs

		risk = (fill - stop).abs
		rrg = give_back/risk
		rr1 = (target1 - fill).abs/risk
		rr2 = (target2 - fill).abs/risk

		# r1 is if we make first target but second half of trade exits at stop2

		r1 =  prob2 > 0 ? rr1/2 + rrg/2 : rr1 
		r2 = rr2/2 + r1 
		e1 = (prob1 * r1) - house(risk)/2
		e2 = (prob2 * r2) - house(risk)/2
		q = 1 -prob1 -prob2

		c = -q + e1 + e2 
		b = -q*(r1 + r2) + (e1*r2) + (e2*r1) -e1 -e2
		a = -q*r1*r2 - (e1*r2) - (e2*r1)

		if prob2 > 0
			[quad(a,b,c).select { |x| x >0 and x < 1}.max.round(3) ,c.round(3) ]
		else
			edge = e1 - q - house(risk)/2
			[(edge / r1).round(3), edge.round(3)]
		end


	end

	def quad(a,b,c)
		fRoot1 = nil
	  fRoot2 = nil

	  fRoot1 = (-b + Math.sqrt((b ** 2) - (4 * a * c)) ) / (2 * a)
	  fRoot2 = (-b - Math.sqrt((b ** 2) - (4 * a * c)) ) / (2 * a)

	  return [fRoot1, fRoot2]

	end

	def house(risk)
		tick_val = 12.5
		tick_size = 0.25
		commiss = 5.0
		risk_in_ticks = risk / tick_size
		return (tick_val + commiss) / (risk_in_ticks * tick_val)
		
	end

end

	

