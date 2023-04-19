import * as React from 'react';
import { useMutation, useQuery } from '@tanstack/react-query';
import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
import * as yup from 'yup';
import axios from '../system/Axios';
import { useToasts } from '../Toast/ToastManager';

type PasswordType = {defaultValues: any}

const schema = yup.object({
  new_password: yup.string().required('Password is required').min(6, 'Password must be at least 6 characters'),
  password_confirmation: yup.string().oneOf([yup.ref('new_password'), null], 'Passwords must match'),
}).required();

export default function Password({
  defaultValues,
}: PasswordType) {
  const {
    reset, control, getValues, setValue, register, handleSubmit, watch, formState: { errors },
  } = useForm({
    defaultValues,
    resolver: yupResolver(schema),
  });

  const { add } = useToasts();

  const updatePasswordMutation = useMutation<unknown, unknown, {
    password: string,
  }
  >(async (params) => {
    axios.post(
      '/api/user/change_password',
      params,
    ).then((result) => {
      add('Пароль успешно изменён');
      reset({ ...{ new_password: '', password_confirmation: '' } });
    }).catch(() => {
      add('Возникла непредвиденная ошибка');
    });
  });

  const onSubmit = (data) => {
    updatePasswordMutation.mutate(data);
  };

  // const onSubmit = (data) => console.lEog(data);

  return (
    <form className="tw-space-y-8 tw-divide-y tw-divide-gray-200" onSubmit={handleSubmit(onSubmit)}>
      {/* {JSON.stringify(data)} */}
      <div className="tw-space-y-8 tw-divide-y tw-divide-gray-200">
        <div>

          <div className="tw-mt-6 tw-grid tw-grid-cols-1 tw-gap-y-6 tw-gap-x-4 sm:tw-grid-cols-6">

            {/* <input className="tw-hidden" type="text" name="username" value={defaultValues.email} /> */}

            <div className="sm:tw-col-span-4">
              <label htmlFor="new_password" className="tw-block tw-text-base tw-font-medium tw-text-gray-700">
                Пароль
              </label>
              <div className="tw-mt-1">
                <input
                  id="new_password"
                  // name="email"
                  type="password"
                  autoComplete="new-password"
                  className="tw-shadow-sm focus:tw-ring-indigo-500 focus:tw-border-indigo-500 tw-block w-full sm:tw-text-sm tw-border-gray-300 tw-rounded-md"
                  {...register('new_password')
                }
                />
              </div>

              { errors.new_password && (
                <p className="tw-mt-2 tw-text-sm tw-text-red-500">
                  {errors.new_password?.message}
                </p>
              )}
            </div>

            <div className="sm:tw-col-span-4">
              <label htmlFor="password_confirmation" className="tw-block tw-text-base tw-font-medium tw-text-gray-700">
                Подтверждение пароля
              </label>
              <div className="tw-mt-1">
                <input
                  id="password_confirmation"
                  // name="email"
                  type="password"
                  autoComplete="new-password"
                  className="tw-shadow-sm focus:tw-ring-indigo-500 focus:tw-border-indigo-500 tw-block w-full sm:tw-text-sm tw-border-gray-300 tw-rounded-md"
                  {...register('password_confirmation')}
                />
              </div>
              { errors.password_confirmation && (
                <p className="tw-mt-2 tw-text-sm tw-text-red-500">
                  {errors.password_confirmation?.message}
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
