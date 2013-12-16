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

	def setup_entry(trade)
		trade.entries.build if trade.entries.empty?
		return trade
	end

	
	def securities_option_list(user)
		all_secs.sort_by{|a| a.sort_order.to_i}.map { |x| [x.symbol, x.symbol] }
	end

	def kelly(security_symbol, stop, fill, target1, target2, prob1, prob2, 
																			options = { stop2: fill, sellpct: 0.5, spread: 1 } )

		risk = (fill - stop).abs
		spread = options[:spread]
		house_take = house(risk,security_symbol, spread)

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

	def getbestkelly(security_symbol, stop, fill, targ1, targ2, prob1, prob2, stop2: stop2, spread: spread)
		results = []
		0.step(1,0.10).each do |sellpct|
			results << [sellpct, kelly(security_symbol,stop,fill,targ1,targ2,prob1,prob2,stop2: stop2,
			 												sellpct: sellpct, spread: spread)[0] ]
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

	def house(risk, security_symbol, spread)
		security = find_sec(security_symbol)
		tick_cost = security.tickval.to_f * spread
		tick_size = security.tick_size.to_f
		commiss = 5.0
		risk_in_ticks = risk / tick_size
		return (tick_cost + commiss) / (risk_in_ticks * security.tickval.to_f)
		
	end

	def get_alloc(kelly, account, security_symbol, risk, fraction)
		security = find_sec(security_symbol)
		risk_in_ticks = risk/security.tick_size.to_f
		risk_per_contract = risk_in_ticks * security.tickval.to_f
		return ( (kelly/fraction * account) /risk_per_contract)

		
	end

	def get_quote(symbol)
		quote = Security.quote(symbol)
		[quote.ask_realtime, quote.bid_realtime, quote.last_trade_time]
	end

	def get_spread(symbol)
		s = find_sec(symbol)
		tick = s.tick_size.to_f
		quote = Security.quote(symbol)

		if quote == "no quote" or (quote.ask_realtime == quote.bid_realtime)
			s.default_spread
		else 
			((quote.ask_realtime - quote.bid_realtime)	/ tick	).round(0)
		end
	end

	def all_secs
		(Quotebase.default_securities + current_user.securities).uniq(&:symbol)
	end

	def find_sec(symbol)
		all_secs.select {|i| i.symbol == symbol }.first
	end

	def link_to_add_fields(name, f, association)
		new_object = f.object.send(association).klass.new
		id = new_object.object_id
		fields = f.fields_for(association, new_object, child_index: id) do |builder|
			render(association.to_s.singularize + "_fields", f: builder)
		end
		link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
	end

	def date_format(date)
		if date.nil?
		  Time.zone.now.strftime("%Y-%m-%dT%R")
		else
			date.strftime('%Y-%m-%dT%T')
		end
	end

	def step(symbol)
		find_sec(symbol).tick_size
	end
end
