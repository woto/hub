import * as React from 'react';
import { useMutation, useQuery } from '@tanstack/react-query';
import { useState } from 'react';
import { yupResolver } from '@hookform/resolvers/yup';
import * as yup from 'yup';
import { useForm } from 'react-hook-form';
import axios from '../system/Axios';
import { useToasts } from '../Toast/ToastManager';
import useAuth from '../Auth/useAuth';

type EmailType = {defaultValues: any}

const schema = yup.object({
  email: yup.string().required().email(),
}).required();

export default function Email({
  defaultValues,
}: EmailType) {
  const {
    setError, reset, control, getValues, setValue, register, handleSubmit, watch, formState: { errors },
  } = useForm({
    defaultValues,
    resolver: yupResolver(schema),
  });

  const { add } = useToasts();
  const { refetchUser } = useAuth();

  const updateEmailMutation = useMutation<unknown, unknown, {
    new_email: string,
  }
  >(async (params) => {
    axios.post(
      '/api/user/change_email',
      params,
    ).then((result) => {
      add('Email успешно изменён');
      refetchUser();
      reset();
    }).catch((error) => {
      const parsed = JSON.parse(error.response.data.error);
      setError('email', {
        message: parsed.params.new_email,
      });
      add('Возникла непредвиденная ошибка');
    });
  });

  const onSubmit = (data) => {
    updateEmailMutation.mutate({ new_email: data.email });
  };

  return (
    <form className="tw-space-y-8 tw-divide-y tw-divide-gray-200" onSubmit={handleSubmit(onSubmit)} noValidate>
      <div className="tw-space-y-8 tw-divide-y tw-divide-gray-200">
        <div>
          <div className="tw-mt-6 tw-grid tw-grid-cols-1 tw-gap-y-6 tw-gap-x-4 sm:tw-grid-cols-6">

            <div className="sm:tw-col-span-4">
              <label htmlFor="email" className="tw-block tw-text-base tw-font-medium tw-text-gray-700">
                Email
              </label>
              <div className="tw-mt-1">
                <input
                  {...register('email')}
                  id="email"
                  // name="email"
                  type="email"
                  autoComplete="email"
                  className="tw-shadow-sm focus:tw-ring-indigo-500 focus:tw-border-indigo-500 tw-block w-full sm:tw-text-sm tw-border-gray-300 tw-rounded-md"
                />
              </div>
              { errors.email && (
                <p className="tw-mt-2 tw-text-sm tw-text-red-500">
                  {errors.email?.message}
                </p>
              )}
              { defaultValues.unconfirmed_email
                && (
                  <p className="tw-mt-2 tw-text-sm tw-text-gray-500">
                    Пожалуйста, проверьте почтовый ящик и перейдите по ссылке, чтобы закончить процедуру проверки:
                    {' '}
                    <b>{defaultValues.unconfirmed_email}</b>
                  </p>
                )}
            </div>

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
