import { UserIcon } from '@heroicons/react/20/solid';
import { AnimatePresence, motion } from 'framer-motion';
import * as React from 'react';
import {
  Dispatch, SetStateAction, useId, useState,
} from 'react';
import { useWatch } from 'react-hook-form';
import { Listing, Image } from '../../system/TypeScript';
import { useToasts } from '../Toast/ToastManager';

type AvatarType = {
  defaultValues: object, control: any, register: any, getValues: any, setValue: any, errors: any
}

export default function Avatar(
  {
    isLoading, defaultValues, isFetching, control, register, getValues, setValue, errors,
  }: AvatarType,
) {
  const { add } = useToasts();

  const avatar = (useWatch({ control, name: 'avatar' }));

  const cleanInputFile = (e: any) => {
    const container = new DataTransfer();
    e.target.files = container.files;
  };

  const sendForm = async (inputFile: File) => {
    const formData = new FormData();

    formData.append('file', inputFile);

    const res = await fetch('/api/uploads', {
      method: 'POST',
      body: formData,
    });
    if (!res.ok) add(res.statusText);
    return res.json();
  };

  const handleInputFile = async (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files) {
      const inputFile = e.target.files[0];
      const result = await sendForm(inputFile);
      setValue('avatar', result);
      cleanInputFile(e);
    }
  };

  return (

    <div className="sm:tw-col-span-2 sm:tw-row-span-2 tw-bg-slate-100? tw-rounded? tw-flex tw-items-start tw-justify-center">
      <div className="tw-mt-1 sm:tw-mt-0 sm:tw-col-span-3">
        <div className="tw-flex tw-items-center">
          <div className="tw-flex tw-text-sm tw-text-gray-600">
            <label
              htmlFor="avatar"
              className="
                        tw-cursor-pointer
                        tw-relative tw-bg-white tw-font-medium tw-text-indigo-600
                        hover:tw-text-indigo-500 focus-within:tw-outline-none focus-within:tw-ring-2
                        focus-within:tw-ring-offset-2 focus-within:tw-ring-indigo-500 tw-rounded"
            >

              <img
                alt="avatar"
                className="tw-w-24 tw-h-24 tw-object-contain tw-border tw-rounded tw-p-px"
                src={
                  avatar?.image_url || avatar || 'https://comnplayscience.eu/app/images/notfound.png'
                }
              />

              <input
                id="avatar"
                onChange={handleInputFile}
                type="file"
                className="tw-sr-only"
              />
            </label>
          </div>
        </div>
      </div>
    </div>
  );
}
