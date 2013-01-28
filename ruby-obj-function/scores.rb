module Scores

  def Scores.cost(pus, selection)
    cost = 0
    selection.each {|pu|
      cost = cost + pus[pu][:cost]
    }
    return cost
  end

  def Scores.boundary_penalty(bnd, selection)
  	perimeter = 0
    selection.each {|i| 
      sum = bnd[i]["bounds"].inject(:+)
      selection.each {|id|
        next if i == id
        if bnd[i]["ids"].include?(id)
          indx = bnd[i]["ids"].index(id)
          sum = sum - bnd[i]["bounds"][indx]
        end
      }
      perimeter = perimeter + sum
    }
    #puts "Perimeter: " + perimeter.to_s
    return perimeter
  end

  def Scores.sum_selected(puv, selection)
  	# count spp amounts on a selected set of pus
    selected = {}
    penalty = 0
    selection.each {|id|
      (0..puv[id]["species"].count - 1).each {|i| 
        species = puv[id]["species"][i]
        area = puv[id]["amount"][i]
        h = {}
        if selected[species] == nil
          h = {"selected_amount" => area}
        else
          area = area + selected[species]["selected_amount"] # capture existing values
          h["selected_amount"] = area
        end
        selected[species] = h
      }
    }
    return selected
  end

  def Scores.species_penalty(spp, spp_sums, selected)
  	penalty = 0
    missed = 0
    spp.each {|species|
      #puts species
      sp_id = species[0]
      prop = species[1][:prop]
      spf = species[1][:spf]
      increase_penalty = true
      begin
        unless spp_sums[sp_id].nil? or selected[sp_id].nil? # case 1 or case 2
          total = spp_sums[sp_id][:total_area]
          area = selected[sp_id]["selected_amount"]
          if area > prop * total # case 3
            increase_penalty = false
          end
        end
        if increase_penalty
          penalty = penalty + spf
          missed += 1
        end
      rescue
        puts "Exception on species id: " + sp_id.to_s
      end
    }
    puts "Missed " + missed.to_s + " of " + spp.count.to_s + " species."
    puts "Penalty: " + penalty.to_s
    return [missed, penalty]
  end

end