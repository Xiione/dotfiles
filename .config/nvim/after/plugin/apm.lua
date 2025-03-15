local status_ok, apm = pcall(require, "vim-apm")
if not status_ok then
    return
end

local data_path = vim.fn.stdpath("data")
local default_data_path = string.format("%s/vim-apm.json", data_path)
apm:setup({
    reporter = {
        type = "file", -- or "memory", "network" reporter seems to be unfinished
        uri = default_data_path,
        report_interval = 1 * 60 * 1000, -- unused by file reporter
        apm_repeat_count = 10, -- window size for diminishing returns, i.e. lower -> less diminishing returns on repeated motions
        apm_period = 60 * 1000, -- in ms, actions per 1 minute, e.g. use 5*60*1000 for actions per 5 minute period
        apm_report_period = 5 * 1000, -- in ms, emit the APM_REPORT and STATS events with a period of this amount
    }
})
