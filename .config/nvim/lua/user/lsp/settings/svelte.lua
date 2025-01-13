return {
	settings = {
		svelte = {
			plugin = {
				css = {
					completions = {
						emmet = false,
					},
				},
				html = {
					tagComplete = {
						enable = false,
					},
				},
				svelte = {
					defaultScriptLanguage = "ts",
                    format = {
                        config = {
                            svelteStrictMode = true,
                        }
                    }
				},
			},
		},
		emmet = {
			showExpandedAbbreviation = "never",
		},
	},
}
