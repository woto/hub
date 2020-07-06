# frozen_string_literal: true

class Settings::ProfilesController < ApplicationController
  layout 'dashboard'

  def edit
    profile = current_user.profile
    if profile
      @profile_form = ProfileForm.new(
        name: profile.name,
        bio: profile.bio,
        location: profile.location,
        messengers: profile.messengers.map { |messenger| ProfileForm::Messenger.new(messenger) },
        languages: profile.languages
      )
    else
      @profile_form = ProfileForm.new(
        messengers: [ProfileForm::Messenger.new(type: Rails.application.config.global[:blank_messenger][:long], value: '')],
        languages: []
      )
    end
  end

  def update
    @profile_form = ProfileForm.new(profile_params)
    if @profile_form.valid?
      ActiveRecord::Base.transaction do
        profile = (current_user.profile || current_user.build_profile).lock!
        profile.update!(@profile_form.serializable_hash(include: ['messengers']))
      end
      redirect_to edit_settings_profile_path, notice: t('.saved')
    else
      render 'edit'
    end
  end

  private

  def profile_params
    params.require(:profile_form).permit(:name, :bio, :location, languages: [], messengers_attributes: %i[type value])
  end
end
