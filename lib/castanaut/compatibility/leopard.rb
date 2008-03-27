module Castanaut; module Compatibility
  
  class Leopard < MacOSX
    
    def initialize(movie)
      super(movie)
      
      perms_test
    end
    
    def to_s
      "Mac OS 10.5 (Leopard)"
    end
    
    def cursor(dst_loc)
      automatically "mousemove #{dst_loc[:x]} #{dst_loc[:y]}"
    end
    
    def click(btn)
      automatically "mouseclick #{mouse_button_translate(btn)}"
    end
    
    def doubleclick(btn)
      automatically "mousedoubleclick #{mouse_button_translate(btn)}"
    end
    
    def tripleclick(btn)
      automatically "mousetripleclick #{mouse_button_translate(btn)}"
    end
    
    def mousedown(btn)
      automatically "mousedown #{mouse_button_translate(btn)}"
    end
    
    def mouseup(btn)
      automatically "mouseup #{mouse_button_translate(btn)}"
    end
    
    def drag(*options)
      options = combine_options(*options)
      apply_offset(options)
      automatically "mousedrag #{options[:to][:left]} #{options[:to][:top]}"
    end
    
    def type(str, opts)
      puts "Warning: #{this.to_s} does not support additional options for the 'type' method." unless opts.keys.empty?
      automatically "type #{str}"
    end
    
    def hit(key, *modifiers)
      puts "Warning: #{this.to_s} does not support modifier keys for the 'hit' method." unless modifiers.empty?
      automatically "hit #{key}"
    end
    
  protected
    def automatically(cmd)
      movie.run("#{osxautomation_path} \"#{cmd}\"")
    end
    
  private
    def movie
      
    end
  
    def perms_test
      return if File.executable?(osxautomation_path)
      puts "IMPORTANT: Castanaut has recently been installed or updated. " +
        "You need to give it the right to control mouse and keyboard " +
        "input during screenplays."

      run("sudo chmod a+x #{osxautomation_path}")

      if File.executable?(osxautomation_path)
        puts "Permission granted. Thanks."
      else
        raise Castanaut::Exceptions::OSXAutomationPermissionError
      end
    end
  
    def osxautomation_path
      File.join(PATH, "cbin", "osxautomation")
    end
    
    def mouse_button_translate(btn)
      return btn if btn.is_a?(Integer)
      {"left" => 1, "right" => 2, "middle" => 3}[btn]
    end
    
  end
end; end