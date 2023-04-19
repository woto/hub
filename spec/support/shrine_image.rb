# frozen_string_literal: true

module ShrineImage
  module_function

  def image_data
    attacher = Shrine::Attacher.new
    attacher.set(uploaded_image)

    # # if you're processing derivatives
    # attacher.set_derivatives(
    #   large:  uploaded_image,
    #   medium: uploaded_image,
    #   small:  uploaded_image,
    # )

    attacher.data # or attacher.data in case of postgres jsonb column
  end

  def uploaded_image
    file = File.open(Rails.root.join('spec/fixtures/files/avatar.png'), binmode: true)

    # # for performance we skip metadata extraction and assign test metadata
    uploaded_file = Shrine.upload(file, :store, metadata: false)
    uploaded_file.metadata.merge!(
      'size' => '1751',
      'mime_type' => 'image/jpeg',
      'filename' => 'test.jpg',
      'width' => '191',
      'height' => '264'
    )

    uploaded_file
  end
end
