local status_ok, nvim_dev_webicons = pcall(require, "nvim_dev_webicons")
if not status_ok then
  return
end

nvim_dev_webicons.setup {
    -- globally enable different highlight colors per icon (default to true)
    -- if set to false all icons will have the default icon's color
    color_icons = true;
    -- override = {
    -- },
    -- globally enable default icons (default to false)
    -- will get overriden by `get_icons` option
    default = true;
}
