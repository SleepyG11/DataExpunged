SMODS.Joker {
    key = "code_name_dr_mann",
    pos = {x = 0, y = 0},
    --atlas = "jokers",

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    cost = 10,
    rarity = 4,

    classification = "proposal",

    calculate = function(self, card, context)
        if context.scoring_cards_check then
            local cards = {}
            for j = 1, #context.scoring_hand do
                for i, v in pairs(context.scoring_hand) do
                    if j <= i then
                        cards[#cards+1] = v
                    end
                end
            end
            return {
                scoring_hand = cards
            }
        end
    end
}

local calc_main_scoring = SMODS.calculate_main_scoring
function SMODS.calculate_main_scoring(context, scoring_hand)
    local cards = SCP.get_scored_cards(context.scoring_hand)
    if context.cardarea ~= G.play or not cards then
	    calc_main_scoring(context, context.scoring_hand)
    end
	if context.cardarea == G.play and cards then
        if not G.rescore_cards or #G.rescore_cards.cards == 0 then
            G.rescore_cards = {cards = cards}
        end
		context.cardarea = G.rescore_cards
        context.scoring_hand = G.rescore_cards.cards
		calc_main_scoring(context, G.rescore_cards.cards)
		context.cardarea = G.play
        G.rescore_cards = nil
	end
	return
end

function SCP.get_scored_cards(scored_cards)
    local cards 
    for i, v in pairs(SMODS.get_card_areas("jokers")) do
        for _, card in pairs(v.cards) do
            local ret = card.config.center.calculate and card.config.center:calculate(card, {scoring_cards_check = true, scoring_hand = scored_cards})
            print(ret)
            if ret and ret.scoring_hand then
                cards = cards or {}
                SCP.merge_tables(cards, ret.scoring_hand)
            end
        end
    end
    return cards
end
