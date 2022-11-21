import * as React from 'react';
import {
  forwardRef, LegacyRef, MutableRefObject, useCallback, useEffect, useLayoutEffect, useRef, useState,
} from 'react';
import {
  AnimatePresence, checkTargetForNewValues, motion, useInView,
} from 'framer-motion';
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
  const [lastKnownHeight, setLastKnownHeight] = useState(300);
  const ref = useRef<HTMLDivElement>(null);
  const isInView = useInView(ref, { amount: 'some', once: false, margin: '-0px 0px -0px 0px' });

  useEffect(() => {
    if (ref.current) {
      setLastKnownHeight((prevVal) => {
        const newVal = prevVal > ref.current.clientHeight ? prevVal : ref.current.clientHeight;
        return newVal;
      });
    }
  }, [isInView, ref]);

  return (
    <div
      className="tw-my-5 md:tw-p-3 tw-rounded-lg test-pattern"
      // style={{
      //   background: `rgb(${255 * Math.random()}, ${255 * Math.random()}, ${255 * Math.random()}, 1)`,
      // }}
    >
      { isInView
        ? (
          <div
            ref={ref}
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
            // className="tw-max-w-xl tw-mx-auto tw-bg-slate-50 tw-rounded-lg"
            ref={ref}
            style={{ height: lastKnownHeight }}
          />
        ) }
    </div>
  );
}

export default React.memo(MentionsItem);
