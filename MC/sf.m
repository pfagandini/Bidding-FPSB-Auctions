function f = sf(estimates , bids , tolerance , first , last , bidder)
  
  intervals = 30;
  profit = -10;
  worse_prof = 10;
  worse = NaN;
  best = NaN;
  counter = 0;
  bidsaux = bids;
  
  mu = mean(estimates(:,bidder));
  
  exp_prof_hist = [];
  
  search_set = linspace(first , last, intervals);
    
  for i = search_set
     counter = counter + 1;
     bidsaux(:,bidder) = estimates(:,bidder) - ones(size(estimates(:,bidder)))*i;
     won = bidsaux(:,bidder) == (max(bidsaux'))';
     exp_profits = mean((mu-bidsaux(:,bidder)) .* won);
     exp_prof_hist=[exp_prof_hist,exp_profits];
     
     if exp_profits > profit
       profit = exp_profits;
       best = counter;
     end
##     
##     if exp_profits < worse_prof
##       worse_prof = exp_profits;
##     end
     
  end
    
  if abs(first-last)<tolerance
    f = (first+last)/2;
  else

    first = search_set(best) - (max(search_set)-min(search_set))/2.5;
    last = search_set(best) + (max(search_set)-min(search_set))/2.5;

    f = sf(estimates , bids , tolerance , first , last , bidder);
  end
 
endfunction