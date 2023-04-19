import * as React from 'react';
import {
  forwardRef, LegacyRef, MutableRefObject, useCallback, useEffect, useLayoutEffect, useRef, useState,
} from 'react';
import {
  AnimatePresence, checkTargetForNewValues, motion, useDomEvent, useInView,
} from 'framer-motion';
import { useDebounce, useTimeout } from 'react-use';
import MentionsSubItem from './MentionsSubItem';

function MentionsItem(
  {
    url, title, publishedAt, topics, image, entities, mentionId,
  } : {
    url: string,
    title: string,
    publishedAt: Date,
    topics: any[],
    image: any,
    entities: any[],
    mentionId: string,
  },
) {
  const [lastKnownHeight, setLastKnownHeight] = useState(500);
  const ref = useRef<HTMLDivElement>(null);
  const isInView = useInView(ref, { amount: 'some', once: false, margin: '-100px 0px -100px 0px' });
  const [isVisible, setIsVisible] = useState<boolean>(true);

  // const [, cancel] = useDebounce(
  //   () => {
  //     if (scrollFinished) {
  //       setIsVisible(false);
  //     }
  //   },
  //   2000,
  //   [scrollFinished],
  // );

  useLayoutEffect(() => {
    if (isInView) {
      if (ref.current) {
        setLastKnownHeight((prevVal) => {
          const newVal = prevVal > ref.current.clientHeight ? prevVal : ref.current.clientHeight;
          return newVal;
        });
      }
    }
  }, [isInView]);

  const timeoutId = useRef();

  const onScroll = useCallback((e) => {
    if (isInView) {
      console.log('removing', url);
      clearTimeout(timeoutId.current);
      // setScrollFinished(false);
    } else {
      console.log('scheduling', url);
      clearTimeout(timeoutId.current);
      timeoutId.current = setTimeout(() => {
        setIsVisible(false);
      }, 1000);
      // setScrollFinished(true);
    }
  }, [isInView]);

  useLayoutEffect(() => {
    setIsVisible(true);
    // if (isInView) {
    console.log('settled on', url);

    window.addEventListener('scroll', onScroll, { passive: true });
    return () => {
      window.removeEventListener('scroll', onScroll);
    };
    // }
    // setIsVisible(false);

    return undefined;
  }, [isInView, onScroll, setIsVisible, url]);

  return (
    isVisible
      ? (
        <div
          ref={ref}
          // style={{ backgroundColor: `rgb(${255 * Math.random()}, ${255 * Math.random()}, ${255 * Math.random()})` }}
        >
          <MentionsSubItem
            title={title}
            url={url}
            publishedAt={publishedAt}
            topics={topics}
            image={image}
            entities={entities}
            mentionId={mentionId}
          />
        </div>
      ) : (
        <div
          className="tw-py-4 tw-my-4 tw-max-w-xl tw-mx-auto tw-bg-slate-50
            tw-border-2 tw-border-dashed tw-border-slate-100 tw-rounded-lg"
          ref={ref}
          style={{ height: lastKnownHeight }}
        />
      )
  );
}

export default React.memo(MentionsItem);
