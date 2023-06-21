import { Fragment, useRef, useState } from 'react';
import { Combobox, Dialog, Transition } from '@headlessui/react';
import { ChevronRightIcon, MagnifyingGlassIcon } from '@heroicons/react/24/outline';
import * as React from 'react';
import { useQuery } from '@tanstack/react-query';
import { useLocalStorage } from 'react-use';
import { XMarkIcon } from '@heroicons/react/24/solid';
import axios from '../system/Axios';
import Multiple from '../Tags/Multiple';
import NothingFound from './NothingFound';
import RandomAdvice from './RandomAdvice';
import Searching from './Searching';
import Error from './Error';

export default function Modal(props: {
  open: boolean,
  setOpen: React.Dispatch<React.SetStateAction<boolean>>
}) {
  const { open, setOpen } = props;
  const preservedQuery = new URLSearchParams(window.location.search).get('q');
  const [query, setQuery] = useState(preservedQuery);
  // const inputRef = useRef<HTMLInputElement>();
  // const [randomAdvice, setRandomAdvice] = useState(0);

  const params = {
    search_string: query,
    fragment_url: '',
  };

  const {
    isLoading, error, data, isFetching,
  } = useQuery(
    ['search', params],
    () => axios
      .post('/api/entities/seek', params)
      .then((res) => res.data),
    {
      enabled: !!query,
    },
  );

  const [recent, setRecent, removeRecent] = useLocalStorage('recent', []);

  // https://github.com/you-dont-need/You-Dont-Need-Lodash-Underscore#_unionBy
  function unionBy(...arrays) {
    const iteratee = (arrays).pop();

    if (Array.isArray(iteratee)) {
      return []; // return empty if iteratee is missing
    }

    return [...arrays].flat().filter(
      ((set) => (o) => (set.has(iteratee(o)) ? false : set.add(iteratee(o))))(new Set()),
    );
  }

  const isVisiting = (id: number) => {
    const url = new URL(window.location.href);
    return url.pathname.endsWith(`/${id}`);
  };

  return (
    <Transition.Root show={open} as={Fragment} afterLeave={() => setQuery(preservedQuery)}>
      <Dialog as="div" className="tw-fixed tw-inset-0 tw-z-50 tw-p-2 sm:tw-p-10 tw-overflow-hidden" onClose={setOpen}>
        <Transition.Child
          as={Fragment}
          enter="tw-ease-out tw-duration-300"
          enterFrom="tw-opacity-0"
          enterTo="tw-opacity-100"
          leave="tw-ease-in tw-duration-200"
          leaveFrom="tw-opacity-100"
          leaveTo="tw-opacity-0"
        >
          <Dialog.Overlay className="tw-fixed tw-inset-0 tw-bg-slate-500/50" />
        </Transition.Child>

        <Transition.Child
          as={Fragment}
          enter="tw-ease-out tw-duration-300"
          enterFrom="tw-opacity-0 tw-scale-95"
          enterTo="tw-opacity-100 tw-scale-100"
          leave="tw-ease-in tw-duration-200"
          leaveFrom="tw-opacity-100 tw-scale-100"
          leaveTo="tw-opacity-0 tw-scale-95"
        >
          <Combobox
            as="div"
            className="tw-mx-auto tw-max-w-5xl tw-transform tw-divide-y tw-divide-gray-100
              tw-overflow-hidden tw-rounded-xl tw-shadow-2xl tw-ring-1
              tw-ring-black tw-ring-opacity-5 tw-transition-all tw-bg-white tw-h-full tw-flex tw-flex-col"
            onChange={(item) => {
              const url = new URL(`/entities/${item.entity_id}`, window.location.origin);
              if (query) url.searchParams.set('q', query);
              setRecent((data) => unionBy([item], data.slice(0, 49), ((x) => x.entity_id)));
              // Turbo.visit(url.toString());
              window.location.assign(url.toString());
            }}
            value={query}
          >
            {({ activeOption }) => (
              <>
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
                          setOpen(false);
                        }
                      }
                    }}
                    // ref={inputRef}
                  />
                  <div className="tw-absolute tw-inset-y-0 tw-right-2 tw-flex tw-py-1.5 tw-pr-0.5">
                    <button
                      tabIndex={-1}
                      type="button"
                      onClick={() => {
                        setQuery('');
                        if (!query) {
                          setOpen(false);
                        }
                      }}
                      className="tw-inline-flex tw-items-center tw-rounded tw-px-1.5 tw-text-gray-400 hover:tw-text-gray-600"
                    >
                      <XMarkIcon className="tw-h-7 tw-w-7" aria-hidden="true" />
                    </button>
                  </div>
                </div>

                {!isFetching && (!query || (data && data.length > 0)) && (
                  <Combobox.Options
                    as="div"
                    static
                    hold
                    className="tw-flex tw-divide-x tw-transition-all tw-divide-gray-100 tw-h-full tw-overflow-auto"
                  >
                    { (recent.length > 0 || (data && data.length > 0)) && (
                    <div
                      className={`
                        tw-min-w-0 tw-flex-auto tw-scroll-py-4 tw-overflow-y-auto tw-px-4 sm:tw-px-6 tw-py-4
                      `}
                    >
                      {!query && recent.length > 0 && (
                        <h2 className="tw-mt-2 tw-mb-4 tw-text-xs tw-font-semibold tw-text-gray-500">Предыдущие находки</h2>
                      )}
                      <div className="-tw-mx-2 tw-text-base tw-text-gray-700 tw-mb-1?">
                        {(!query
                          ? recent
                          : ((data && data.length > 0 && data) || [])).map((item) => (
                            <Combobox.Option
                              as="div"
                              key={item.entity_id}
                              value={item}
                              className={({ active }) => (`
                                ${isVisiting(item.entity_id) ? 'tw-bg-stone-100' : ''}
                                ${active && 'tw-bg-gray-100 tw-text-gray-900'}
                                tw-flex tw-cursor-pointer tw-select-none tw-items-center tw-rounded-md tw-p-3 tw-my-px
                            `)}
                            >
                              {({ active }) => (
                                <>
                                  <img
                                    src={item.images && item.images.length > 0
                                      ? item.images[0].image_url
                                      : 'https://comnplayscience.eu/app/images/notfound.png'}
                                    alt=""
                                    loading="lazy"
                                    className="tw-object-contain tw-h-14 tw-w-14 tw-flex-none tw-rounded tw-bg-white tw-border tw-p-1"
                                  />

                                  <span className="tw-ml-3 tw-flex-auto tw-truncate">{item.title}</span>

                                  {active && (
                                  <ChevronRightIcon
                                    className="tw-ml-3 tw-h-5 tw-w-5 tw-flex-none tw-text-gray-400"
                                    aria-hidden="true"
                                  />
                                  )}
                                </>
                              )}
                            </Combobox.Option>
                        ))}
                      </div>
                    </div>
                    )}

                    {activeOption && (
                      <div className="tw-hidden tw-w-1/2 tw-flex-none tw-flex-col tw-divide-y tw-divide-gray-100 tw-overflow-y-auto sm:tw-flex">
                        <div className="tw-flex-none tw-p-6 tw-text-center">

                          <img
                            src={activeOption.images && activeOption.images.length > 0
                              ? activeOption.images[0].image_url
                              : 'https://comnplayscience.eu/app/images/notfound.png'}
                            alt=""
                            className="tw-object-scale-down tw-mx-auto tw-h-[200px] tw-w-[200px] tw-box-content tw-p-3 tw-border tw-rounded-md"
                          />

                        </div>

                        <div className="tw-text-base tw-leading-6? tw-text-gray-500 tw-p-6">

                          <h2 className="tw-mb-4 tw-font-semibold tw-text-gray-900">{activeOption.title}</h2>

                          {activeOption && activeOption.kinds && activeOption.kinds.length > 0 && (
                            <div className="tw-mb-4">
                              <Multiple tags={activeOption.kinds} limit={10} textColor="tw-text-blue-800" bgColor="tw-bg-blue-100" linkify={false} />
                            </div>
                          )}

                          {activeOption.intro}
                        </div>
                      </div>
                    )}
                  </Combobox.Options>
                )}

                {isFetching && (
                  <Searching />
                )}

                {!isFetching && error && (
                  <Error />
                )}

                {!isFetching && query && (data && data.length === 0) && (
                  <NothingFound />
                )}

                <div className="tw-hidden sm:tw-flex tw-flex-wrap tw-items-center tw-bg-gray-50 tw-py-2.5 tw-px-4 tw-text-xs tw-text-gray-700">
                  <RandomAdvice />
                </div>
              </>
            )}
          </Combobox>
        </Transition.Child>
      </Dialog>
    </Transition.Root>
  );
}
