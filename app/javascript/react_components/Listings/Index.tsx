import * as React from 'react';
import { Fragment, useContext, useState } from 'react';
import { Dialog, Transition } from '@headlessui/react';
import { useQuery } from 'react-query';
import axios from '../system/Axios';
import Form from './Form';
import List from './List';
import { Listing } from '../system/TypeScript';
import { FloatingOverlay } from '@floating-ui/react-dom-interactions';

export default function Index(props: {
  entityId: string,
  opened: boolean,
  close: () => boolean
}) {
  const [selectedListing, setSelectedListing] = useState<Listing>();
  const [query, setQuery] = useState('');
  const { opened, close, entityId } = props;

  const queryString = new URLSearchParams({
    ext_id: entityId,
    favorites_items_kind: 'entities',
    search_string: query,
  });

  const {
    isLoading, error, data, isFetching,
  } = useQuery(
    ['listings', queryString.toString()],
    () => axios
      .get(`/api/listings/?${queryString}`)
      .then((res) => res.data),
    {
      enabled: opened,
    },
  );

  return (
    <Transition.Root show={opened} as={Fragment} afterLeave={() => setQuery('')}>
      <Dialog
        as="div"
        className="tw-fixed tw-inset-0 tw-z-10 tw-overflow-y-auto tw-p-4 sm:tw-p-6 md:tw-p-20"
        onClose={close}
      >
        <Transition.Child
          as={Fragment}
          enter="tw-ease-out tw-duration-300"
          enterFrom="tw-opacity-0"
          enterTo="tw-opacity-100"
          leave="tw-ease-in tw-duration-200"
          leaveFrom="tw-opacity-100"
          leaveTo="tw-opacity-0"
          afterLeave={() => setSelectedListing(null)}
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
          <div className="tw-mx-auto tw-max-w-xl tw-transform tw-divide-y tw-divide-gray-100 tw-overflow-hidden tw-rounded-xl
              tw-bg-white tw-shadow-2xl tw-ring-1 tw-ring-black tw-ring-opacity-5 tw-transition-all"
          >

            { selectedListing
              ? (
                <Form
                  selectedListing={selectedListing}
                  setSelectedListing={setSelectedListing}
                  close={close}
                  entityId={entityId}
                />
              )
              : (
                <List
                  data={data}
                  query={query}
                  setQuery={setQuery}
                  setSelectedListing={setSelectedListing}
                  close={close}
                />
              )}
          </div>
        </Transition.Child>
      </Dialog>
    </Transition.Root>
  );
}
