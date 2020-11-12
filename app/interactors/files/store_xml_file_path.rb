# frozen_string_literal: true

module Files
  class StoreXmlFilePath
    include ApplicationInteractor

    def call
      if context.feed.file.zip?
        dir = context.feed.file.dir.to_s
        debugger
        System.remove_entry(dir)
        FileUtils.mkdir_p(dir)
        cmd = ['unzip', '-o', context.feed.file.path.to_s, '-d', dir]
        Open3.popen3(*cmd) do |_stdin, stdout, stderr, wait_thr|
          status = wait_thr.value
          unless status.exitstatus.zero?
            err = stderr.readlines
            out = stdout.readlines
            raise Feeds::Process::UnzipError, [err, out].reject(&:blank?).join("\r\n")
          end
        end

        pn = Pathname.new(dir)
        ls = pn.children
        if ls.size != 1
          raise Feeds::Process::UnzipError, 'Wrong number of unpacked files'
        end

        context.feed.update!(xml_file_path: ls.first)
      else
        context.feed.update!(xml_file_path: context.feed.file.path)
      end
    end
  end
end
