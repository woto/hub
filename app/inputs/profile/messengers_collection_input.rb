class Profile::MessengersCollectionInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    @builder.template.render 'inputs/profiles/messengers_collection', object: object, builder: @builder
  end
end
