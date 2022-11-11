import * as React from 'react';
import {
  MutableRefObject, useCallback, useEffect, useLayoutEffect, useRef, useState,
} from 'react';
import {
  animate,
  motion,
  useMotionValue,
  useScroll,
  useSpring,
  AnimatePresence,
  LayoutGroup,
} from 'framer-motion';
import { useDebounce } from 'react-use';
import { ArrowLeftIcon, ArrowRightIcon } from '@heroicons/react/24/solid';
import useResizeObserver from '@react-hook/resize-observer';
import { Easing } from 'react-use/lib/useTween';
import { circOut, easeInOut } from 'popmotion';
import CarouselItems from './CarouselItems';
import { DOMRectJSON, CarouselType } from '../system/TypeScript';
import Popup from './Popup';
import ScrollLeftButton from './ScrollLeftButton';
import ScrollRightButton from './ScrollRightButton';

const useSize = (target: MutableRefObject<HTMLElement>) => {
  const [size, setSize] = useState<DOMRectJSON>();

  useLayoutEffect(() => {
    setSize(target.current.getBoundingClientRect());
  }, [target]);

  // Where the magic happens
  useResizeObserver(target, (entry) => setSize(entry.contentRect.toJSON()));

  return size;
};

export default function Carousel(props: {
  items: any[],
  type: CarouselType,
  carouselId: number
}) {
  const rootPortalRef = useRef<HTMLDivElement>(null);
  const ref = useRef<HTMLDivElement>(null);
  const [startX, setStartX] = useState(0);
  const [scrollLeft, setScrollLeft] = useState(0);
  const [trackMouse, setTrackMouse] = useState(false);
  const [animationComplete, setAnimationComplete] = useState(true);
  const [preventClick, setPreventClick] = useState(false);
  const [showLeftScrollButton, setShowLeftScrollButton] = useState(false);
  const [showRightScrollButton, setShowRightScrollButton] = useState(false);
  const [monitorScroll, setMonitorScroll] = useState<number>();
  const [selectedItem, setSelectedItem] = useState<any>();
  const [internalSelectedItem, setInternalSelectedItem] = useState<any>();
  const x = useMotionValue<number>(0);
  const { scrollXProgress } = useScroll({ container: ref });
  const carouselSize = useSize(ref);
  const [initialClickCoordinates, setInitialClickCoordinates] = useState<{x: number, y: number}>({ x: undefined, y: undefined });

  const { items } = props;

  // const [items, setItems] = useState<number[]>([]);

  // useEffect(() => {
  //
  //   const arr = new Array(100).fill(undefined).map((val, idx) => idx);
  //   setItems(arr);
  //
  //   // const interval = setInterval(() => {
  //   //   const arr = new Array(Math.round(Math.random() * 10)).fill(undefined).map((val, idx) => idx);
  //   //   setItems(arr);
  //   // }, Math.random() * 1000)
  //   //
  //   // return () => {
  //   //   clearInterval(interval)
  //   // }
  //
  // }, []);

  const handleMouseMove = (e: React.MouseEvent) => {
    if (!ref.current) return;
    if (!trackMouse) return;

    // if (Math.abs(e.movementX) < 3) return;
    if (Math.abs(e.clientX - initialClickCoordinates.x) <= 3) return;

    setPreventClick(true);

    const xVal = e.pageX - ref.current.offsetLeft;
    const walk = (xVal - startX) * 1; // scroll-fast

    runAnimation(scrollLeft - walk, circOut);
  };

  useEffect(() => {
    setMonitorScroll(0);
  }, []);

  const runAnimation = (dx: number, ease: Easing) => {
    setAnimationComplete(false);

    const controls = animate(x, dx, {
      type: 'tween',
      ease,
      // duration: 0.5,
      onUpdate: (val) => {
        if (!ref.current) return;
        ref.current.scrollLeft = val;
      },
      onComplete: () => {
        setAnimationComplete(true);
      },
      onStop: () => {
        setAnimationComplete(true);
      },
    });
    return controls.stop;
  };

  const handleMouseDown = (e: React.MouseEvent) => {
    setInitialClickCoordinates({ x: e.clientX, y: e.clientY });
    setPreventClick(false);

    if (!ref.current) return;

    setTrackMouse(true);

    const startX = e.pageX - ref.current.offsetLeft;
    setStartX(startX);

    const { scrollLeft } = ref.current;
    setScrollLeft(scrollLeft);
  };

  const handleMouseLeave = () => {
    setTrackMouse(false);
  };

  const handleMouseUp = (e: React.MouseEvent) => {
    setInitialClickCoordinates({ x: undefined, y: undefined });
    setTrackMouse(false);
  };

  useDebounce(
    () => {
      // console.log('animationComplete', animationComplete);
      if (animationComplete) {
        x.set(monitorScroll);
      }
    },
    100,
    [monitorScroll, animationComplete],
  );

  const handleMouseClick = useCallback((e: React.MouseEvent, item: any) => {
    if (preventClick) {
      e.preventDefault();
      return false;
    }

    setSelectedItem(item);
    return true;
  }, [preventClick]);

  useLayoutEffect(() => {
    setShowLeftScrollButton(ref.current?.scrollLeft !== 0);
  }, [x.get(), items, ref.current?.scrollLeft]);

  useLayoutEffect(() => {
    // NOTE: setTimeout is a dirty bug fix of accidents when right scroll button does not appear
    setTimeout(() => setShowRightScrollButton(
      ref.current?.scrollLeft < ref.current?.scrollWidth - ref.current?.clientWidth,
    ), 300);
  }, [items, carouselSize?.width, ref.current?.scrollLeft,
    ref.current?.scrollWidth, ref.current?.clientWidth]);

  const scrollButtonClick = (amount: number) => {
    runAnimation(amount, easeInOut);
  };

  return (
    <LayoutGroup id={Math.random().toString()}>
      <div
        className={`tw-relative tw-py-1 tw-px-2 tw-bg-slate-100
        ${(props.type === ('single' as CarouselType)) ? 'tw-rounded-t-lg' : 'tw-rounded-lg'}
      `}
      >
        <motion.div
          layoutScroll
          className={`
          ${trackMouse ? 'tw-cursor-grabbing' : 'tw-cursor-grab'}
          ${(props.type === ('single' as CarouselType)) ? 'tw-space-x-4' : 'tw-space-x-2'}
          tw-flex tw-overflow-x-auto tw-pb-1 tw-overflow-y-hidden tw-bg-slate-100
          [&::-webkit-scrollbar-thumb]:tw-bg-slate-300
          [&::-webkit-scrollbar]:tw-bg-slate-100
        `}
          // sm:[&::-webkit-scrollbar-thumb]:tw-bg-transparent
          // group-hover:[&::-webkit-scrollbar-thumb]:tw-bg-slate-300
          // sm:[&::-webkit-scrollbar]:tw-bg-transparent
          // group-hover:[&::-webkit-scrollbar]:tw-bg-slate-100
          ref={ref}
          onMouseMove={handleMouseMove}
          onMouseDown={handleMouseDown}
          onMouseUp={handleMouseUp}
          onMouseLeave={handleMouseLeave}
          onScroll={(e) => setMonitorScroll(e.target.scrollLeft)}
        >
          <CarouselItems
            root={rootPortalRef}
            items={items}
            selectedItem={selectedItem}
            handleMouseClick={handleMouseClick}
            type={props.type}
          />
        </motion.div>

        <div ref={rootPortalRef} className="tw-z-50 tw-relative"></div>

        {false
          && (
          <AnimatePresence>
            {true && showRightScrollButton && (
            <motion.div
              className=""
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
            >
              <svg
                width="50"
                height="50"
                viewBox="0 0 50 50"
                className="tw-absolute tw-top-1/2 -tw-translate-y-1/2 -tw-mt-3 tw-right-3 tw-translate-x-1/2 tw-rotate-90"
              >
                <circle
                  cx="25"
                  cy="25"
                  r="20"
                  pathLength="1"
                  className="tw-stroke-sky-500 tw-opacity-10 tw-fill-transparent tw-stroke-[20%] [stroke-dashoffset:0]"
                />
                <motion.circle
                  cx="25"
                  cy="25"
                  r="20"
                  pathLength="1"
                  className="tw-stroke-blue-600 tw-opacity-90 tw-fill-transparent tw-stroke-[10%] [stroke-dashoffset:0]"
                  style={{ pathLength: scrollXProgress }}
                />
              </svg>
            </motion.div>
            )}
          </AnimatePresence>
          )}

        <ScrollLeftButton
          showScrollButton={showLeftScrollButton}
          scrollButtonClick={scrollButtonClick}
          xRef={ref}
        />

        <ScrollRightButton
          showScrollButton={showRightScrollButton}
          scrollButtonClick={scrollButtonClick}
          xRef={ref}
        />
      </div>
    </LayoutGroup>
  );
}
