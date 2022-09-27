local random = Random.new();

local runs = 0;
local maxRuns = random:NextInteger(1, 75);

local function sortedLoot(t)
   local values = {};

   for k, v in pairs(t) do
      table.insert(values, { k, v });
   end

   table.sort(values, function(a, b)
       return a[2] > b[2];
   end)

   return values;
end

function Lerp(a, b, t)
   return a+(b-a)*t;
end

function Roll(lootTable)
   runs += 1;

   if count >= max then
      random = Random.new(os.time() + random:NextInteger(0, 0xFFFFFFFF));
      maxRuns = random:NextInteger(1, 75);
      count = 0;
   end

   local totalWeight = 0
   for _, weight in pairs(lootTable) do
      totalWeight += weight
   end

   local randomWeight = random:NextNumber(0, totalWeight);
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

   local sorted = sortedLoot(lootTable)
   local size = #sorted
   local mid = math.ceil(size/2)

   for index, drop in ipairs(sorted) do
      local distribution
      if index <= mid then
         distribution = Lerp(0.875, 1.15, index/mid)
      elseif index > mid then
         distribution = Lerp(1.15, 1.05, index/size)
      end

      local luck = distribution ^ luck
      adjustedWeights[drop[1]] = drop[2] * luck
   end

   return adjustedWeights
end

return {
   Roll = Roll;
   AdjustWeights = AdjustWeights;
}
