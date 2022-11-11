import * as React from 'react';
import { ClockIcon } from '@heroicons/react/24/outline';
import { ArrowTopRightOnSquareIcon } from '@heroicons/react/20/solid';
import {
  forwardRef, LegacyRef, MutableRefObject, useCallback, useEffect, useLayoutEffect, useRef, useState,
} from 'react';
import {
  AnimatePresence, checkTargetForNewValues, motion, useInView,
} from 'framer-motion';
import TimeAgo from '../TimeAgo';
import Multiple from '../Tags/Multiple';
import Image from './Image';
import Interaction from './Interaction';
import Carousel from '../Carousel/Carousel';

function Url(props: { url: string }) {
  let url;

  try {
    url = new URL(props.url);
  } catch (e) {
    return null;
  }

  return (
    <span className="tw-text-sm tw-font-mono tw-text-white">
      {url.hostname}
    </span>
  );
}

function Title(props: { title: string }) {
  if (props.title) {
    return (
      <span className="tw-text-white">
        {props.title}
      </span>
    );
  }
}

function Icon() {
  return (
    <span className="">
      <ArrowTopRightOnSquareIcon className="tw-inline tw-w-3.5 tw-h-3.5" />
    </span>
  );
}

export default function MentionsCard(
  props: {
    url: string,
    title: string,
    publishedAt: Date,
    topics: any[],
    image: any,
    entities: any[],
    mentionId: string,
    layoutGroupId: string,
  },
) {
  const [ref, setRef] = useState({ current: null });
  const [lastKnownHeight, setLastKnownHeight] = useState(0);

  const changeableRef = useCallback((node: HTMLDivElement) => {
    if (node) {
      setRef({ current: node });
    }
  }, []);

  // const ref = useRef<HTMLDivElement>(null);
  const isInView = useInView(ref, { amount: 'some', once: false, margin: '0px 0px 0px 0px' });

  useEffect(() => {
    if (ref.current) {
      setLastKnownHeight((prevVal) => {
        const newVal = prevVal > ref.current.clientHeight ? prevVal : ref.current.clientHeight;
        return newVal;
      });
    }
  }, [isInView, ref]);

  return (

    <AnimatePresence mode="wait" presenceAffectsLayout>
      { isInView
        ? (
          <motion.div
            key={`real-${props.mentionId}`}
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.3 }}
            ref={changeableRef}
          >
            <div className="tw-py-3 2xl:tw-py-5 tw-max-w-xl tw-mx-auto">
              <div className="tw-flex tw-rounded-lg tw-flex-col tw-space-y-5 tw-bg-slate-50">

                <div className="tw-flex tw-shrink tw-p-3 2xl:tw-p-3.5 2xl:tw-text-lg tw-bg-slate-600
                             hover:tw-bg-sky-800 tw-rounded-lg tw-text-base"
                >
                  <a href={props.url} className="tw-text-slate-50 tw-font-medium">
                    <Title title={props.title} />
                  &nbsp;
                    <Url url={props.url} />
                  &nbsp;
                    <Icon />
                  </a>
                </div>

                {props.publishedAt
                && (
                  <div className="tw-flex tw-items-center tw-gap-x-2 tw-text-gray-500">
                    <ClockIcon className="tw-w-5 tw-h-5" />
                    <TimeAgo datetime={props.publishedAt} />
                  </div>
                )}

                {props.topics.length > 0
                && <Multiple tags={props.topics} limit={10} textColor="tw-text-blue-800" bgColor="tw-bg-blue-100" linkify={false} />}

                <div
                  className="tw-flex tw-justify-end tw-flex-grow tw-relative tw-rounded-lg
                  test-pattern? tw-bg-slate-100 tw-items-stretch tw-w-full"
                >
                  <Image image={props.image} url={props.url} layoutGroupId={props.layoutGroupId} />
                  <Interaction
                    mention={{
                      id: props.mentionId, url: props.url, title: props.title, image: props.image,
                    }}
                    entities={props.entities.slice(0, 1)}
                  />
                </div>

                <Carousel items={props.entities} type="multiple" carouselId={props.mentionId} />

              </div>
            </div>
          </motion.div>
        ) : (
          <div
            key={`mock-${props.mentionId}`}
            // initial={{ opacity: 0 }}
            // animate={{ opacity: 1 }}
            // exit={{ opacity: 1 }}
            // transition={{ duration: 0 }}
            className="tw-min-h-[500px] tw-pt-8 tw-pb-8"
            ref={changeableRef}
            style={{ height: lastKnownHeight }}
          >
            <div className="tw-h-full tw-max-w-xl tw-mx-auto" />
          </div>
        )}
    </AnimatePresence>

  );
}
