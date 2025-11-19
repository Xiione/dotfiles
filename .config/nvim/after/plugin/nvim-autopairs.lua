-- Setup nvim-cmp.
local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
npairs.add_rules({
	Rule("$", "$", "tex"),
	Rule("\\(", "\\)", "tex"),
	Rule("\\[", "\\]", "tex"),
	Rule("\\{", "\\}", "tex"),
})

npairs.add_rule(Rule("$", "$", "md"))
npairs.add_rule(Rule("\\(", "\\)", "md"))
npairs.add_rule(Rule("\\[", "\\]", "md"))
npairs.add_rule(Rule("\\{", "\\}", "md"))

require("cmp").event:on("confirm_done", 
    require("nvim-autopairs.completion.cmp").on_confirm_done({})
)
