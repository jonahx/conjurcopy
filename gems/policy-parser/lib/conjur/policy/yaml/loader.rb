class Object
  # Dear Ruby, I wish instance variables order was stable, because if it was
  # then YAML would always come out the same.
  def to_yaml_properties
    instance_variables.sort
  end
end

module Conjur
  module PolicyParser
    module YAML
      class Loader
        class << self
          def load yaml, filename = nil
            dirname = if filename
              File.dirname(filename)
            else
              '.'
            end
            
            parser = Psych::Parser.new(handler = Handler.new)
            handler.filename = filename
            handler.parser = parser
            begin
              parser.parse(yaml)
            rescue
              handler.log { $!.message }
              handler.log { $!.backtrace.join("  \n") }
              raise Invalid.new($!.message || "(no message)", filename, parser.mark)
            end
            records = handler.result || []
            
            parse_includes records, dirname
  
            records
          end
          
          def load_file filename
            load File.read(filename), filename
          end
          
          protected
          
          def parse_includes records, dirname
            records.each_with_index do |record, idx|
              if record.is_a?(Array)
                parse_includes record, dirname
              elsif record.is_a?(Types::Policy)
                parse_includes record.body, dirname
              elsif record.is_a?(Types::Include)
                included = load File.read(File.expand_path(record.file, dirname)), record.file
                records[idx..idx] = included
              end
            end
          end
        end
      end
    end
  end
end
