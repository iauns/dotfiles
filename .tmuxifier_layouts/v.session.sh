session_root "~/sci"

if initialize_session "v"; then

  load_window "v720"
  select_window "v720"

  # Create a new window inline within session layout definition.
  #new_window "In-line Window"
  #tmux split-window -t "$session:$window.0" -v -p 50
  
fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
