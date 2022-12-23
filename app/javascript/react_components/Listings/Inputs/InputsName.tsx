import { AnimatePresence, motion } from 'framer-motion';
import * as React from 'react';
import {
  Dispatch, SetStateAction, useId, useState,
} from 'react';
import { Listing } from '../../system/TypeScript';
import InplaceActionButtons from '../InplaceButtons/InplaceActionButton';
import InplaceEditButton from '../InplaceButtons/InplaceEditButton';

export default function InputsName(
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
  const [name, setName] = useState<string>(selectedListing.name || '');

  return (
    <div className="sm:tw-grid sm:tw-grid-cols-4 sm:tw-gap-4 sm:tw-items-center">
      <label
        htmlFor={inputId}
        className="tw-block tw-text-sm tw-font-medium tw-text-gray-700 tw-mb-2 sm:tw-mb-0"
      >
        Название
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
                    {selectedListing.name || 'отсутствует'}
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
                  className="tw-w-full"
                >
                  <InplaceActionButtons
                    isEditing={isEditing}
                    selectedListing={selectedListing}
                    onSave={() => {
                      setSelectedListing((prevVal) => ({ ...prevVal, name }));
                      patchListing({ name });
                      setIsEditing(false);
                    }}
                    onCancelEdit={() => {
                      setIsEditing(false);
                      setName(selectedListing.name);
                    }}
                  >
                    <input
                      id={inputId}
                      name="name"
                      type="text"
                      value={name}
                      onChange={(e) => {
                        setName(e.target.value);
                        if (!selectedListing.id) {
                          setSelectedListing((prevVal) => ({ ...prevVal, name: e.target.value }));
                        }
                      }}
                      className="disabled:tw-bg-gray-100  focus:tw-ring-indigo-300 focus:tw-border-indigo-300
                    tw-block tw-w-full sm:tw-text-sm tw-border-gray-300 tw-rounded-md disabled:tw-text-gray-500"
                    />
                  </InplaceActionButtons>
                </motion.div>
              )}
          </AnimatePresence>
        </div>
      </div>
    </div>
  );
}
