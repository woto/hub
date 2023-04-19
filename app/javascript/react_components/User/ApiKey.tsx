import * as React from 'react';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useState } from 'react';
import { useForm } from 'react-hook-form';
import axios from '../system/Axios';
import { useToasts } from '../Toast/ToastManager';

type ApiKeyType = {defaultValues: any}

export default function ApiKey({
  isLoading, defaultValues, isFetching,
}: ApiKeyType) {
  const { add } = useToasts();
  const queryClient = useQueryClient();

  const regenerateApiKeyMutation = useMutation(
    {
      mutationFn: () => axios.post(
        '/api/user/regenerate_api_key/',
      ).then((data) => {
        add('API ключ успешно изменён');
        return data.data;
      }),
      onSuccess: (newData) => {
        queryClient.setQueryData(
          ['profile'],
          (oldData) => ({
            ...oldData,
            api_key: newData,
          }),
        );
      },
    },
  );

  const regenerateApiKey = () => {
    regenerateApiKeyMutation.mutate();
  };

  const {
    register, handleSubmit, watch, formState: { errors },
  } = useForm();
  const onSubmit = () => regenerateApiKey();

  return (
    <form className="tw-space-y-8 tw-divide-y tw-divide-gray-200" onSubmit={handleSubmit(onSubmit)}>
      {/* {JSON.stringify(data)} */}
      <div className="tw-space-y-8 tw-divide-y tw-divide-gray-200">
        <div>

          <div className="tw-mt-6 tw-grid tw-grid-cols-1 tw-gap-y-6 tw-gap-x-4 sm:tw-grid-cols-6">

            <div className="sm:tw-col-span-4">
              <label htmlFor="api_key" className="tw-block tw-text-base tw-font-medium tw-text-gray-700">
                Name
              </label>
              <div className="tw-mt-1">
                <input
                  id="api_key"
                  // name="api_key"
                  type="text"
                  readOnly
                  className="tw-bg-gray-100 tw-text-gray-900 tw-shadow-sm focus:tw-ring-indigo-500 focus:tw-border-indigo-500 tw-block w-full sm:tw-text-sm tw-border-gray-300 tw-rounded-md"
                  value={defaultValues.api_key}
                />
              </div>
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
            Regenerate token
          </button>
        </div>
      </div>
    </form>
  );
}
