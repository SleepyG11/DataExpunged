local other_keys = {
    "scoring_hand"
}
for i, v in pairs(other_keys) do
    SMODS.other_calculation_keys[#SMODS.other_calculation_keys+1] = v
end