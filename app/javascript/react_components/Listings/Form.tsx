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
import { Dispatch, SetStateAction, useState } from 'react';
import axios from '../system/Axios';
import { useToasts } from '../Toast/ToastManager';
import Confirmation from './Confirmation';
import Alert from '../Alert';
import { Listing } from '../system/TypeScript';
import InplaceActionButtons from './InplaceActionButtons';
import InplaceEditButton from './InplaceEditButton';

const accessOptions = [{
  id: 'public',
  title: 'Публичный',
},
{
  id: 'private',
  title: 'Приватный',
}];

export default function Form(
  props: {
    selectedListing: Listing,
    setSelectedListing: Dispatch<SetStateAction<Listing>>,
    close: () => boolean,
    entityId: string
  },
) {
  const {
    selectedListing, setSelectedListing, close, entityId,
  } = props;

  console.debug(selectedListing);

  const [isEditingName, setIsEditingName] = useState(false);
  const [isEditingDescription, setIsEditingDescription] = useState(false);
  const [isEditingAccess, setIsEditingAccess] = useState(false);

  const [confirmationOpen, setConfirmationOpen] = useState(false);
  const { add } = useToasts();
  const [title, setTitle] = useState(selectedListing.name || '');
  const [description, setDescription] = useState(selectedListing.description || '');
  const [access, setAccess] = useState(() => {
    switch (selectedListing.is_public) {
      case true:
        return 'public';
      case false:
        return 'private';
      default:
        return undefined;
    }
  });

  // switch (access) {
  //   case 'public':
  //     return id === 'public';
  //   case false:
  //     return id === 'private';
  //   default:
  //     return false;
  // }

  const updateSelectedListing = () => {
    mutation.mutate({
      id: selectedListing.id,
      ext_id: entityId,
      name: title,
      description,
      is_checked: !selectedListing.is_checked,
      is_public: (() => {
        switch (access) {
          case 'public':
            return true;
          case 'private':
            return false;
          default: return undefined;
        }
      })(),
    });
  };

  const mutation = useMutation<unknown, unknown, {
    id: number,
    ext_id: string,
    name: string,
    description: string,
    is_checked: boolean,
    is_public: boolean
  }
  >(async (params) => {
    await axios.post(
      '/api/listings',
      params,
    );

    add('test');
  });

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

      <Confirmation open={confirmationOpen} setOpen={setConfirmationOpen} />

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

        <div className="sm:tw-grid sm:tw-grid-cols-4 sm:tw-gap-4 sm:tw-items-center">
          <label htmlFor="image" className="tw-block tw-text-sm tw-font-medium tw-text-gray-700 tw-mb-2 sm:tw-mb-0">
            Лого
          </label>
          <div className="tw-mt-1 sm:tw-mt-0 sm:tw-col-span-3">
            <div className="tw-flex tw-items-center">
              <button
                type="button"
                className="focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-300
                  tw-h-24 tw-w-24 tw-rounded tw-overflow-hidden tw-bg-gray-100 tw-border disabled:tw-text-gray-500"
              >
                <UserIcon className="tw-h-full tw-w-full tw-text-gray-300" />
              </button>
            </div>
          </div>
        </div>

        <div className="sm:tw-grid sm:tw-grid-cols-4 sm:tw-gap-4 sm:tw-items-center">
          <label htmlFor="name" className="tw-block tw-text-sm tw-font-medium tw-text-gray-700 tw-mb-2 sm:tw-mb-0">
            Название
          </label>
          <div className="tw-mt-1 sm:tw-mt-0 sm:tw-col-span-3">
            <div className="tw-flex tw-items-center">
              {selectedListing.id && !isEditingName
                ? (
                  <div className="tw-space-x-5 tw-flex">

                    <InplaceEditButton
                      selectedListing={selectedListing}
                      onEdit={() => setIsEditingName(true)}
                    >
                      {selectedListing.name || 'отсутствует'}
                    </InplaceEditButton>
                  </div>
                )
                : (
                  <InplaceActionButtons
                    selectedListing={selectedListing}
                    onSave={() => alert('save name')}
                    onCancelEdit={() => setIsEditingName(false)}
                  >
                    <input
                      id="name"
                      name="name"
                      type="text"
                      value={title}
                      onChange={(e) => setTitle(e.target.value)}
                      className="disabled:tw-bg-gray-100  focus:tw-ring-indigo-300 focus:tw-border-indigo-300
                        tw-block tw-w-full sm:tw-text-sm tw-border-gray-300 tw-rounded-md disabled:tw-text-gray-500"
                    />
                  </InplaceActionButtons>
                )}
            </div>
          </div>
        </div>

        <div className="sm:tw-grid sm:tw-grid-cols-4 sm:tw-gap-4 sm:tw-items-center">
          <label htmlFor="description" className="tw-block tw-text-sm tw-font-medium tw-text-gray-700 tw-mb-2 sm:tw-mb-0">
            Описание
          </label>
          <div className="tw-mt-1 sm:tw-mt-0 sm:tw-col-span-3">
            <div className="tw-flex tw-items-center">
              {selectedListing.id && !isEditingDescription
                ? (
                  <div className="tw-space-x-5 tw-flex">

                    <InplaceEditButton
                      selectedListing={selectedListing}
                      onEdit={() => setIsEditingDescription(true)}
                    >
                      { selectedListing.description && selectedListing.description.length > 0 ? selectedListing.description : 'отсутствует' }
                    </InplaceEditButton>
                  </div>
                )
                : (
                  <InplaceActionButtons
                    selectedListing={selectedListing}
                    onSave={() => alert('save description')}
                    onCancelEdit={() => setIsEditingDescription(false)}
                  >
                    <textarea
                      id="description"
                      name="description"
                      rows={8}
                      value={description}
                      onChange={(e) => setDescription(e.target.value)}
                      className="disabled:tw-bg-gray-100  focus:tw-ring-indigo-300 focus:tw-border-indigo-300 tw-block tw-w-full
                  sm:tw-text-sm tw-border-gray-300 tw-rounded-md disabled:tw-text-gray-500"
                    />
                  </InplaceActionButtons>
                )}
            </div>
          </div>
        </div>

        <div className="sm:tw-grid sm:tw-grid-cols-4 sm:tw-gap-4 sm:tw-items-center">
          <label
            htmlFor="access"
            className="tw-block tw-text-sm tw-font-medium tw-text-gray-700 tw-mb-2 sm:tw-mb-0"
          >
            Доступ
          </label>

          <div className="tw-mt-1 sm:tw-mt-0 sm:tw-col-span-3">
            <div className="tw-flex tw-items-center">
              {selectedListing.id && !isEditingAccess
                ? (
                  <div className="tw-space-x-5 tw-flex">

                    <InplaceEditButton
                      selectedListing={selectedListing}
                      onEdit={() => setIsEditingAccess(true)}
                    >
                      {access}
                    </InplaceEditButton>
                  </div>
                )
                : (
                  <InplaceActionButtons
                    selectedListing={selectedListing}
                    onSave={() => alert('save acceess')}
                    onCancelEdit={() => setIsEditingAccess(false)}
                  >
                    <div className="tw-space-y-1.5 sm:tw-space-y-2">
                      {accessOptions.map((accessOption) => (
                        <div key={accessOption.id} className="tw-flex tw-items-center">
                          <input
                            id={accessOption.id}
                            name="access"
                            type="radio"
                            value={accessOption.id}
                            checked={accessOption.id === access}
                            onChange={(e) => setAccess(e.target.value)}
                            className="tw-bg-gray-100 focus:tw-ring-indigo-300? tw-h-4 tw-w-4 tw-text-indigo-600
                            focus:tw-ring-blue-500 disabled:tw-text-gray-500 tw-border-gray-300"
                          />
                          <label
                            htmlFor={accessOption.id}
                            className={`
                            tw-text-gray-700 tw-ml-3 tw-block tw-text-sm tw-font-medium`}
                          >
                            {accessOption.title}
                          </label>
                        </div>
                      ))}
                    </div>
                  </InplaceActionButtons>
                )}
            </div>
          </div>
        </div>
      </div>

      <div className="tw-p-5 sm:tw-px-10 sm:tw-grid sm:tw-grid-cols-4 tw-border-t tw-border-slate-100">
        <div className="sm:tw-col-start-2 sm:tw-col-span-4 tw-flex tw-flex-col sm:tw-flex-row tw-gap-4">

          <button
            type="button"
            className="tw-w-full tw-flex-1 tw-inline-flex tw-justify-center tw-rounded-md tw-border tw-border-transparent
               tw-px-4 tw-py-2.5 tw-bg-indigo-600 tw-text-sm tw-font-medium tw-text-white  hover:tw-bg-indigo-700
              focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-300 sm:tw-w-auto?"
            onClick={updateSelectedListing}
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

          { true
            && (
              <button
                disabled={!selectedListing.is_owner && selectedListing.id}
                onClick={() => { setConfirmationOpen(true); }}
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
