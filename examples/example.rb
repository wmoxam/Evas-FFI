#!/usr/bin/ruby

# In this lib we'll do a 1-1 api mapping
$LOAD_PATH.unshift(File.dirname(__FILE__) + "/..")
require 'evas'

WIDTH = 320
HEIGHT = 240

def main
  Evas::evas_init

  canvas = create_canvas(WIDTH, HEIGHT)
  raise "Cannot create canvas" unless canvas

  bg = Evas::evas_object_rectangle_add(canvas)
  Evas::evas_object_color_set(bg, 255, 255, 255, 255) # white bg
  Evas::evas_object_move(bg, 0, 0)                    # at origin
  Evas::evas_object_resize(bg, WIDTH, HEIGHT)         # covers full canvas
  Evas::evas_object_show(bg)

  puts("initial scene, with just background:")
  draw_scene(canvas)

  r1 = Evas::evas_object_rectangle_add(canvas)
  Evas::evas_object_color_set(r1, 255, 0, 0, 255) # 100% opaque red
  Evas::evas_object_move(r1, 10, 10)
  Evas::evas_object_resize(r1, 100, 100)
  Evas::evas_object_show(r1)

  # pay attention to transparency! Evas color values are pre-multiplied by
  # alpha, so 50% opaque green is:
  # non-premul: r=0, g=255, b=0    a=128 (50% alpha)
  # premul:
  #         r_premul = r * a / 255 =      0 * 128 / 255 =      0
  #         g_premul = g * a / 255 =    255 * 128 / 255 =    128
  #         b_premul = b * a / 255 =      0 * 128 / 255 =      0
  #
  # this 50% green is over a red background, so it will show in the
  # final output as yellow (green + red = yellow)
  r2 = Evas::evas_object_rectangle_add(canvas)
  Evas::evas_object_color_set(r2, 0, 128, 0, 128) # 50% opaque green
  Evas::evas_object_move(r2, 10, 10)
  Evas::evas_object_resize(r2, 50, 50)
  Evas::evas_object_show(r2)

  r3 = Evas::evas_object_rectangle_add(canvas)
  Evas::evas_object_color_set(r3, 0, 128, 0, 255) # 100% opaque dark green
  Evas::evas_object_move(r3, 60, 60)
  Evas::evas_object_resize(r3, 50, 50)
  Evas::evas_object_show(r3)

  puts("final scene (note updates):")
  draw_scene(canvas)
  save_scene(canvas, "/tmp/evas-buffer-simple-render.ppm")

  # NOTE: use ecore_evas_buffer_new() and here ecore_evas_free()
  destroy_canvas(canvas)

  Evas::evas_shutdown
end

def create_canvas(width, height)
   method = Evas::evas_render_method_lookup("buffer")
   raise "ERROR: evas was not compiled with 'buffer' engine!" if method <= 0

   canvas = Evas::evas_new
   raise "ERROR: could not instantiate new evas canvas." unless canvas

   Evas::evas_output_method_set(canvas, method)
   Evas::evas_output_size_set(canvas, width, height)
   Evas::evas_output_viewport_set(canvas, 0, 0, width, height)

   einfo_ptr = Evas::evas_engine_info_get(canvas)
   einfo = Evas::EvasEngineInfo.new(einfo_ptr)

   # ARGB32 is sizeof(int), that is 4 bytes, per pixel
   pixels = FFI::MemoryPointer.new(:int, width * height)

   einfo[:info][:depth_type] = Evas::EVAS_ENGINE_BUFFER_DEPTH_ARGB32
   einfo[:info][:dest_buffer] = pixels
   einfo[:info][:dest_buffer_row_bytes] = width * FFI::MemoryPointer.new(:int).type_size  # sizeof(int) .. not sure how to resolve
   einfo[:info][:use_color_key] = 0
   einfo[:info][:alpha_threshold] = 0
   einfo[:info][:func][:new_update_region] = nil
   einfo[:info][:func][:free_update_region] = nil
   Evas::evas_engine_info_set(canvas, einfo)

   return canvas
end

def destroy_canvas(canvas)
  einfo = Evas::evas_engine_info_get(canvas)
  if (!einfo)
    fputs("ERROR: could not get evas engine info!\n", stderr)
    Evas::evas_free(canvas)
    return
  end 

  Evas::evas_free(canvas)
end

def draw_scene(canvas)
  # render and get the updated rectangles:
  updates = Evas::evas_render_updates(canvas)

  # Can't do until we get an Eina lib ...
  #
  # informative only here, just print the updated areas:
  #EINA_LIST_FOREACH(updates, n, update)
  # printf("UPDATED REGION: pos: %3d, %3d    size: %3dx%3d\n",
  #         update[:x], update[:y], update[:w], update[:h])

  # free list of updates
  Evas::evas_render_updates_free(updates)
end

def save_scene(canvas, dest)
   einfo_ptr = Evas::evas_engine_info_get(canvas)
   einfo = Evas::EvasEngineInfo.new(einfo_ptr)

   width_ptr = FFI::MemoryPointer.new(:pointer)
   height_ptr = FFI::MemoryPointer.new(:pointer)

   Evas::evas_output_size_get(canvas, width_ptr, height_ptr)

   width = width_ptr.get_int(0)
   height = height_ptr.get_int(0)

   f = File.open(dest, "wb+")

   pixels = einfo[:info][:dest_buffer].get_array_of_int32(0, width * height)

   # PPM P6 format is dead simple to write:
   f.write sprintf("P6\n%d %d\n255\n",  width, height)
   pixels.each do |pixel|
     r = (pixel & 0xff0000) >> 16
     g = (pixel & 0x00ff00) >> 8
     b = pixel & 0x0000ff

     f.write sprintf("%c%c%c", r, g, b)
   end

   f.close
   puts "saved scene as '#{dest}'"
end

main
