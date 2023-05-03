import * as React from 'react';
import {
  useRef, useEffect, Fragment, useCallback, useState, useLayoutEffect,
} from 'react';
import {
  AnimatePresence, LayoutGroup, motion, useInView,
} from 'framer-motion';
import { useInfiniteQuery } from '@tanstack/react-query';
import axios from '../system/Axios';
import Alert from '../Alert';
import {
  EntityMentions, ListingMentionsParamsType, MentionResponse, MentionsParamsType,
} from '../system/TypeScript';
import MentionsPage from './MentionsPage';

type Window = {
  page: number,
  growing: boolean
}

type OneOfMentionsType = ListingMentionsParamsType | MentionsParamsType | EntityMentions

const getValues = (params: OneOfMentionsType) => {
  const { kind } = params;

  const commonParams = {
    fetchFunction: params.fetchFunction,
    mentionsSearchStringParam: params.mentionsSearchString,
    sortParam: params.sort,
  };

  switch (kind) {
    case 'listingMentions': {
      return { ...commonParams, listingIdParam: params.listingId };
    }
    case 'mentions': {
      return { ...commonParams, mentionIdParam: params.mentionId };
    }
    case 'entitiesMentions': {
      return { ...commonParams, entityIdsParam: params.entityIds };
    }
    default:
      throw new Error('wrong kind');
  }
};

export default function MentionsCore(params: OneOfMentionsType) {
  const {
    mentionsSearchStringParam, sortParam, mentionIdParam,
    listingIdParam, entityIdsParam, fetchFunction,
  } = getValues(params);

  const [window, setWindow] = useState<Window>({ page: 0, growing: true });
  const loadMoreRef = useRef<HTMLDivElement>();

  const inView = useInView(loadMoreRef, { amount: 'some', once: false, margin: '0px 0px 1000px 0px' });

  const {
    status,
    data,
    error,
    isFetching,
    isFetchingNextPage,
    isFetchingPreviousPage,
    fetchNextPage,
    fetchPreviousPage,
    hasNextPage,
    hasPreviousPage,

  } = useInfiniteQuery(
    ['mentions', entityIdsParam, listingIdParam, mentionIdParam, mentionsSearchStringParam, sortParam],
    async ({ pageParam = 0 }) => fetchFunction({
      entityIdsParam,
      listingIdParam,
      mentionIdParam,
      mentionsSearchStringParam,
      sortParam,
      pageParam,
    })
      .then((res) => res.data),
    {
      getPreviousPageParam: (firstPage) => (
        firstPage.pagination.total_pages > 0
        && firstPage.pagination.current_page - 1
      ),
      getNextPageParam: (lastPage) => (
        lastPage.pagination.total_pages > 0
          && !lastPage.pagination.last_page ? lastPage.pagination.current_page + 1 : undefined
      ),
    },
  );

  useLayoutEffect(() => {
    if (inView) {
      if (hasNextPage) {
        fetchNextPage();
      }

      if (data && window.page < data.pages[data.pages.length - 1].pagination.current_page) {
        setWindow((prevVal) => ({ page: prevVal.page + 1, growing: true }));
      }
    }
  }, [inView]);

  return (
    <div className="tw-grid tw-grid-cols-1 tw-gap-4 lg:tw-col-span-3">
      <div className="sm:tw-rounded-b-lg tw-bg-white tw-shadow">
        <div className="tw-p-4 tw-min-h-screen tw-overflow-clip?">

          {status === 'loading'
            && <Alert type="info">Загружается...</Alert>}

          {status === 'error'
            && <Alert type="danger">Ошибка</Alert>}

          {status === 'success'
            && (
              data && data.pages && data.pages.length > 0 && data.pages[0].mentions
                && data.pages[0].mentions.length === 0
                ? (
                  <Alert type="info">
                    Ничего не найдено
                  </Alert>
                )
                : (
                  <>
                    {data && data.pages.map((page, pageIdx) => (
                      <MentionsPage
                        key={page.pagination.current_page}
                        page={page}
                        pageIdx={pageIdx}
                      />
                    ))}

                    <button
                      type="button"
                      className={`
                          ${!isFetching && hasNextPage
                        ? `tw-text-indigo-700 tw-bg-indigo-100 hover:tw-bg-indigo-200
                          focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-500`
                        : 'tw-text-gray-500'}
                          tw-flex tw-mx-auto tw-my-5 tw-items-center tw-px-3 tw-py-2 tw-border tw-border-transparent
                          tw-text-sm tw-font-medium tw-rounded focus:tw-outline-none`}
                      onClick={() => {
                        fetchNextPage();
                        setWindow((prevVal) => ({ page: prevVal.page + 1, growing: true }));
                      }}
                      disabled={!hasNextPage || isFetchingNextPage}
                    >
                      {isFetchingNextPage
                        ? 'Загружается...'
                        : hasNextPage
                          ? 'Загрузить ещё'
                          : 'Всё загружено'}
                    </button>
                  </>
                )
            )}
          <div
            ref={loadMoreRef}
            className="tw-w-20 tw-h-20 tw-absolute tw-bottom-80 tw-left-1/2 -tw-translate-x-1/2 tw-invisible"
          />
        </div>
      </div>
    </div>
  );
}
