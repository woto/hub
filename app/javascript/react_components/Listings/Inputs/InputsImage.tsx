import { UserIcon } from '@heroicons/react/20/solid';
import { AnimatePresence, motion } from 'framer-motion';
import * as React from 'react';
import {
  Dispatch, SetStateAction, useId, useState,
} from 'react';
import { Listing, Image } from '../../system/TypeScript';
import { useToasts } from '../../Toast/ToastManager';

import InplaceActionButtons from '../InplaceButtons/InplaceActionButton';

export default function InputsImage(
  {
    selectedListing,
    patchListing,
    setSelectedListing,
    isEditing,
    setIsEditing,
  }: {
    selectedListing: Listing,
    patchListing: (params: any) => void,
    setSelectedListing: Dispatch<SetStateAction<Listing>>,
    isEditing: boolean,
    setIsEditing: Dispatch<SetStateAction<boolean>>
  },
) {
  const inputId = useId();
  const [image, setImage] = useState<Image>(selectedListing.image || undefined);
  const { add } = useToasts();

  // console.log(image);

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
      if (selectedListing.id) setIsEditing(true);

      const inputFile = e.target.files[0];
      const result = await sendForm(inputFile);
      setImage(result);
      if (!selectedListing.id) {
        setSelectedListing((prevVal) => ({ ...prevVal, image: result }));
      }

      cleanInputFile(e);
    }
  };

  return (

    <div className="sm:tw-grid sm:tw-grid-cols-4 sm:tw-gap-4 sm:tw-items-center">
      <label
        htmlFor={inputId}
        className="tw-block tw-text-sm tw-font-medium
                 tw-text-gray-700 tw-mb-2 sm:tw-mb-0"
      >
        Лого
      </label>
      <div className="tw-mt-1 sm:tw-mt-0 sm:tw-col-span-3">
        <div className="tw-flex tw-items-center">
          <InplaceActionButtons
            isEditing={isEditing}
            selectedListing={selectedListing}
            onSave={() => {
              setSelectedListing((prevVal) => ({ ...prevVal, image }));
              patchListing({ image });
              setIsEditing(false);
            }}
            onCancelEdit={() => {
              setIsEditing(false);
              setImage(selectedListing.image);
            }}
          >
            <div className="tw-flex tw-text-sm tw-text-gray-600">
              <label
                htmlFor={(selectedListing?.is_owner || !selectedListing?.id) ? inputId : ''}
                className={`
                          ${(selectedListing?.is_owner || !selectedListing?.id) ? 'tw-cursor-pointer' : ''}
                          tw-relative tw-bg-white tw-font-medium tw-text-indigo-600
                          hover:tw-text-indigo-500 focus-within:tw-outline-none focus-within:tw-ring-2
                          focus-within:tw-ring-offset-2 focus-within:tw-ring-indigo-500 tw-rounded`}
              >

                <img
                  alt=""
                  className="tw-w-24 tw-h-24 tw-object-contain tw-border tw-rounded tw-p-px"
                  src={
                    image?.image_url || 'https://comnplayscience.eu/app/images/notfound.png'
                  }
                />

                <input
                  id={inputId}
                  onChange={handleInputFile}
                  type="file"
                  className="tw-sr-only"
                />
              </label>
            </div>
          </InplaceActionButtons>
        </div>
      </div>
    </div>
  );
}
