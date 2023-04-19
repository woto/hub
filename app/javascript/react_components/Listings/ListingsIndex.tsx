import * as React from 'react';
import {
  Fragment, useCallback, useContext, useEffect, useMemo, useState,
} from 'react';
import { Dialog, Transition } from '@headlessui/react';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { AnimatePresence, motion } from 'framer-motion';
import axios from '../system/Axios';
import ListingsForm from './ListingsForm';
import ListingsList from './ListingsList';
import { Listing } from '../system/TypeScript';

export default function ListingsIndex({ opened, close, entityId }: {
  entityId: string,
  opened: boolean,
  close: () => boolean
}) {
  const [selectedListing, setSelectedListing] = useState<Listing>();
  const [query, setQuery] = useState('');
  const queryClient = useQueryClient();

  const queryString = useMemo(() => (
    new URLSearchParams({
      ext_id: entityId,
      favorites_items_kind: 'entities',
      search_string: query,
    })), [entityId, query]);

  const queryKey = useMemo(() => ['listings', queryString.toString()], [queryString]);

  const {
    isLoading, error, data, isFetching, status,
  } = useQuery(
    queryKey,
    () => axios
      .get(`/api/listings/?${queryString}`)
      .then((res) => res.data)
      .then((data) => (
        data.sort((a, b) => {
          if (a.is_checked > b.is_checked) return -1;
          if (a.is_checked < b.is_checked) return 1;
          return 0;
        }))),
    {
      enabled: opened,
    },
  );

  // useEffect(() => {
  //   console.log(status);
  //   console.log(error);
  // }, [status])

  const filterOutListing = useCallback((needle: Listing) => {
    const result = data.filter((haystack: Listing) => (
      needle.id !== haystack.id
    ));
    queryClient.setQueryData(queryKey, result);
  }, [data, queryClient, queryKey]);

  const patchListings = useCallback((needle: Listing) => {
    const result = data.map((el: Listing) => {
      if (el.id === needle.id) {
        return needle;
      }
      return el;
    });
    queryClient.setQueryData(queryKey, result);
  }, [data, queryClient, queryKey]);

  return (
    <Transition.Root show={opened} as={Fragment} afterLeave={() => setQuery('')}>
      <Dialog
        as="div"
        className="tw-fixed tw-inset-0 tw-z-10 tw-overflow-y-auto tw-p-4 sm:tw-p-6 md:tw-p-20"
        onClose={selectedListing ? () => {} : close}
        // onClose={() => {}}
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
          <div className="tw-mx-auto tw-max-w-xl tw-transform tw-overflow-hidden tw-rounded-xl
                tw-bg-white tw-shadow-2xl tw-ring-1 tw-ring-black tw-ring-opacity-5 tw-transition-all"
          >

            <AnimatePresence initial={false} mode="wait">
              { selectedListing
                ? (
                  <motion.div
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                    exit={{ opacity: 0 }}
                    transition={{ duration: 0.1 }}
                    key="1"
                  >
                    <ListingsForm
                      filterOutListing={filterOutListing}
                      patchListings={patchListings}
                      selectedListing={selectedListing}
                      setSelectedListing={setSelectedListing}
                      close={close}
                      entityId={entityId}
                    />
                  </motion.div>
                )
                : (
                  <motion.div
                    className="tw-divide-y tw-divide-gray-100"
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                    exit={{ opacity: 0 }}
                    transition={{ duration: 0.1 }}
                    key="2"
                  >
                    <ListingsList
                      status={status}
                      data={data}
                      query={query}
                      setQuery={setQuery}
                      setSelectedListing={setSelectedListing}
                      close={close}
                    />
                  </motion.div>
                )}
            </AnimatePresence>
          </div>
        </Transition.Child>
      </Dialog>
    </Transition.Root>
  );
}
