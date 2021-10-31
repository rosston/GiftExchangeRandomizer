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

ExchangeRelationship(array) = ExchangeRelationship(array...)

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

last_time() = [[1, 4], [2, 8], [3, 6], [4, 7], [5, 1], [6, 3], [7, 2], [8, 5]]
time_before_last() =
  [[1, 4], [2, 6], [3, 2], [4, 8], [5, 7], [6, 1], [7, 5], [8, 3]]

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

function valid_arrangements(exchanger_ids)
  household_rels = household_relationships()
  has_household_rel(arrangement) =
    length(intersect(arrangement, household_rels)) != 0

  filter(!has_household_rel, possible_arrangements(exchanger_ids))
end

function scored_arrangements(exchanger_ids)
  arrangements = valid_arrangements(exchanger_ids)
  last_time_rels = Set(map(ExchangeRelationship, last_time()))
  time_before_last_rels = Set(map(ExchangeRelationship, time_before_last()))

  num_last_time_rels(arrangement) =
    length(intersect(arrangement, last_time_rels))
  num_time_before_last_rels(arrangement) =
    length(intersect(arrangement, time_before_last_rels))

  scored = Dict{Int, Vector{Vector{ExchangeRelationship}}}()
  for arrangement in arrangements
    score = (1000
             - (num_last_time_rels(arrangement) * 20)
             - (num_time_before_last_rels(arrangement) * 10))
    if !haskey(scored, score)
      scored[score] = []
    end
    push!(scored[score], arrangement)
  end
  scored
end

function next_arrangement(exchanger_ids)
  scored = scored_arrangements(exchanger_ids)
  max_score = max(keys(scored)...)

  arrangement = rand(scored[max_score])

  (max_score, arrangement)
end

end
