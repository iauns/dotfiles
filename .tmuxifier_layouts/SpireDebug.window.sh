# Spire window.
window_root "~/sci/spire"

new_window "spire-debug"

split_v 20
run_cmd "echo 'Spire log' > /tmp/SpireLog; and tail -f /tmp/SpireLog"
split_h 50

select_pane 0
