return {
  'sphamba/smear-cursor.nvim',

  opts = {
    cursor_color = '#ffffff',
    stiffness = 0.5,
    trailing_stiffness = 0.4,
    damping = 0.6,
    never_draw_over_target = true, -- if you want to actually see under the cursor
    hide_target_hack = true, -- same
  },
}
