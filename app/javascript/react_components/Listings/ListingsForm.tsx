import { Dialog } from '@headlessui/react';
import {
  ArrowDownOnSquareIcon,
  ArrowDownOnSquareStackIcon,
  ArrowLeftIcon,
  ArrowUpOnSquareStackIcon,
  PencilIcon, PlusCircleIcon, TrashIcon, UserIcon, XMarkIcon,
} from '@heroicons/react/24/outline';
import * as React from 'react';
import { useMutation } from 'react-query';
import {
  Dispatch, SetStateAction, useId, useState,
} from 'react';
import axios from '../system/Axios';
import { useToasts } from '../Toast/ToastManager';
import Confirmation from './ListingsConfirmation';
import Alert from '../Alert';
import { Image, Listing } from '../system/TypeScript';
import InplaceActionButtons from './InplaceButtons/InplaceActionButton';
import InplaceEditButton from './InplaceButtons/InplaceEditButton';
import InputsDescription from './Inputs/InputsDescription';
import InputsName from './Inputs/InputsName';
import InputsAccess from './Inputs/InputsAccess';
import InputsImage from './Inputs/InputsImage';

export default function ListingsForm(
  {
    selectedListing, setSelectedListing, close, entityId, filterOutListing, patchListings,
  }: {
    selectedListing: Listing,
    setSelectedListing: Dispatch<SetStateAction<Listing>>,
    close: () => boolean,
    entityId: string,
    filterOutListing: (needle: Listing) => void
    patchListings: (needle: Listing) => void
  },
) {
  const imageId = useId();

  const [confirmationOpen, setConfirmationOpen] = useState(false);
  const { add } = useToasts();

  const createListingMutation = useMutation<unknown, unknown, {
    listing_id: number,
    ext_id: string,
    image: Image,
    name: string,
    description: string,
    is_public: boolean
  }
  >(async (params) => {
    axios.post(
      '/api/listings',
      params,
    ).then((result) => {
      close();
      add(result.data.message);
    }).catch(() => {
      add('Возникла непредвиденная ошибка');
    });
  });

  const createListing = () => {
    createListingMutation.mutate({
      listing_id: selectedListing.id,
      ext_id: entityId,
      image: selectedListing.image,
      name: selectedListing.name,
      description: selectedListing.description,
      is_public: selectedListing.is_public,
    });
  };

  const addItemMutation = useMutation<unknown, unknown, {
    listing_id: number,
    ext_id: string,
  }
  >(async (params) => {
    axios.post(
      '/api/listings/add_item',
      params,
    ).then((result) => {
      close();
      add(result.data.message);
    }).catch(() => {
      add('Возникла непредвиденная ошибка');
    });
  });

  const addItem = () => {
    addItemMutation.mutate({
      listing_id: selectedListing.id,
      ext_id: entityId,
    });
  };

  const removeItemMutation = useMutation<unknown, unknown, {
    listing_id: number,
    ext_id: string
  }
  >(async (params) => {
    axios.post(
      '/api/listings/remove_item',
      params,
    ).then((result) => {
      close();
      add(result.data.message);
    }).catch((error) => {
      add(error.response.data.error);
    });
  });

  const removeItem = () => {
    removeItemMutation.mutate({
      listing_id: selectedListing.id,
      ext_id: entityId,
    });
  };

  const patchListingMutation = useMutation<unknown, unknown, {
    image?: Image,
    name?: string,
    description?: string,
    is_public?: boolean
  }
  >(async (params) => {
    axios.patch(
      `/api/listings/${selectedListing.id}`,
      params,
    ).then((result) => {
      patchListings({ ...selectedListing, ...params });
      add(result.data.message);
    }).catch((error) => {
      add(error.response.data.error);
    });
  });

  const patchListing = (params) => {
    patchListingMutation.mutate(params);
  };

  return (
    <Dialog.Panel>
      <Dialog.Title
        as="h3"
        className="tw-flex tw-justify-between tw-font-medium tw-text-gray-400 tw-border-b tw-border-b-slate-100 tw-pb-4"
      >
        <div className="tw-absolute? tw-top-0 tw-left-0 tw-pt-4 tw-pl-4">
          <button
            type="button"
            className="tw-flex tw-bg-white tw-rounded-md tw-text-gray-700? hover:tw-text-gray-500
                focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-300"
            onClick={() => setSelectedListing(null)}
          >
            <ArrowLeftIcon className="tw-h-6 tw-w-6 tw-mr-3" aria-hidden="true" />
            {' '}
            Назад
          </button>
        </div>

        <div className="tw-absolute? tw-top-0 tw-right-0 tw-pt-4 tw-pr-4">
          <button
            type="button"
            className="tw-bg-white tw-rounded-md tw-text-gray-400? hover:tw-text-gray-500
                focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-300"
            onClick={() => close()}
          >
            <span className="tw-sr-only">Закрыть</span>
            <XMarkIcon className="tw-h-6 tw-w-6" aria-hidden="true" />
          </button>
        </div>
      </Dialog.Title>

      { selectedListing.id && (
      <Confirmation
        confirmationOpen={confirmationOpen}
        listingId={selectedListing.id}
        setConfirmationOpen={setConfirmationOpen}
        closeForm={() => setSelectedListing(null)}
      />
      ) }

      {!selectedListing.is_owner && selectedListing.id
          && (
            <div className="sm:tw-grid sm:tw-grid-cols-4 sm:tw-gap-4 sm:tw-items-center tw-mb-2">
              <div className="sm:tw-col-span-4 tw-border-b tw-border-slate-100">
                <Alert type="success">
                  Данная коллекция принадлежит другому пользователю.
                  Ваше предложение по добавлению или удалению объекта
                  из коллекции будет отправлено автору на модерацию.
                </Alert>
              </div>
            </div>
          )}

      <div className="tw-p-5 sm:tw-px-10 tw-space-y-6">

        <InputsImage
          patchListing={patchListing}
          selectedListing={selectedListing}
          setSelectedListing={setSelectedListing}
        />

        <InputsName
          patchListing={patchListing}
          selectedListing={selectedListing}
          setSelectedListing={setSelectedListing}
        />

        <InputsDescription
          patchListing={patchListing}
          selectedListing={selectedListing}
          setSelectedListing={setSelectedListing}
        />

        <InputsAccess
          patchListing={patchListing}
          selectedListing={selectedListing}
          setSelectedListing={setSelectedListing}
        />

      </div>

      <div className="tw-p-5 sm:tw-px-10 sm:tw-grid sm:tw-grid-cols-4 tw-border-t tw-border-slate-100">
        <div className="sm:tw-col-start-2 sm:tw-col-span-4 tw-flex tw-flex-col sm:tw-flex-row tw-gap-4">

          <button
            type="button"
            className="tw-w-full tw-flex-1 tw-inline-flex tw-justify-center tw-rounded-md tw-border tw-border-transparent
               tw-px-4 tw-py-2.5 tw-bg-indigo-600 tw-text-sm tw-font-medium tw-text-white  hover:tw-bg-indigo-700
              focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-300 sm:tw-w-auto?"
            onClick={selectedListing.is_checked
              ? removeItem
              : selectedListing.id ? addItem : createListing}
          >
            {selectedListing.is_checked
              ? (
                <>
                  <ArrowUpOnSquareStackIcon className="tw-w-5 tw-h-5 tw-mr-3" />
                  Удалить из коллекции
                </>
              ) : (
                <>
                  <ArrowDownOnSquareStackIcon className="tw-w-5 tw-h-5 tw-mr-3" />
                  {selectedListing.id
                    ? 'Добавить в коллекцию'
                    : 'Создать коллекцию'}
                </>
              )}
          </button>

          { selectedListing.id
            && (
              <button
                disabled={!!(!selectedListing.is_owner && selectedListing.id)}
                onClick={() => {
                  filterOutListing(selectedListing);
                  setConfirmationOpen(true);
                }}
                type="button"
                className={`
                ${!selectedListing.is_owner && selectedListing.id ? 'tw-bg-gray-400' : 'tw-bg-red-600 hover:tw-bg-red-700 focus:tw-ring-red-500'}
                tw-w-full tw-flex-1? tw-inline-flex tw-justify-center tw-rounded-md tw-border tw-border-transparent
                 tw-px-4 tw-py-2.5 tw-text-sm tw-font-medium tw-text-white
                focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 sm:tw-w-auto`}
              >
                <TrashIcon className="tw-w-5 tw-h-5 tw-mr-3 sm:tw-mr-0" />
                <span className="sm:tw-hidden">Удалить коллекцию</span>
              </button>
            )}
        </div>
      </div>
    </Dialog.Panel>
  );
}
