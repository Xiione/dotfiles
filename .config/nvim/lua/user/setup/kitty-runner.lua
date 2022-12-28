local status_ok, kitty_runner = pcall(require, "kitty-runner")
if not status_ok then
  return
end

kitty_runner.setup()

