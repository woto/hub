# frozen_string_literal: true

class Profile::MessengersCollectionInput < SimpleForm::Inputs::Base
  def input(_wrapper_options)
    @builder.template.render 'inputs/profiles/messengers_collection', object: object, builder: @builder
  end
end
