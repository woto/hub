import * as React from 'react';
import { Combobox, Dialog, Transition } from '@headlessui/react';
import {
  ArrowRightIcon,
  CheckBadgeIcon,
  CheckIcon,
  ExclamationCircleIcon, ListBulletIcon, MagnifyingGlassIcon, PencilIcon, PlusCircleIcon, PlusIcon, QueueListIcon, UserIcon, UsersIcon,
} from '@heroicons/react/24/outline';
import {
  Dispatch, SetStateAction, useCallback, useContext,
} from 'react';
import LanguageContext from '../Language/LanguageContext';
import { Listing } from '../system/TypeScript';
import Alert from '../Alert';

export default function ListingsList(
  {
    data, query, setQuery, setSelectedListing, close, status,
  }: {
    data: any,
    query: string,
    setQuery: Dispatch<SetStateAction<string>>,
    setSelectedListing: Dispatch<SetStateAction<Listing>>,
    close: () => boolean,
    status: 'loading' | 'idle' | 'error' | 'success'
  },
) {
  const language = useContext(LanguageContext);

  return (

  // {status === 'success'
  //   && (

    <Combobox
      onChange={(listing: Listing) => setSelectedListing(listing)}
      value={query}
    >
      <div className="tw-relative">
        <MagnifyingGlassIcon
          className="tw-pointer-events-none tw-absolute tw-top-4 tw-left-4 tw-h-7 tw-w-7 tw-text-gray-400"
          aria-hidden="true"
        />
        <Combobox.Input
          className="tw-h-14 tw-w-full tw-border-0 tw-bg-transparent tw-pl-14 tw-pr-4 tw-text-lg tw-text-gray-800 tw-placeholder-gray-400 focus:tw-ring-0"
          placeholder="Введите строку для поиска..."
          onChange={(event) => setQuery(event.target.value)}
          onKeyDown={(e) => {
            if (['Escape'].includes(e.key)) {
              e.preventDefault();
              setQuery('');
              if (!query) {
                close();
              }
            }
          }}
        />
      </div>

      { false && data && data.length === 0 && (
        <div className="tw-p-3">
          <Alert type="info">
            <p>
              Данный объект не состоит ни в каких коллекциях. И у вас нет ни одной личной коллекции.
              Хотите создать новую коллекцию или добавить в чью-нибудь публичную? 🙂

            </p>
          </Alert>
        </div>
      )}

      {status === 'loading'
        && <Alert type="info">Загружается...</Alert>}

      {status === 'error'
        && <Alert type="danger">Ошибка</Alert>}

      {data && data.length > 0 && (
      <Combobox.Options static className="tw-max-h-96 tw-scroll-py-3 tw-overflow-y-auto tw-p-3">
        {data && data.map((item: Listing) => (
          <Combobox.Option
            key={item.id}
            value={item}
            className={({ active }) => (`
                      tw-flex tw-cursor-pointer tw-select-none tw-rounded-xl tw-p-3 tw-my-px
                      ${active && 'tw-bg-gray-100'}
                      ${item.is_checked && !active && 'tw-bg-lime-50'}
                    `)}
          >
            {({ active }) => (
              <>
                <div
                  className={`
                            tw-flex tw-h-10 tw-w-10 tw-flex-none tw-items-center tw-justify-center tw-rounded-lg
                          `}
                >
                  {/* <item.icon className="tw-h-6 tw-w-6 tw-text-white" aria-hidden="true" /> */}

                  {/* <img alt="" src="" className="tw-h-10? tw-w-10?" /> */}

                  <img
                    className="tw-w-10 tw-h-10 tw-object-contain tw-border tw-rounded tw-bg-white tw-p-px"
                    alt=""
                    src={item.image
                      ? item.image.image_url
                      : 'https://comnplayscience.eu/app/images/notfound.png'}
                  />
                </div>

                <div className={`
                          tw-ml-3 tw-flex-auto tw-flex tw-flex-col tw-justify-center
                        `}
                >

                  <div className={`
                            ${active ? 'tw-text-gray-900' : 'tw-text-gray-700'} `}
                  >
                    {item.name}
                  </div>

                  <p className={`
                            tw-hidden sm:tw-block tw-text-sm
                            ${active ? 'tw-text-gray-700' : 'tw-text-gray-500'}
                          `}
                  >
                    {item.description}
                  </p>
                </div>

                <div className="tw-hidden sm:tw-flex tw-ml-5 tw-items-center tw-gap-3">

                  <div className="tw-bg-slate-100 tw-rounded tw-px-1.5 tw-max-w-[3rem] tw-h-5
                            tw-text-slate-700 tw-font-medium tw-text-xs tw-flex tw-items-center tw-whitespace-nowrap"
                  >
                    {/* { Math.round(item.count * Math.random() * 1000) } */}
                    { item.count }
                  </div>

                  <div className="tw-w-5 tw-h-5 tw-text-gray-400">
                    {item.is_checked ? (
                      <QueueListIcon className="tw-w-5 tw-h-5" />
                    ) : (
                      <>
                      </>
                    )}
                  </div>

                  <div className="tw-w-5 tw-h-5 tw-text-gray-400">
                    {item.is_public ? (
                      <UsersIcon className="tw-w-5 tw-h-5" />
                    ) : (
                      <UserIcon className="tw-w-5 tw-h-5" />
                    )}
                  </div>

                </div>

                <div className="tw-ml-3 tw-flex tw-items-center">
                  <a
                    href={`${language.path}/listings/${item.id}`}
                    className="tw-ml-3 tw-w-10 tw-h-10 tw-inline-flex tw-items-center tw-justify-center tw-text-gray-400
                            tw-rounded-full hover:tw-text-gray-500 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2
                            focus:tw-ring-indigo-500 tw-bg-slate-50 hover:tw-bg-slate-200"
                            // className="tw-w-10 tw-h-10 tw-inline-flex tw-items-center  tw-px-2 tw-py-2
                            //     tw-border tw-border-gray-300 tw-text-sm? tw-leading-5 tw-font-medium
                            //     tw-rounded-full tw-text-gray-700 tw-bg-white hover:tw-bg-gray-100"
                    onClick={(e) => {
                      e.stopPropagation();
                    }}
                  >
                    <ArrowRightIcon className="tw-w-5 tw-h-5" />
                  </a>
                </div>

              </>
            )}
          </Combobox.Option>
        ))}
      </Combobox.Options>
      )}

      {query !== '' && data && data.length === 0 && (
      <div className="tw-py-14 tw-px-6 tw-text-center tw-text-sm sm:tw-px-14">
        <ExclamationCircleIcon
          type="outline"
          name="exclamation-circle"
          className="tw-mx-auto tw-h-6 tw-w-6 tw-text-gray-400"
        />
        <p className="tw-mt-4 tw-font-semibold tw-text-gray-900">No results found</p>
        <p className="tw-mt-2 tw-text-gray-500">No components found for this search term. Please try again.</p>
      </div>
      )}

      <div className="tw-p-4 tw-pl-5">
        <button
          type="button"
          className="tw-inline-flex tw-items-center tw-px-4 tw-py-2.5 tw-border tw-border-transparent
                  tw-text-sm tw-font-medium tw-rounded-md tw-text-indigo-700 tw-bg-indigo-100
                  hover:tw-bg-indigo-200 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2
                  focus:tw-ring-indigo-500"
          onClick={() => setSelectedListing({
            id: null, name: '', description: '', count: null, is_checked: null, is_public: null, is_owner: null,
          })}
        >
          <PlusIcon className="-tw-ml-1 tw-mr-2 tw-h-5 tw-w-5" aria-hidden="true" />
          Новая коллекция
        </button>

        {/* <button
                type="button"
                className="tw-w-full? tw-flex tw-items-center tw-px-4 tw-py-2 tw-border tw-border-transparent
                   tw-text-sm tw-font-medium tw-rounded-md tw-text-white
                  tw-bg-indigo-600 hover:tw-bg-indigo-700 focus:tw-outline-none
                  focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-500"
              >
                <PlusCircleIcon className="-tw-ml-1 tw-mr-2 tw-h-5 tw-w-5" aria-hidden="true" />
                Button text
              </button> */}
      </div>
    </Combobox>
  );
}
