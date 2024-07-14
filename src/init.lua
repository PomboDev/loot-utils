local random = Random.new()

local runs = 0
local maxRuns = random:NextInteger(1, 75)

local function roll(weightedTable)
   runs += 1

   if runs >= maxRuns then
      random = Random.new(os.time() + random:NextInteger(0, 0xFFFFFFFF))
      maxRuns = random:NextInteger(1, 75)
      runs = 0
   end

   local totalWeight = 0
   for _, weight in pairs(weightedTable) do
      totalWeight += weight
   end

   local randomWeight = random:NextNumber(0, totalWeight)
   for index, weight in pairs(weightedTable) do
      if randomWeight <= weight then
         return index
      else
         randomWeight -= weight
      end
   end
end

local function adjustWeights(weightedTable, factor)
	local totalWeight = 0
	local orderedWeights = {}
	local adjustedWeights = {}

	for key, weight in pairs(weightedTable) do
		totalWeight = totalWeight + weight
		table.insert(orderedWeights, { key = key, weight = weight })
	end

	table.sort(orderedWeights, function(a, b)
		return a.weight > b.weight
	end)

	local adjustedTotalWeight = 0
	for index, values in ipairs(orderedWeights) do
		if index == 1 then
			values.weight = values.weight * factor
		else
			values.weight = values.weight * (factor ^ index)
		end
		adjustedTotalWeight = adjustedTotalWeight + values.weight
	end

	local normalizationFactor = totalWeight / adjustedTotalWeight

	for _, values in ipairs(orderedWeights) do
		adjustedWeights[values.key] = values.weight * normalizationFactor
	end

	return adjustedWeights
end

return {
   roll = roll;
   adjustWeights = adjustWeights;
}
