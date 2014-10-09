module Epub
  module Tempfile
    def self.create(stream, &block)
      converted_epub_file = ::Tempfile.new ["converted_manuscript", ".epub"]
      converted_epub_file.binmode
      converted_epub_file.write stream
      converted_epub_file.close
      block.call(converted_epub_file)
      converted_epub_file.unlink
    end
  end
end
