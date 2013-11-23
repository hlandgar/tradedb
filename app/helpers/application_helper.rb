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

	def kelly(security_id, stop, fill, target1, target2, prob1, prob2, 
																			options = { stop2: fill, sellpct: 0.5 } )

		risk = (fill - stop).abs
		house_take = house(risk,security_id)

		if prob2 == 0
			
			rr1 = (target1 - fill).abs/risk
			r1 = rr1
			edge = (prob1 * r1) - (1 - prob1) - house_take
			kelly = edge / r1
			return [kelly.round(3), edge.round(3)]

		else

			(prob1, prob2) = bayes(prob1, prob2)

			sellpct = options[:sellpct] || 0.5
			keeppct = 1 - sellpct

			stop2 = options[:stop2] || fill

			give_back = (fill - stop2).abs

			rrg = give_back/risk

			rr1 = (target1 - fill).abs/risk
			rr2 = (target2 - fill).abs/risk

			r1 = (rr1 * sellpct) + (rrg * keeppct)

			r2 = (rr2 * keeppct) + r1

			e1 = (prob1 * r1) - (house_take * sellpct)
			e2 = (prob2 * r2) - (house_take * keeppct)
			q = 1 - prob1 - prob2

			c = -q + e1 + e2 
			b = -q*(r1 + r2) + (e1*r2) + (e2*r1) -e1 -e2
			a = -q*r1*r2 - (e1*r2) - (e2*r1)

			kelly = quad(a,b,c).select { |x| x >0 and x < 1}.max || 0.0

			return [kelly.round(3) ,c.round(3) ]

		end
	end

	def getbestkelly(security_id, stop, fill, targ1, targ2, prob1, prob2, stop2: stop2)
		results = []
		0.step(1,0.10).each do |sellpct|
			results << [sellpct, kelly(security_id,stop,fill,targ1,targ2,prob1,prob2,stop2: stop2,
			 												sellpct: sellpct)[0] ]
		end
		results.max_by(&:last)[0]

		
	end


	def quad(a,b,c)
		fRoot1 = nil
	  fRoot2 = nil

	  fRoot1 = (-b + Math.sqrt((b ** 2) - (4 * a * c)) ) / (2 * a)
	  fRoot2 = (-b - Math.sqrt((b ** 2) - (4 * a * c)) ) / (2 * a)

	  return [fRoot1, fRoot2]

	end

	def bayes(prob1, prob2)
		prob_cond = prob2/prob1

		p1_new = prob1 / ( 1 + prob_cond )
		p2_new = prob1 - p1_new

		return [p1_new, p2_new]
	end

	def house(risk, security_id)
		security = current_user.securities.find(security_id)
		tick_cost = security.tickval * security.default_spread
		tick_size = security.tick_size
		commiss = 5.0
		risk_in_ticks = risk / tick_size
		return (tick_cost + commiss) / (risk_in_ticks * security.tickval)
		
	end

	def get_alloc(kelly, account, security_id, risk, fraction)
		security = current_user.securities.find(security_id)
		risk_in_ticks = risk/security.tick_size
		risk_per_contract = risk_in_ticks * security.tickval
		return ( (kelly/fraction * account) /risk_per_contract)

		
	end
end
