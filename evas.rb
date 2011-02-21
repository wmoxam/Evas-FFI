require 'ffi'

module Evas
  extend FFI::Library
  ffi_lib 'evas'

  EVAS_ENGINE_BUFFER_DEPTH_ARGB32 = 0
  EVAS_ENGINE_BUFFER_DEPTH_BGRA32 = 1
  EVAS_ENGINE_BUFFER_DEPTH_RGB24 = 2
  EVAS_ENGINE_BUFFER_DEPTH_BGR24 = 3
  EVAS_ENGINE_BUFFER_DEPTH_RGB32 = 4

  class EvasFunc < FFI::Struct
    layout :new_update_region, :pointer,
           :free_update_region, :pointer
  end

  class EvasEngineInfoBuffer < FFI::Struct
    layout :depth_type, :int,
	   :dest_buffer, :pointer,
           :dest_buffer_row_bytes, :int,
           :use_color_key, :int,
           :alpha_threshold, :int,
           :func, EvasFunc # ??? wtf
  end

  class EvasEngineInfo < FFI::Struct
    layout :magic, :int,
           :info, EvasEngineInfoBuffer
  end

  attach_function :evas_init, [], :void
  attach_function :evas_render_method_lookup, [:string], :int
  attach_function :evas_new, [], :pointer
  attach_function :evas_output_method_set, [:pointer, :int], :void
  attach_function :evas_output_size_set, [:pointer, :int, :int], :void
  attach_function :evas_output_viewport_set, [:pointer, :int, :int, :int, :int], :void
  attach_function :evas_engine_info_get, [:pointer], :pointer
  attach_function :evas_engine_info_set, [:pointer, :pointer], :void
  attach_function :evas_object_rectangle_add, [:pointer], :pointer
  attach_function :evas_object_color_set, [:pointer, :int, :int, :int, :int], :void
  attach_function :evas_object_move, [:pointer, :int, :int], :void
  attach_function :evas_object_resize, [:pointer, :int, :int], :void
  attach_function :evas_object_show, [:pointer], :void
  attach_function :evas_render_updates, [:pointer], :pointer
  attach_function :evas_render_updates_free, [:pointer], :void
  attach_function :evas_output_size_get, [:pointer, :pointer, :pointer], :void
  attach_function :evas_free, [:pointer], :void
  attach_function :evas_shutdown, [], :void
end
