local random = Random.new()

local runs = 0
local maxRuns = random:NextInteger(1, 75)

function Roll(lootTable)
   runs += 1

   if runs >= maxRuns then
      random = Random.new(os.time() + random:NextInteger(0, 0xFFFFFFFF))
      maxRuns = random:NextInteger(1, 75)
      runs = 0
   end

   local totalWeight = 0
   for _, weight in pairs(lootTable) do
      totalWeight += weight
   end

   local randomWeight = random:NextNumber(0, totalWeight)
   for index, weight in pairs(lootTable) do
      if randomWeight <= weight then
         return index
      else
         randomWeight -= weight
      end
   end
end

function AdjustWeights(lootTable, luck)
   local adjustedWeights = {}
   local totalWeight = 0

   for _, dropChance in pairs(lootTable) do
      totalWeight += dropChance
   end

   for dropId, dropChance in pairs(lootTable) do
      if dropChance/totalWeight <= 0.05 then
         adjustedWeights[dropId] = dropChance * luck
      else
         adjustedWeights[dropId] = dropChance
      end
   end

   return adjustedWeights
end

return {
   Roll = Roll;
   AdjustWeights = AdjustWeights;
}
