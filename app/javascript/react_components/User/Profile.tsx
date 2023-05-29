import * as React from 'react';
import { useMutation, useQuery } from '@tanstack/react-query';
import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
import * as yup from 'yup';
import axios from '../system/Axios';
import Messenger from './Messenger';
import Avatar from './Avatar';
import { useToasts } from '../Toast/ToastManager';
import useAuth from '../Auth/useAuth';

const schema = yup.object({
  messengers: yup.array().of(
    yup.object().shape({
      type: yup.string().required().label('type'),
      value: yup.string().required().label('value'),
    }),
  ),
}).required();

type ProfileType = {
  available_languages: String[],
  available_time_zones: String[],
  available_messengers: String[],
  defaultValues: any,
}

export default function Profile({
  available_languages, available_time_zones, available_messengers, defaultValues,
}: ProfileType) {
  const { add } = useToasts();
  const { refetchUser } = useAuth();

  const {
    setError, control, getValues, setValue, register, handleSubmit, watch, formState: { errors },
  } = useForm({
    defaultValues,
    resolver: yupResolver(schema),
  });

  // console.debug(errors);

  const updateProfileMutation = useMutation<unknown, unknown, {}>({
    mutationFn: (async (params) => {
      axios.post(
        '/api/user/change_profile',
        params,
      ).then((result) => {
        add('Профиль успешно изменён');
        refetchUser();
      }).catch((error) => {
        add('Возникла непредвиденная ошибка');
      });
    }),
  });

  const onSubmit = (data) => {
    updateProfileMutation.mutate({
      name: data.name,
      bio: data.bio,
      languages: data.languages,
      time_zone: data.time_zone,
      messengers: data.messengers,
      avatar: data.avatar,
    });
  };

  return (
    <form className="tw-space-y-8 tw-divide-y tw-divide-gray-200" onSubmit={handleSubmit(onSubmit)}>
      <div className="tw-space-y-8 tw-divide-y tw-divide-gray-200">
        <div className="tw-mt-6 tw-grid tw-grid-cols-1 tw-gap-y-6 tw-gap-x-4 sm:tw-grid-cols-6">

          <div className="sm:tw-col-span-4">
            <label htmlFor="name" className="tw-block tw-text-base tw-font-medium tw-text-gray-700">
              Name
            </label>
            <div className="tw-mt-1">
              <input
                id="name"
                // name="name"
                type="text"
                autoComplete="name"
                className="tw-shadow-sm focus:tw-ring-indigo-500 focus:tw-border-indigo-500 tw-block w-full sm:tw-text-sm tw-border-gray-300 tw-rounded-md"
                {...register('name')}
              />
            </div>
          </div>

          <Avatar {...{
            control,
            register,
            getValues,
            setValue,
            errors,
          }}
          />

          <div className="sm:tw-col-span-3">
            <label htmlFor="bio" className="tw-block tw-text-base tw-font-medium tw-text-gray-700">
              Bio
            </label>
            <div className="tw-mt-1">
              <textarea
                id="bio"
                // name="bio"
                rows={3}
                className="tw-shadow-sm focus:tw-ring-indigo-500 focus:tw-border-indigo-500 tw-block tw-w-full sm:tw-text-sm tw-border tw-border-gray-300 tw-rounded-md"
                {...register('bio')}
              />
            </div>
            <p className="tw-mt-2 tw-text-sm tw-text-gray-500">Write a few sentences about yourself.</p>
          </div>

          <div className="sm:tw-col-span-4 sm:tw-col-start-3?">
            <fieldset>
              <legend className="tw-text-base tw-font-medium tw-text-gray-700">Языки</legend>
              <p className="tw-text-sm tw-text-gray-500">Укажите языки, которыми вы владетее.</p>
              <div className="tw-mt-4 tw-space-y-4">
                {available_languages.map((language) => (
                  <div key={language[1]} className="tw-relative tw-flex tw-items-start">
                    <div className="tw-flex tw-items-center tw-h-5">
                      <input
                        id={language[1]}
                        // name={language[1]}
                        value={language[1]}
                        type="checkbox"
                        {...register('languages')}
                        className="focus:tw-ring-indigo-500 tw-h-4 tw-w-4 tw-text-indigo-600 tw-border-gray-300 tw-rounded"
                      />
                    </div>
                    <div className="tw-ml-3 tw-text-sm">
                      <label htmlFor={language[1]} className="tw-font-medium tw-text-gray-700">
                        {language[0]}
                      </label>
                      {/* <p className="tw-text-gray-500">Get notified when a candidate accepts or rejects an offer.</p> */}
                    </div>
                  </div>
                ))}
              </div>
            </fieldset>
          </div>

          <div className="sm:tw-col-span-4">
            <label htmlFor="time_zone" className="tw-block tw-text-base tw-font-medium tw-text-gray-700">
              Часовой пояс
            </label>
            <div className="tw-mt-1">
              <select
                id="time_zone"
                // name="time_zone"
                autoComplete="time_zone"
                className="tw-shadow-sm focus:tw-ring-indigo-500 focus:tw-border-indigo-500 tw-block tw-w-full sm:tw-text-sm tw-border-gray-300 tw-rounded-md"
                {...register('time_zone')}
              >
                {available_time_zones.map((time_zone) => (
                  <option
                    key={time_zone[0]}
                    value={time_zone[1]}
                  >
                    {time_zone[0]}
                  </option>
                ))}
              </select>
            </div>
          </div>

          <div className="sm:tw-col-span-4">
            <Messenger {...{
              control,
              register,
              available_messengers,
              getValues,
              setValue,
              errors,
            }}
            />
          </div>

          <div className="sm:tw-col-span-4">
            <p className="tw-mt-1 tw-text-sm tw-text-gray-500">
              This information will be displayed publicly so be careful what you share.
            </p>
          </div>

        </div>
      </div>

      <div className="tw-pt-5">
        <div className="tw-flex tw-justify-end">
          {/* <button
            type="button"
            className="tw-bg-white tw-py-2 tw-px-4 tw-border tw-border-gray-300 tw-rounded-md tw-shadow-sm tw-text-sm tw-font-medium tw-text-gray-700 hover:tw-bg-gray-50 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-500"
          >
            Cancel
          </button> */}
          <button
            type="submit"
            className="tw-ml-3 tw-inline-flex tw-justify-center tw-py-2 tw-px-4 tw-border tw-border-transparent tw-shadow-sm tw-text-sm tw-font-medium tw-rounded-md tw-text-white tw-bg-indigo-600 hover:tw-bg-indigo-700 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-500"
          >
            Save
          </button>
        </div>
      </div>
    </form>
  );
}
