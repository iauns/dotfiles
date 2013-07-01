session_root "~"

if initialize_session "General"; then

  load_window "General2x2"
  select_window "General"

  # Create a new window inline within session layout definition.
  #new_window "In-line Window"
  #tmux split-window -t "$session:$window.0" -v -p 50
  
fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
