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

function Carousel(props: {
  items: any[],
  type: CarouselType,
}) {
  // const [refObj, setRefObj] = useState<HTMLDivElement>(null);
  // const refCallback = useCallback((node) => {
  //   setRefObj(node);
  // }, []);
  const refObj = useRef();
  const [startX, setStartX] = useState(0);
  const [scrollLeft, setScrollLeft] = useState(0);
  const [trackMouse, setTrackMouse] = useState(false);
  const [animationComplete, setAnimationComplete] = useState(true);
  const [preventClick, setPreventClick] = useState(false);
  const [showLeftScrollButton, setShowLeftScrollButton] = useState(false);
  const [showRightScrollButton, setShowRightScrollButton] = useState(true);
  const [monitorScroll, setMonitorScroll] = useState<number>(0);
  const [selectedItem, setSelectedItem] = useState<any>();
  const [internalSelectedItem, setInternalSelectedItem] = useState<any>();
  const x = useMotionValue<number>(0);
  const { scrollXProgress } = useScroll({ container: refObj });
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
    if (!refObj.current) return;
    if (!trackMouse) return;

    // if (Math.abs(e.movementX) < 3) return;
    if (Math.abs(e.clientX - initialClickCoordinates.x) <= 3) return;

    setPreventClick(true);

    const xVal = e.pageX - refObj.current.offsetLeft;
    const walk = (xVal - startX) * 1; // scroll-fast

    runAnimation(scrollLeft - walk, circOut);
  };

  const runAnimation = (dx: number, ease: Easing) => {
    setAnimationComplete(false);

    const controls = animate(x, dx, {
      type: 'tween',
      ease,
      // duration: 0.5,
      onUpdate: (val) => {
        if (!refObj.current) return;
        refObj.current.scrollLeft = val;
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

    if (!refObj.current) return;

    setTrackMouse(true);

    const startX = e.pageX - refObj.current.offsetLeft;
    setStartX(startX);

    const { scrollLeft } = refObj.current;
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
    setShowLeftScrollButton(refObj.current?.scrollLeft !== 0);
  }, [x.get(), items, refObj, refObj.current?.scrollLeft]);

  useLayoutEffect(() => {
    setShowRightScrollButton(
      refObj.current?.scrollLeft + 1 < refObj.current?.scrollWidth - refObj.current?.clientWidth,
    );
  }, [refObj.current?.scrollLeft,
    refObj.current?.scrollWidth, refObj.current?.clientWidth]);

  const scrollButtonClick = (amount: number) => {
    runAnimation(amount, easeInOut);
  };

  return (
  // <LayoutGroup id={Math.random().toString()}>
    <div
      className={`tw-relative tw-py-0.5 tw-px-2 tw-bg-slate-100
        ${props.type === 'single' ? 'tw-rounded-t-lg' : 'tw-rounded-lg'}
      `}
    >
      <motion.div
        layoutScroll
        className={`
          ${trackMouse ? 'tw-cursor-grabbing' : 'tw-cursor-grab'}
          ${props.type === 'single' ? 'tw-space-x-3' : 'tw-space-x-2'}
          tw-flex tw-overflow-x-auto tw-py-1.5 tw-overflow-y-hidden tw-bg-slate-100
          [&::-webkit-scrollbar-thumb]:tw-bg-slate-300
          [&::-webkit-scrollbar]:tw-bg-slate-100
        `}
          // sm:[&::-webkit-scrollbar-thumb]:tw-bg-transparent
          // group-hover:[&::-webkit-scrollbar-thumb]:tw-bg-slate-300
          // sm:[&::-webkit-scrollbar]:tw-bg-transparent
          // group-hover:[&::-webkit-scrollbar]:tw-bg-slate-100
        ref={refObj}
        onMouseMove={handleMouseMove}
        onMouseDown={handleMouseDown}
        onMouseUp={handleMouseUp}
        onMouseLeave={handleMouseLeave}
        onScroll={(e) => setMonitorScroll(e.target.scrollLeft)}
      >
        { true
          ? (
            <CarouselItems
              container={refObj}
              items={items}
              selectedItem={selectedItem}
              handleMouseClick={handleMouseClick}
              type={props.type}
            />
          )
          : <></>}
      </motion.div>

      {true
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
        xRef={refObj}
      />

      <ScrollRightButton
        showScrollButton={showRightScrollButton}
        scrollButtonClick={scrollButtonClick}
        xRef={refObj}
      />
    </div>
  // </LayoutGroup>
  );
}

export default React.memo(Carousel);
