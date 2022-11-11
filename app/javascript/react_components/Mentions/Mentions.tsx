import * as React from 'react';
import {
  useRef, useEffect, Fragment, useCallback, useState,
} from 'react';
import {
  AnimatePresence, LayoutGroup, motion, useInView,
} from 'framer-motion';
import { useInfiniteQuery } from 'react-query';
import axios from '../system/Axios';
import MentionsCard from './MentionsCard';
import Alert from '../Alert';
import { MentionResponse } from '../system/TypeScript';

type Window = {
  page: number,
  growing: boolean
}

export default function Mentions(props: {
  entityIds: any[],
  searchString: string,
  sort: string,
  scrollToFirst: boolean
}) {
  const [window, setWindow] = useState<Window>({ page: 0, growing: true });
  const [loadMoreref, setLoadMoreRef] = useState<any>({ current: null });
  // const scrollRef = useRef<HTMLDivElement>();
  const [firstResultRef, setFirstResultRef] = useState<HTMLDivElement>();

  const changeableRef = useCallback((node) => {
    setLoadMoreRef({ current: node });
  }, []);

  const inView = useInView(loadMoreref);

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
    ['mentions', props.entityIds, props.searchString, props.sort],
    async ({ pageParam = 0 }) => axios.post<MentionResponse>('/api/mentions', {
      page: pageParam,
      entity_ids: props.entityIds,
      q: props.searchString,
      sort: props.sort,
    }).then((res) => res.data),
    {
      // cacheTime: 1,

      // select: data => {
      //   let length = data.pages.length;
      //   let unshiftPages = [];
      //   let preserve = 2;
      //   if (length - preserve > 0) {
      //     unshiftPages = Array(length - preserve)
      //       .fill({})
      //       .map((obj, idx) => ({pagination: {current_page: idx}, mentions: []}))
      //   }
      //
      //   return {
      //     pages: [...unshiftPages, ...data.pages.slice(-preserve)],
      //     pageParams: data.pageParams,
      //   }
      // },
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

  useEffect(() => {
    // console.log('useEffect')
    // if (!data || data.pages.length !== 1) {
    //   console.log(data);
    //   return;
    // }

    if (!props.scrollToFirst) return;

    // console.log('useEffect')
    // console.log(firstResultRef)
    setWindow({ page: 0, growing: true });
    if (firstResultRef) {
      firstResultRef.scrollIntoView();
    }
    // console.log('focused')
  }, [firstResultRef]);

  useEffect(() => {
    // console.log('inview', inView);

    if (inView) {
      if (hasNextPage) {
        fetchNextPage();
      }

      if (data && window.page < data.pages[data.pages.length - 1].pagination.current_page) {
        setWindow((prevVal) => ({ page: prevVal.page + 1, growing: true }));
      }
    }
  }, [inView]);

  // useEffect(() => {
  //   if (!window.growing) {
  //     scrollRef && scrollRef.current && scrollRef.current.scrollIntoView({ block: 'center' });
  //   }
  // }, [window, scrollRef.current]);

  const isScrollLocked = useRef(false);

  const scrollingUp = useRef<number>;

  // useEffect(() => {
  //   const mainEl = document.querySelector('#main');

  //   // setTimeout(() => {
  //   //   mainEl.scrollBy({ top: 500, behavior: 'smooth' });
  //   // }, 1000)

  //   function preventDefault(e: MouseEvent) {
  //     // console.log('e.type', e.type);
  //     // console.log('e.deltaY', e.deltaY);

  //     console.log(e.);

  //     if (e.deltaY < 0) return;
  //     e.preventDefault();

  //     if (isScrollLocked.current) return;

  //     console.log('isScrollLocked.current', isScrollLocked.current);

  //     isScrollLocked.current = true;

  //     console.log('isScrollLocked.current', isScrollLocked.current);

  //     // mainEl.removeEventListener('wheel', preventDefault);
  //     // mainEl.removeEventListener('touchmove', preventDefault);
  //     // mainEl.removeEventListener('scroll', preventDefault);

  //     mainEl.scrollBy({ top: 500, behavior: 'auto' });

  //     setTimeout(() => {
  //       isScrollLocked.current = false;
  //     }, 1000);
  //   }

  //   mainEl.addEventListener('wheel', preventDefault, { passive: false });
  //   // mainEl.addEventListener('touchmove', preventDefault, { passive: false });
  //   // mainEl.addEventListener('scroll', preventDefault, { passive: false });

  //   // window.addEventListener('DOMMouseScroll', () => {alert('only firefox')});
  //   // window.addEventListener('wheel', () => {alert('chrome and firefox')});
  //   // window.addEventListener('touchmove', () => {alert('only mobile')});
  //   // window.addEventListener('scroll', () => {alert('scroll')});

  //   return () => {
  //     mainEl.removeEventListener('wheel', preventDefault);
  //     // mainEl.removeEventListener('touchmove', preventDefault);
  //     // mainEl.removeEventListener('scroll', preventDefault);
  //   };
  // }, []);

  return (
    <div className="tw-mt-2? lg:tw-mt-8?">
      <div className="tw-grid tw-grid-cols-1 tw-gap-4 lg:tw-col-span-3">
        <div className="sm:tw-rounded-b-lg tw-bg-white tw-shadow">
          <div className="tw-p-4 tw-min-h-screen tw-overflow-clip?">

            {status === 'loading'
              && <Alert type="info">Загружается...</Alert>}

            {status === 'error'
              && <Alert type="danger">Ошибка</Alert>}

            {/* <AnimatePresence mode={"sync"} initial={false}> */}
            {status === 'success'
              && (
                <>
                  {false
                    && (
                      <button
                        type="button"
                        className="tw-flex tw-mx-auto tw-mt-2 tw-mb-6 tw-items-center tw-px-4 tw-py-2 tw-border tw-border-transparent
                      tw-text-sm tw-font-medium tw-rounded tw-text-indigo-700 tw-bg-indigo-100 hover:tw-bg-indigo-200
                      focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-500"
                        onClick={(e) => {
                          setWindow((prevVal) => {
                            const newPage = prevVal.page > 1 ? prevVal.page - 1 : prevVal.page;
                            return {
                              growing: false,
                              page: newPage,
                            };
                          });
                        }}
                      >
                        Показать предыдущие...
                      </button>
                    )}

                  {data && data.pages && data.pages.length > 0 && data.pages[0].mentions
                  && data.pages[0].mentions.length === 0
                    ? (
                      <Alert type="info">
                        Ничего не найдено
                      </Alert>
                    )
                    : (
                      <>
                        {data && data.pages.map((page, pageIdx) => (
                          <Fragment key={`${page.pagination.current_page}:${props.searchString}`}>
                            {
                            pageIdx === 0
                            && (
                              <div // id={'wtf'}
                                //  key={`${page.pagination.current_page}:${props.searchString}`}
                                ref={setFirstResultRef}
                                className="tw-h-14 tw-flex tw-justify-center tw-items-center tw-mb-2 tw-px-2 test-pattern? tw-text-gray-500 tw-text-center tw-text-sm"
                              >
                                Результаты поиска
                                {/* {new Date().toString()} */}
                              </div>
                            )
                          }

                            {page.mentions.map((mention, mentionIdx) => (
                              //   <Fragment key={mentionIdx}>
                              //   { mention._source.entities.map((ent) => (
                              //     <a className="tw-block tw-pb-80" key={ent.id} href={`/entities/${ent.id}`}>
                              //       {ent.title}
                              //     </a>
                              //   )) }
                              // </Fragment>
                              <div
                                className="tw-snap-center? tw-snap-always? tw-snap-mandatory?"
                                key={mention._id}
                              >
                                <MentionsCard
                                  key={mention._id}
                                  mentionId={mention._id}
                                  // {...(page.pagination.current_page + 1 === window.page && { ref: scrollRef })}
                                  id={mention._source.id}
                                  title={mention._source.title}
                                  image={
                                      (mention._source.image
                                      && mention._source.image.length > 0
                                      && mention._source.image[0]) || null
                                    }
                                  url={mention._source.url}
                                  entities={mention._source.entities}
                                  topics={mention._source.topics}
                                  publishedAt={mention._source.published_at}
                                  layoutGroupId={`${pageIdx.toString()}-${mentionIdx.toString()}-${mention._id}-${page.pagination.current_page}`}
                                />
                              </div>
                            ))}
                          </Fragment>
                        ))}

                        <div
                          ref={changeableRef}
                          className="tw-w-20 tw-h-20 tw-absolute tw-bottom-[2000px] tw-left-1/2 -tw-translate-x-1/2"
                        />

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

                    )}
                </>
              )}
            {/* </AnimatePresence> */}
          </div>
        </div>
      </div>
    </div>
  );
}
