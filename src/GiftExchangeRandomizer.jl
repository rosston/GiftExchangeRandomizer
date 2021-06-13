module GiftExchangeRandomizer

using Combinatorics: permutations

struct Exchanger
  id::Int
  name::String
end

struct ExchangeRelationship
  giver::Int
  receiver::Int
end

exchangers() = [
                Exchanger(1, "Ed Baldwin"),
                Exchanger(2, "Karen Baldwin"),
                Exchanger(3, "Gordo Stevens"),
                Exchanger(4, "Tracy Stevens"),
                Exchanger(5, "Ellen Wilson"),
                Exchanger(6, "Larry Wilson"),
                Exchanger(7, "Molly Cobb"),
                Exchanger(8, "Wayne Cobb")
               ]

households() = [[1, 2], [3, 4], [5, 6], [7, 8]]

function relationships_from_array(exchanger_ids)
  relationships = Vector{ExchangeRelationship}(undef, length(exchanger_ids))
  for (i, id) = pairs(exchanger_ids)
    next_i = i + 1 <= length(exchanger_ids) ? i + 1 : 1
    relationships[i] = ExchangeRelationship(id, exchanger_ids[next_i])
  end
  relationships
end

function possible_relationships(exchanger_ids)
  relationships_from_array.(permutations(exchanger_ids)) |>
  Iterators.flatten |>
  Set
end

function household_relationships()
  union(possible_relationships.(households())...)
end

function possible_arrangements(exchanger_ids)
  relationships_from_array.(permutations(exchanger_ids))
end

end
