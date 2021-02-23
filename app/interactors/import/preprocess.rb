# frozen_string_literal: true

module Import
  class Preprocess
    include ApplicationInteractor

    def call
      raise Feeds::Process::UnknownFileType if context.feed.downloaded_file_type.blank?

      if context.feed.file.zip?

        Rails.logger.info(
          message: 'Recreating directory',
          feed_id: context.feed.id,
          path: context.feed.file.dir.to_s
        )

        dir = context.feed.file.dir.to_s
        System.remove_entry(dir)
        FileUtils.mkdir_p(dir)
        cmd = ['unzip', '-o', context.feed.file.path.to_s, '-d', dir]

        Rails.logger.info(
          message: 'Unzipping file',
          feed_id: context.feed.id,
          file: context.feed.file.path.to_s,
          path: context.feed.file.dir.to_s,
          cmd: cmd
        )

        Open3.popen3(*cmd) do |_stdin, stdout, stderr, wait_thr|
          status = wait_thr.value
          unless status.exitstatus.zero?
            err = stderr.readlines
            out = stdout.readlines

            raise_error(out, err)
          end
        end

        pn = Pathname.new(dir)
        files = pn.children

        if files.size != 1
          Rails.logger.info(
            message: 'Error. Zip archive has more than 1 file',
            feed_id: context.feed.id,
            files: files
          )

          raise Feeds::Process::UnzipError, 'Wrong number of unpacked files'
        end

        xml_file_path = files.first
      else
        xml_file_path = context.feed.file.path
      end

      Rails.logger.info(
        message: 'Updating xml file path',
        feed_id: context.feed.id,
        xml_file_path: xml_file_path
      )

      context.feed.update!(operation: 'preprocess', xml_file_path: xml_file_path)
    end

    private

    def raise_error(out, err)
      Rails.logger.error(
        message: 'Error happened while unzipping',
        feed_id: context.feed.id,
        out: out,
        err: err
      )
      raise Feeds::Process::UnzipError, [out, err].reject(&:blank?).join("\r\n")
    end
  end
end
