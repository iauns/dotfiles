# Spire window.
window_root "~/sci/spire"

new_window "spire"

split_v 20
split_h 50
run_cmd "echo 'Spire log' > /tmp/SpireLog; and tail -f /tmp/SpireLog"

select_pane 0