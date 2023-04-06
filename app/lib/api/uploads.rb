# frozen_string_literal: true

module API
  class Uploads < ::Grape::API
    prefix :api
    auth :api_key

    desc 'Upload image or video' do
      security [{ api_key: [] }]
    end

    params do
      optional :file, type: File
      optional :src, type: String
    end

    post :uploads do
      if params[:file]
        image_uploader = ImageUploader.upload(params[:file][:tempfile], :cache)
      elsif params[:src]
        tempfile = ImageUploader.remote_url(params[:src])
        image_uploader = ImageUploader.upload(tempfile, :cache)
      end

      # debugger

      image = lambda do
        image_uploader.derivation(:image, 200, 200).tap(&:processed).url
      end

      video = lambda do
        if ImageUploader::VIDEO_TYPES.include?(image_uploader.mime_type)
          image_uploader.derivation(:video, 200, 200).tap(&:processed).url
        end
      end

      result = {
        data: image_uploader.data,
        image_url: image.call,
        video_url: video.call
      }

      status 200
      body result

      # debugger
      # p 1

      # ----

      # result = ImageUploader.upload(image_uploader, :cache)
      # derivation = result.derivation(:thumbnail, 100, 100)
      # derivation.processed
      # status 200
      # body(data: result.data, url: derivation.url)

      # ----

      # debugger

      # NOTE: can't make this work
      # return Rack::Response.new(body.first, status, headers)
      #
      # debugger
      # result = ImageUploader.upload_response(:cache, request.env)
      # status result[0]
      # result[1].each do |k, v|
      #   header k, v
      # end
      # body JSON.parse(result[2][0])

      # ----

      # debugger

      # result = Image.new(image_remote_url: params[:src])
      #
      # status 200
      # derivation = result.image.derivation(:thumbnail, 100, 100)
      # # debugger
      # derivation.processed
      # # debugger
      # body(data: result.image_data, url: derivation.url)

      # header ?
    end
  end
end
