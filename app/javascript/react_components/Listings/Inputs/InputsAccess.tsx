import { AnimatePresence, motion } from 'framer-motion';
import * as React from 'react';
import {
  Dispatch, SetStateAction, useId, useState,
} from 'react';
import { Listing } from '../../system/TypeScript';
import InplaceActionButtons from '../InplaceButtons/InplaceActionButton';
import InplaceEditButton from '../InplaceButtons/InplaceEditButton';

const accessOptions = [{
  id: true,
  title: 'Публичный',
},
{
  id: false,
  title: 'Приватный',
}];

const isPublicToString = (value: (boolean | undefined)) => {
  switch (value) {
    case true:
      return 'Публичный';
    case false:
      return 'Приватный';
    default:
      return undefined;
  }
};

export default function InputsAccess(
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
  const [isPublic, setIsPublic] = useState<boolean>(selectedListing.is_public);

  // setSelectedListing((prevVal) => ({ ...prevVal, is_public: e.target.value === 'true' }))

  return (
    <div className="sm:tw-grid sm:tw-grid-cols-4 sm:tw-gap-4 sm:tw-items-center">
      <label
        htmlFor={inputId}
        className="tw-block tw-text-sm tw-font-medium tw-text-gray-700 tw-mb-2 sm:tw-mb-0"
      >
        Доступ
      </label>

      <div className="tw-mt-1 sm:tw-mt-0 sm:tw-col-span-3">
        <div className="tw-flex tw-items-center">
          <AnimatePresence initial={false} mode="wait">
            {selectedListing.id && !isEditing
              ? (
                <motion.div
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  exit={{ opacity: 0 }}
                  transition={{ duration: 0.2 }}
                  key="1"
                  className="tw-space-x-5 tw-flex"
                >
                  <InplaceEditButton
                    selectedListing={selectedListing}
                    onEdit={() => setIsEditing(true)}
                  >
                    {isPublicToString(selectedListing.is_public)}
                  </InplaceEditButton>
                </motion.div>
              )
              : (
                <motion.div
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  exit={{ opacity: 0 }}
                  transition={{ duration: 0.2 }}
                  key="2"
                >
                  <InplaceActionButtons
                    isEditing={isEditing}
                    selectedListing={selectedListing}
                    onSave={() => {
                      setSelectedListing((prevVal) => ({ ...prevVal, is_public: isPublic }));
                      patchListing({ is_public: isPublic });
                      setIsEditing(false);
                    }}
                    onCancelEdit={() => {
                      setIsEditing(false);
                      setIsPublic(selectedListing.is_public);
                    }}
                  >
                    <div className="tw-space-y-1.5 sm:tw-space-y-2">
                      {accessOptions.map((accessOption) => (
                        <div key={accessOption.id.toString()} className="tw-flex tw-items-center">
                          <input
                            id={accessOption.id.toString()}
                            name="access"
                            type="radio"
                            value={accessOption.id.toString()}
                            checked={accessOption.id === isPublic}
                            onChange={(e) => {
                              setIsPublic(e.target.value === 'true');
                              if (!selectedListing.id) {
                                setSelectedListing((prevVal) => ({ ...prevVal, is_public: e.target.value === 'true' }));
                              }
                            }}
                            className="tw-bg-gray-100 focus:tw-ring-indigo-300? tw-h-4 tw-w-4 tw-text-indigo-600
                      focus:tw-ring-blue-500 disabled:tw-text-gray-500 tw-border-gray-300"
                          />
                          <label
                            htmlFor={accessOption.id.toString()}
                            className={`
                      tw-text-gray-700 tw-ml-3 tw-block tw-text-sm tw-font-medium`}
                          >
                            {accessOption.title}
                          </label>
                        </div>
                      ))}
                    </div>
                  </InplaceActionButtons>
                </motion.div>
              )}
          </AnimatePresence>
        </div>
      </div>
    </div>
  );
}
