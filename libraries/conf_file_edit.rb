module Conf
  class ConfFileEdit < Chef::Util::FileEdit
    attr_accessor :file_edited

    private

    def search_match(regex, replace, command, method)

      #convert regex to a Regexp object (if not already is one) and store it in exp.
      exp = Regexp.new(regex)

      #loop through contents and do the appropriate operation depending on 'command' and 'method'
      new_contents = []

      matched = false

      contents.each do |line|
        if line.match(exp)
          matched = true
          case command
          when 'r'
            new_contents << ((method == 1) ? replace : line.gsub(exp, replace))
            self.file_edited = true
          when 'd'
            new_contents << line.gsub(exp, "") if method == 2
            self.file_edited = true
          when 'i'
            new_contents << line
            unless method == 2
              new_contents << replace
              self.file_edited = true
            end
          end
        else
          new_contents << line
        end
      end
      if command == 'i' && method == 2 && ! matched
        new_contents << replace
        self.file_edited = true
      end

      self.contents = new_contents
    end
  end
end
