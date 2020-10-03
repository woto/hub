# frozen_string_literal: true

class Files::StoreFileType
  include ApplicationInteractor

  def call
    cmd = ['file', '-b', '--mime-type', context.feed.file.path]
    Open3.popen3(*cmd) do |_stdin, stdout, stderr, wait_thr|
      status = wait_thr.value
      out = stdout.readlines.join.chomp
      unless status.exitstatus.zero?
        err = stderr.readlines.join.chomp
        raise Feeds::Process::DetectFileTypeError, [err, out].reject(&:blank?).join("\r\n")
      end
      context.feed.update!(downloaded_file_type: out)
    end
  end
end
