module ApplicationHelper

	# Returns the full title on a per-page basis

	def full_title(page_title)
		base_title = "TradeanEdge.com"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end

	def securities_option_list(user)
		user.securities.map { |x| [x.symbol, x.id] }
	end

	def kelly(security_id, stop, fill, target1, target2, prob1, prob2, options = { stop2: fill } )
		
		# calcucate the profit to 2nd half of trade if stopped out at stop2
		stop2 = options[:stop2] ||= fill
		give_back = (fill - stop2).abs 

		risk = (fill - stop).abs
		rrg = give_back/risk 
		rr1 = (target1 - fill).abs/risk
		rr2 = (target2 - fill).abs/risk 

		# r1 is if we make first target but second half of trade exits at stop2

		r1 =  prob2 > 0 ? rr1/2 + rrg/2 : rr1 
		r2 = rr2/2 + r1 
		e1 = (prob1 * r1) - house(risk,security_id)/2
		e2 = (prob2 * r2) - house(risk,security_id)/2 
		q = 1 -prob1 -prob2

		c = -q + e1 + e2 
		b = -q*(r1 + r2) + (e1*r2) + (e2*r1) -e1 -e2
		a = -q*r1*r2 - (e1*r2) - (e2*r1)

		if prob2 > 0
			[quad(a,b,c).select { |x| x >0 and x < 1}.max.round(3) ,c.round(3) ]
		else
			edge = e1 - q - house(risk,security_id)/2
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

	def house(risk, security_id)
		security = current_user.securities.find(security_id)
		tick_cost = security.tickval * security.default_spread
		tick_size = security.tick_size
		commiss = 5.0
		risk_in_ticks = risk / tick_size
		return (tick_cost + commiss) / (risk_in_ticks * security.tickval)
		
	end

	def get_alloc(kelly, account, security_id, risk)
		security = current_user.securities.find(security_id)
		risk_in_ticks = risk/security.tick_size
		risk_per_contract = risk_in_ticks * security.tickval
		return ( (kelly/3 * account) /risk_per_contract)

		
	end
end
