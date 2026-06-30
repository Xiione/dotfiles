function ssh --wraps=ssh --description 'Run SSH with the terminal type expected by remote hosts'
    TERM=xterm-256color command ssh $argv
end
