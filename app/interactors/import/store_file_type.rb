# frozen_string_literal: true

module Import
  class StoreFileType
    include ApplicationInteractor

    def call
      cmd = ['file', '-b', '--mime-type', context.feed.file.path]

      Rails.logger.info(
        message: 'Detecting file type',
        feed_id: context.feed.id,
        path: context.feed.file.path,
        cmd: cmd
      )

      Open3.popen3(*cmd) do |_stdin, stdout, stderr, wait_thr|
        status = wait_thr.value

        out = stdout.readlines.join.chomp
        err = stderr.readlines.join.chomp

        raise_error(out, err) unless status.exitstatus.zero?
        raise_error(out, err) if out.include?('No such file or directory')

        Rails.logger.info(
          message: 'Updating file type',
          feed_id: context.feed.id,
          downloaded_file_type: out
        )

        context.feed.update!(downloaded_file_type: out)
      end
    end

    private

    def raise_error(out, err)
      raise Feeds::Process::DetectFileTypeError, [out, err].reject(&:blank?).join("\r\n")
    end
  end
end
