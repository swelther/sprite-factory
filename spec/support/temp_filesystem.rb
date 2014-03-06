require 'fileutils'
module TempFilesystemHelper
  Root = File.expand_path('../../../tmp/fs', __FILE__)

  class FS
    def initialize(root=Root, &block)
      @root = root
      @block = block
    end

    def run
      create_root
      @block.call(self)
      cleanup
    end

    def mkdir(path)
      full = join path
      FileUtils.mkdir_p full
      full
    end

    def mkfile(path, content='')
      full = join path
      mkdir File.dirname(path)
      if content.nil? || content.empty?
        FileUtils.touch full
      else
        File.open(full, 'w') { |f| f.write content }
      end
      full
    end

    def join(path)
      File.join(@root, path)
    end

    private
    def create_root
      FileUtils.mkdir_p @root
    end

    def cleanup
      FileUtils.rm_rf @root
    end
  end

  def temp_filesystem(&block)
    FS.new(&block).run
  end

end

Rspec.configure do |conf|
  conf.include TempFilesystemHelper
end
