require 'ffi'

module Evas
  extend FFI::Library
  ffi_lib 'evas'

  EVAS_ENGINE_BUFFER_DEPTH_ARGB32 = 0
  EVAS_ENGINE_BUFFER_DEPTH_BGRA32 = 1
  EVAS_ENGINE_BUFFER_DEPTH_RGB24 = 2
  EVAS_ENGINE_BUFFER_DEPTH_BGR24 = 3
  EVAS_ENGINE_BUFFER_DEPTH_RGB32 = 4


  # I haven't found documentation for this, just went from the example
  class EvasFunc < FFI::Struct
    layout :new_update_region, :pointer,
           :free_update_region, :pointer
  end

  # Haven't found docs for this either ..
  class EvasEngineInfoBuffer < FFI::Struct
    layout :depth_type, :int,
	   :dest_buffer, :pointer,
           :dest_buffer_row_bytes, :int,
           :use_color_key, :int,
           :alpha_threshold, :int,
           :func, EvasFunc
  end

  class EvasEngineInfo < FFI::Struct
    layout :magic, :int,
           :info, EvasEngineInfoBuffer
  end

  EvasCallbackType = enum( :mouse_in, #  The following events are only for use with objects
                            :mouse_out, #  evas_object_event_callback_add()
                            :mouse_down,
                            :mouse_up,
                            :mouse_move,
                            :mouse_wheel,
                            :multi_touch_down,  
                            :multi_touch_up,
                            :multi_touch_move,
                            :free,
                            :key_down,
                            :key_up,
                            :focus_in,
                            :focus_out,
                            :show,
                            :hide,
                            :move,
                            :resize,
                            :restack,
                            :del, # happens before free
                            :hold,
                            :changed_size_hints,
                            :image_preloaded,
                            :canvas_focus_in, # The following events are only for use with canvas
                            :canvas_focus_out, # evas_event_callback_add()
                            :render_flush_pre,
                            :render_flush_post,
                            :canvas_object_focus_in,
                            :canvas_object_focus_out,
                            :image_unloaded,
                            :last) # not really an event

  EvasAllocError = enum( :none, 0, 
                         :fatal, 
                         :recovered)

  # Top Level Functions
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Group.html

  callback :async_events_put_cb, [:pointer, EvasCallbackType, :pointer], :void

  attach_function :evas_async_events_fd_get, [:void], :int
  attach_function :evas_async_events_process, [:void], :int
  attach_function :evas_async_events_put, [:pointer, EvasCallbackType, :pointer, :async_events_put_cb], :int
  attach_function :evas_init, [], :void
  attach_function :evas_shutdown, [], :void
  attach_function :evas_alloc_error, [:void], EvasAllocError
  
  # Basic Object Manipulation
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Object__Group__Basic.html

  attach_function :evas_object_clip_set, [:pointer, :pointer], :void
  attach_function :evas_object_clip_get, [:pointer], :pointer
  attach_function :evas_object_clip_unset, [:pointer], :void
  attach_function :evas_object_clipees_get, [:pointer], :pointer
  attach_function :evas_object_focus_set, [:pointer, :int], :void
  attach_function :evas_object_focus_get, [:pointer], :int
  attach_function :evas_object_layer_set, [:pointer, :short], :void
  attach_function :evas_object_layer_get, [:pointer], :short
  attach_function :evas_object_name_set, [:pointer, :pointer], :void
  attach_function :evas_object_name_get, [:pointer], :pointer
  attach_function :evas_object_del, [:pointer], :void
  attach_function :evas_object_move, [:pointer, :int, :int], :void
  attach_function :evas_object_resize, [:pointer, :int, :int], :void
  attach_function :evas_object_geometry_get, [:pointer, :pointer, :pointer, :pointer, :pointer], :void
  attach_function :evas_object_show, [:pointer], :void
  attach_function :evas_object_hide, [:pointer], :void
  attach_function :evas_object_visible_get, [:pointer], :int
  attach_function :evas_object_color_set, [:pointer, :int, :int, :int, :int], :void
  attach_function :evas_object_color_get, [:pointer, :pointer, :pointer, :pointer, :pointer], :void
  attach_function :evas_object_evas_get, [:pointer], :pointer
  attach_function :evas_object_type_get, [:pointer], :pointer
  attach_function :evas_object_raise, [:pointer], :void
  attach_function :evas_object_lower, [:pointer], :void
  attach_function :evas_object_stack_above, [:pointer, :pointer], :void
  attach_function :evas_object_stack_below, [:pointer, :pointer], :void
  attach_function :evas_object_above_get, [:pointer], :pointer
  attach_function :evas_object_below_get, [:pointer], :pointer

  # Object Events
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Object__Group__Events.html

                             # data, Evas, Evas_Object, event_info 
  callback :object_event_cb, [:pointer, :pointer, :pointer, :pointer], :void

  attach_function :evas_object_event_callback_add, [:pointer, EvasCallbackType, :object_event_cb, :pointer], :void 
  attach_function :evas_object_event_callback_del, [:pointer, EvasCallbackType, :object_event_cb], :void
  attach_function :evas_object_event_callback_del_full, [:pointer, EvasCallbackType, :object_event_cb, :pointer], :void
  attach_function :evas_object_pass_events_set, [:pointer, :int], :void
  attach_function :evas_object_pass_events_get, [:pointer], :int
  attach_function :evas_object_repeat_events_set, [:pointer, :int], :void
  attach_function :evas_object_repeat_events_get, [:pointer], :int
  attach_function :evas_object_propagate_events_set, [:pointer, :int], :void
  attach_function :evas_object_propagate_events_get, [:pointer], :int

  # UV Mapping
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Object__Group__Map.html

  # Size Hints
  # http://docs.enlightenment.org/auto/evas/group__Evas__Object__Group__Size__Hints.html

  EvasAspectControl = enum( :none, 0,
                            :neither,
                            :horizontal,
                            :vertical,
                            :both)

  attach_function :evas_object_size_hint_min_get, [:pointer, :pointer, :pointer], :void
  attach_function :evas_object_size_hint_min_set, [:pointer, :int, :int], :void
  attach_function :evas_object_size_hint_max_get, [:pointer, :pointer, :pointer], :void
  attach_function :evas_object_size_hint_max_set, [:pointer, :int, :int], :void
  attach_function :evas_object_size_hint_request_get, [:pointer, :pointer, :pointer], :void
  attach_function :evas_object_size_hint_request_set, [:pointer, :int, :int], :void
  attach_function :evas_object_size_hint_aspect_get, [:pointer, :pointer, :pointer, :pointer], :void
  attach_function :evas_object_size_hint_aspect_set, [:pointer, EvasAspectControl, :int, :int], :void
  attach_function :evas_object_size_hint_align_get, [:pointer, :pointer, :pointer], :void
  attach_function :evas_object_size_hint_align_set, [:pointer, :double, :double], :void
  attach_function :evas_object_size_hint_weight_get, [:pointer, :pointer, :pointer], :void
  attach_function :evas_object_size_hint_weight_set, [:pointer, :double, :double], :void
  attach_function :evas_object_size_hint_padding_set, [:pointer, :int, :int, :int, :int], :void

  # Extra Object Manipulation
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Object__Group__Extras.html

  EvasObjectPointerMode = enum(:autograb, :nograb)
  EvasRenderOp = enum( :blend, 0,
                       :blend_rel,
                       :copy,
                       :copy_rel,
                       :add,
                       :add_rel,
                       :sub,
                       :sub_rel,
                       :tint,
                       :tint_rel,
                       :mask,
                       :mul)

  attach_function :evas_object_data_set, [:pointer, :pointer, :pointer], :void
  attach_function :evas_object_data_get, [:pointer, :pointer], :pointer
  attach_function :evas_object_data_del, [:pointer, :pointer], :pointer
  attach_function :evas_object_pointer_mode_set, [:pointer, EvasObjectPointerMode], :void
  attach_function :evas_object_pointer_mode_get, [:pointer], EvasObjectPointerMode
  attach_function :evas_object_anti_alias_set, [:pointer, :int], :void
  attach_function :evas_object_anti_alias_get, [:pointer], :int
  attach_function :evas_object_scale_set, [:pointer, :double], :void
  attach_function :evas_object_scale_get, [:pointer], :double
  attach_function :evas_object_render_op_set, [:pointer, EvasRenderOp], :void
  attach_function :evas_object_render_op_get, [:pointer], EvasRenderOp
  attach_function :evas_object_precise_is_inside_set, [:pointer, :int], :void
  attach_function :evas_object_precise_is_inside_get, [:pointer], :int
  attach_function :evas_object_static_clip_set, [:pointer, :int], :void
  attach_function :evas_object_static_clip_get, [:pointer], :int

  # Finding Objects
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Object__Group__Find.html
  
  attach_function :evas_focus_get, [:pointer], :pointer
  attach_function :evas_object_name_find, [:pointer, :pointer], :pointer
  attach_function :evas_object_top_at_xy_get, [:pointer, :int, :int, :int], :pointer
  attach_function :evas_object_top_at_pointer_get, [:pointer], :pointer
  attach_function :evas_object_top_in_rectangle_get, [:pointer, :int, :int, :int, :int, :int, :int], :pointer
  attach_function :evas_objects_at_xy_get, [:pointer, :int, :int, :int, :int], :pointer
  attach_function :evas_objects_in_rectangle_get, [:pointer, :int, :int, :int, :int, :int, :int], :pointer
  attach_function :evas_object_bottom_get, [:pointer], :pointer
  attach_function :evas_object_top_get, [:pointer], :pointer 

  # Object Method Interceptors
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Object__Group__Interceptors.html

  callback :intercept_show_cb, [:pointer, :pointer], :void
  callback :intercept_hide_cb, [:pointer, :pointer], :void
  callback :intercept_move_cb, [:pointer, :pointer, :int, :int], :void
  callback :intercept_resize_cb, [:pointer, :pointer, :int, :int], :void
  callback :intercept_raise_cb, [:pointer, :pointer], :void
  callback :intercept_lower_cb, [:pointer, :pointer], :void
  callback :intercept_stack_above_cb, [:pointer, :pointer, :pointer], :void
  callback :intercept_stack_below_cb, [:pointer, :pointer, :pointer], :void
  callback :intercept_layer_set_cb, [:pointer, :pointer, :int], :void
  callback :intercept_color_set_cb, [:pointer, :pointer, :int, :int, :int, :int], :void
  callback :intercept_clip_set_cb, [:pointer, :pointer, :pointer], :void
  callback :intercept_clip_unset_cb, [:pointer, :pointer], :void

  attach_function :evas_object_intercept_show_callback_add, [:pointer, :intercept_show_cb, :pointer], :void
  attach_function :evas_object_intercept_show_callback_del, [:pointer, :intercept_show_cb], :pointer
  attach_function :evas_object_intercept_hide_callback_add, [:pointer, :intercept_hide_cb], :void
  attach_function :evas_object_intercept_hide_callback_del, [:pointer, :intercept_hide_cb], :pointer
  attach_function :evas_object_intercept_move_callback_add, [:pointer, :intercept_move_cb, :pointer], :void
  attach_function :evas_object_intercept_move_callback_del, [:pointer, :intercept_move_cb], :pointer
  attach_function :evas_object_intercept_resize_callback_add, [:pointer, :intercept_resize_cb, :pointer], :void
  attach_function :evas_object_intercept_resize_callback_del, [:pointer, :intercept_resize_cb], :pointer
  attach_function :evas_object_intercept_raise_callback_add, [:pointer, :intercept_raise_cb, :pointer], :void
  attach_function :evas_object_intercept_raise_callback_del, [:pointer, :intercept_raise_cb], :pointer
  attach_function :evas_object_intercept_lower_callback_add, [:pointer, :intercept_lower_cb, :pointer], :void
  attach_function :evas_object_intercept_lower_callback_del, [:pointer, :intercept_lower_cb], :pointer
  attach_function :evas_object_intercept_stack_above_callback_add, [:pointer, :intercept_stack_above_cb, :pointer], :void
  attach_function :evas_object_intercept_stack_above_callback_del, [:pointer, :intercept_stack_above_cb], :pointer
  attach_function :evas_object_intercept_stack_below_callback_add, [:pointer, :intercept_stack_below_cb, :pointer], :void
  attach_function :evas_object_intercept_stack_below_callback_del, [:pointer, :intercept_stack_below_cb], :pointer
  attach_function :evas_object_intercept_layer_set_callback_add, [:pointer, :intercept_layer_set_cb, :pointer], :void
  attach_function :evas_object_intercept_layer_set_callback_del, [:pointer, :intercept_layer_set_cb], :pointer
  attach_function :evas_object_intercept_color_set_callback_add, [:pointer, :intercept_color_set_cb, :pointer], :void
  attach_function :evas_object_intercept_color_set_callback_del, [:pointer, :intercept_color_set_cb], :pointer
  attach_function :evas_object_intercept_clip_set_callback_add, [:pointer, :intercept_clip_set_cb, :pointer], :void
  attach_function :evas_object_intercept_clip_set_callback_del, [:pointer, :intercept_clip_set_cb], :pointer
  attach_function :evas_object_intercept_clip_unset_callback_add, [:pointer, :intercept_clip_unset_cb, :pointer], :void
  attach_function :evas_object_intercept_clip_unset_callback_del, [:pointer, :intercept_clip_unset_cb], :pointer

  # Rectangle Object Functions
  # http://docs.enlightenment.org/auto/evas/group__Evas__Object__Rectangle.html

  attach_function :evas_object_rectangle_add, [:pointer], :pointer

  # Image Object Functions
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Object__Image.html

  callback :image_pixels_get_cb, [:pointer, :pointer], :void

  EvasBorderFillMode = enum( :none, 0,
                             :default,
                             :solid )

  EvasFillSpread = enum( :reflect, 0,
                         :repeat,
                         :restrict,
                         :restrict_reflect,
                         :restrict_repeat,
                         :pad )

  EvasLoadError = enum( :none, 0,
                        :generic,
                        :does_not_exist,
                        :permission_denied,
                        :resource_allocation_failed,
                        :corrupt_file,
                        :unknown_format )

  EvasImageContentHint = enum( :none, 0,
                               :dynamic,
                               :static ) 

  EvasImageScaleHint = enum( :none, 0,
                             :dynamic,
                             :static )

  EvasColorspace = enum( :argb8888,
                         :ycbcr422p601_pl,
                         :ycbcr422p709_pl,
                         :rgb565_a5p,
                         :gry8 )

  attach_function :evas_object_image_add, [:pointer], :pointer
  attach_function :evas_object_image_filled_add, [:pointer], :pointer
  attach_function :evas_object_image_file_set, [:pointer, :pointer, :pointer], :void
  attach_function :evas_object_image_file_get, [:pointer, :pointer, :pointer], :void  
  attach_function :evas_object_image_source_set, [:pointer, :pointer], :void  
  attach_function :evas_object_image_source_get, [:pointer], :pointer  
  attach_function :evas_object_image_source_unset, [:pointer], :int  
  attach_function :evas_object_image_border_set, [:pointer, :int, :int, :int, :int], :void  
  attach_function :evas_object_image_border_get, [:pointer, :pointer, :pointer, :pointer, :pointer], :void
  attach_function :evas_object_image_border_center_fill_set, [:pointer, EvasBorderFillMode], :void
  attach_function :evas_object_image_border_center_fill_get, [:pointer], EvasBorderFillMode  
  attach_function :evas_object_image_filled_set, [:pointer, :int], :void 
  attach_function :evas_object_image_filled_get, [:pointer], :int  
  attach_function :evas_object_image_border_scale_set, [:pointer, :double], :void  
  attach_function :evas_object_image_border_scale_get, [:pointer], :double  
  attach_function :evas_object_image_fill_set, [:pointer, :int, :int, :int, :int], :void
  attach_function :evas_object_image_fill_get, [:pointer, :pointer, :pointer, :pointer, :pointer], :void  
  attach_function :evas_object_image_fill_spread_set, [:pointer, EvasFillSpread], :void
  attach_function :evas_object_image_fill_spread_get, [:pointer], EvasFillSpread 
  attach_function :evas_object_image_size_set, [:pointer, :int, :int], :void  
  attach_function :evas_object_image_size_get, [:pointer, :pointer, :pointer], :void 
  attach_function :evas_object_image_stride_get, [:pointer], :int 
  attach_function :evas_object_image_load_error_get, [:pointer], EvasLoadError 
  attach_function :evas_object_image_data_convert, [:pointer, EvasColorspace], :pointer 
  attach_function :evas_object_image_data_set, [:pointer, :pointer], :void 
  attach_function :evas_object_image_data_get, [:pointer, :int], :pointer  
  attach_function :evas_object_image_preload, [:pointer, :int], :void  
  attach_function :evas_object_image_data_copy_set, [:pointer, :pointer], :void 
  attach_function :evas_object_image_data_update_add, [:pointer, :int, :int, :int, :int], :void 
  attach_function :evas_object_image_alpha_set, [:pointer, :int], :void 
  attach_function :evas_object_image_alpha_get, [:pointer], :int
  attach_function :evas_object_image_smooth_scale_set, [:pointer, :int], :void
  attach_function :evas_object_image_smooth_scale_get, [:pointer], :int
  attach_function :evas_object_image_reload, [:pointer], :void
  attach_function :evas_object_image_save, [:pointer, :pointer, :pointer, :pointer], :int
  attach_function :evas_object_image_pixels_import, [:pointer, :pointer], :int
  attach_function :evas_object_image_pixels_get_callback_set, [:pointer, :image_pixels_get_cb, :pointer], :void
  attach_function :evas_object_image_pixels_dirty_set, [:pointer, :int], :void
  attach_function :evas_object_image_pixels_dirty_get, [:pointer], :int
  attach_function :evas_object_image_load_dpi_set, [:pointer, :double], :void
  attach_function :evas_object_image_load_dpi_get, [:pointer], :double
  attach_function :evas_object_image_load_size_set, [:pointer, :int, :int], :void
  attach_function :evas_object_image_load_size_get, [:pointer, :pointer, :pointer], :void
  attach_function :evas_object_image_load_scale_down_set, [:pointer, :int], :void
  attach_function :evas_object_image_load_scale_down_get, [:pointer], :int
  attach_function :evas_object_image_colorspace_set, [:pointer, EvasColorspace], :void
  attach_function :evas_object_image_colorspace_get, [:pointer], EvasColorspace
  attach_function :evas_object_image_native_surface_set, [:pointer, :pointer], :void
  attach_function :evas_object_image_native_surface_get, [:pointer], :pointer
  attach_function :evas_object_image_scale_hint_set, [:pointer, EvasImageScaleHint], :void
  attach_function :evas_object_image_scale_hint_get, [:pointer], EvasImageScaleHint
  attach_function :evas_object_image_content_hint_set, [:pointer, EvasImageContentHint], :void
  attach_function :evas_object_image_content_hint_get, [:pointer], EvasImageContentHint
  attach_function :evas_object_image_alpha_mask_set, [:pointer, :int], :void

  # Text Object Functions
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Object__Text.html

  EvasBiDiDirection = enum( :natural,
                            :ltr,
                            :rtl )

  EvasTextStyleType = enum( :plain,
                            :shadow,
                            :outline,
                            :soft_outline,
                            :glow,
                            :outline_shadow,
                            :far_shadow,
                            :outline_soft_shadow,
                            :soft_shadow,
                            :far_soft_shadow )

  attach_function :evas_object_text_add, [:pointer], :pointer
  attach_function :evas_object_text_font_source_set, [:pointer, :pointer], :void
  attach_function :evas_object_text_font_source_get, [:pointer], :pointer
  attach_function :evas_object_text_font_set, [:pointer, :pointer, :int], :void
  attach_function :evas_object_text_font_get, [:pointer, :pointer, :pointer], :void
  attach_function :evas_object_text_text_set, [:pointer, :pointer], :void
  attach_function :evas_object_text_text_get, [:pointer], :pointer
  attach_function :evas_object_text_direction_get, [:pointer], EvasBiDiDirection
  attach_function :evas_object_text_ascent_get, [:pointer], :int
  attach_function :evas_object_text_descent_get, [:pointer], :int
  attach_function :evas_object_text_max_ascent_get, [:pointer], :int
  attach_function :evas_object_text_max_descent_get, [:pointer], :int
  attach_function :evas_object_text_inset_get, [:pointer], :int
  attach_function :evas_object_text_horiz_advance_get, [:pointer], :int
  attach_function :evas_object_text_vert_advance_get, [:pointer], :int
  attach_function :evas_object_text_char_pos_get, [:pointer, :pointer, :pointer, :pointer, :pointer], :int
  attach_function :evas_object_text_last_up_to_pos, [:pointer, :int, :int], :int
  attach_function :evas_object_text_char_coords_get, [:pointer, :int, :int, :pointer, :pointer, :pointer, :pointer], :int
  attach_function :evas_object_text_style_set, [:pointer, EvasTextStyleType], :void
  attach_function :evas_object_text_style_get, [:pointer], EvasTextStyleType
  attach_function :evas_object_text_shadow_color_set, [:pointer, :int, :int, :int, :int], :void
  attach_function :evas_object_text_shadow_color_get, [:pointer, :pointer, :pointer, :pointer, :pointer], :void
  attach_function :evas_object_text_glow_color_set, [:pointer, :int, :int, :int, :int], :void
  attach_function :evas_object_text_glow_color_get, [:pointer, :pointer, :pointer, :pointer, :pointer], :void
  attach_function :evas_object_text_glow2_color_set, [:pointer, :int, :int, :int, :int], :void
  attach_function :evas_object_text_glow2_color_get, [:pointer, :pointer, :pointer, :pointer, :pointer], :void
  attach_function :evas_object_text_outline_color_set, [:pointer, :int, :int, :int, :int], :void
  attach_function :evas_object_text_outline_color_get, [:pointer, :pointer, :pointer, :pointer, :pointer], :void
  attach_function :evas_object_text_style_pad_get, [:pointer], :void

  # Textblock Object Functions
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Object__Textblock.html

  # Line Object Functions
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Line__Group.html

  # Polygon Object Functions
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Object__Polygon.html
  

  # Smart Object Functions
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Smart__Object__Group.html

  # Smart Functions
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Smart__Group.html

  # Clipped Smart Functions
  # http://docs.enlightenment.org/auto/evas/group__Evas__Smart__Object__Clipped.html

  # Box Smart Object
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Object__Box.html

  # Table Smart Object
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Object__Table.html
  
  # Canvas Functions
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Canvas.html

  attach_function :evas_new, [], :pointer
  attach_function :evas_free, [:pointer], :void
  attach_function :evas_damage_rectangle_add, [:pointer, :int, :int, :int, :int], :void
  attach_function :evas_data_attach_get, [:pointer], :pointer
  attach_function :evas_data_attach_set, [:pointer, :pointer], :pointer
  attach_function :evas_focus_in, [:pointer], :void
  attach_function :evas_focus_out, [:pointer], :void
  attach_function :evas_focus_state_get, [:pointer], :int
  attach_function :evas_nochange_push, [:pointer], :void
  attach_function :evas_nochange_pop, [:pointer], :void
  attach_function :evas_norender, [:pointer], :void
  attach_function :evas_object_rectangle_add, [:pointer], :pointer
  attach_function :evas_object_color_set, [:pointer, :int, :int, :int, :int], :void
  attach_function :evas_object_move, [:pointer, :int, :int], :void
  attach_function :evas_object_resize, [:pointer, :int, :int], :void
  attach_function :evas_object_show, [:pointer], :void
  attach_function :evas_obscured_rectangle_add, [:pointer, :int, :int, :int, :int], :void
  attach_function :evas_obscured_clear, [:pointer], :void
  attach_function :evas_output_size_get, [:pointer, :pointer, :pointer], :void
  attach_function :evas_output_size_set, [:pointer, :int, :int], :void
  attach_function :evas_output_viewport_set, [:pointer, :int, :int, :int, :int], :void
  attach_function :evas_render, [:pointer], :void
  attach_function :evas_render_idle_flush, [:pointer], :void
  attach_function :evas_render_updates_free, [:pointer], :void
  attach_function :evas_render_updates, [:pointer], :pointer

  # Render Engine Methods
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Output__Method.html
  
  attach_function :evas_output_method_set, [:pointer, :int], :void
  attach_function :evas_output_method_get, [:pointer], :int
  attach_function :evas_engine_info_get, [:pointer], :pointer
  attach_function :evas_engine_info_set, [:pointer, :pointer], :int
  attach_function :evas_render_method_lookup, [:pointer], :int
  attach_function :evas_render_method_list, [:void], :pointer
  attach_function :evas_render_method_list_free, [:pointer], :void

  # Output and Viewport Resizing Functions
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Output__Size.html

  # Coordinate Mapping Functions
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Coord__Mapping__Group.html

  # Pointer Functions
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Pointer__Group.html

  # Event Freezing Functions
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Event__Freezing__Group.html

  # Event Feeding Functions
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Event__Feeding__Group.html

  # Canvas Events
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Canvas__Events.html

  # Image Functions
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Image__Group.html

  # Font Functions
  # See: http://docs.enlightenment.org/auto/evas/group__Evas__Font__Group.html

  # Shared Image Cache Server
  # http://docs.enlightenment.org/auto/evas/group__Evas__Cserve.html

  # General Utilities
  # http://docs.enlightenment.org/auto/evas/group__Evas__Utils.html
end
