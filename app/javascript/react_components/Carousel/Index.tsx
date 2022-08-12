import * as React from 'react';
import {useEffect, useRef, useState} from "react";
import {animate, motion, useMotionValue, useScroll} from "framer-motion/dist/framer-motion";
import {useDebounce} from "react-use";
import {ArrowLeftIcon, ArrowRightIcon} from "@heroicons/react/solid";
import Items from './Items';

export default function Carousel(props: {items: any[]}) {
  const ref = useRef<HTMLElement>(null);
  const [startX, setStartX] = useState(0);
  const [scrollLeft, setScrollLeft] = useState(0);
  const [trackMouse, setTrackMouse] = useState(false);
  const [animationComplete, setAnimationComplete] = useState(true);
  const [preventClick, setPreventClick] = useState(false);
  const [showLeftScrollButton, setShowLeftScrollButton] = useState(false);
  const [showRightScrollButton, setShowRightScrollButton] = useState(false);
  const [monitorScroll, setMonitorScroll] = useState<number>();
  const x = useMotionValue<number>(0);
  const {scrollXProgress} = useScroll( { container: ref } );
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

    setPreventClick(true);

    const xVal = e.pageX - ref.current.offsetLeft;
    const walk = (xVal - startX) * 1; // scroll-fast

    runAnimation(scrollLeft - walk, "circOut");
  };

  useEffect(() => {
    setMonitorScroll(0);
  }, [])

  const runAnimation = (dx: number, ease: string) => {
    setAnimationComplete(false);

    const controls = animate(x, dx, {
      type: "tween",
      ease: ease,
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
      }
    });
    return controls.stop;
  }

  const handleMouseDown = (e: React.MouseEvent) => {
    setPreventClick(false);

    if (!ref.current) return;

    setTrackMouse(true);

    const startX = e.pageX - ref.current.offsetLeft;
    setStartX(startX);

    const scrollLeft = ref.current.scrollLeft;
    setScrollLeft(scrollLeft);
  };

  const handleMouseLeave = () => {
    setTrackMouse(false);
  };

  const handleMouseUp = (e: React.MouseEvent) => {
    setTrackMouse(false);
  };

  useDebounce(
    () => {
      console.log('animationComplete', animationComplete);
      if (animationComplete) {
        x.set(monitorScroll);
      }
    },
    100,
    [monitorScroll, animationComplete]
  );

  const handleMouseClick = (e: React.MouseEvent) => {
    if (preventClick) {
      e.preventDefault();
    }
  }

  useEffect(() => {
    setShowLeftScrollButton(ref.current?.scrollLeft !== 0);
  }, [props.items, ref.current?.scrollLeft])

  useEffect(() => {
    setShowRightScrollButton(ref.current?.scrollLeft !== ref.current?.scrollWidth - ref.current?.clientWidth)
  }, [props.items, ref.current?.scrollLeft, ref.current?.scrollWidth, ref.current?.clientWidth])

  const scrollButtonClick = (amount: number) => {
    runAnimation(amount, 'easeInOut');
  }

  return (
    <div className={"tw-relative tw-mb-10"}>

      {true &&
        <svg width="50" height="50" viewBox="0 0 50 50"
             className={"tw-absolute tw-top-0 tw-left-0 tw-rotate-90"}
        >
          <circle cx="25" cy="25" r="10" pathLength="1"
                  className="tw-stroke-sky-500 tw-opacity-10 tw-fill-transparent tw-stroke-[20%] [stroke-dashoffset:0]"/>
          <motion.circle
            cx="25"
            cy="25"
            r="10"
            pathLength="1"
            className="tw-stroke-blue-600 tw-opacity-50 tw-fill-transparent tw-stroke-[20%] [stroke-dashoffset:0]"
            style={{pathLength: scrollXProgress}}
          />
        </svg>
      }

      <motion.div
        className={`
          ${trackMouse ? 'tw-cursor-grabbing' : 'tw-cursor-grab'}
          tw-flex tw-h-[350px] tw-overflow-x-scroll tw-space-x-[20px] tw-rounded-lg tw-bg-indigo-600 tw-p-5`}
        ref={ref}
        onMouseMove={handleMouseMove}
        onMouseDown={handleMouseDown}
        onMouseUp={handleMouseUp}
        onMouseLeave={handleMouseLeave}
        onClick={handleMouseClick}
        onScroll={(e) => setMonitorScroll(e.target.scrollLeft)}
      >
        <Items items={props.items}></Items>
      </motion.div>

      {showLeftScrollButton &&
        <button
          type="button"
          className="tw-absolute tw-left-0 -tw-ml-5 tw-top-1/2 -tw-translate-y-1/2 tw-inline-flex tw-items-center
          tw-p-2 tw-border tw-border-transparent tw-rounded-full tw-shadow-sm tw-text-indigo-400 tw-bg-indigo-100
          hover:tw-bg-indigo-200 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-500"
          onClick={() => scrollButtonClick(-ref.current?.clientWidth / 2 + ref.current?.scrollLeft)}
        >
          <ArrowLeftIcon className="tw-h-5 tw-w-5" aria-hidden="true"/>
        </button>
      }

      {showRightScrollButton &&
        <button
          type="button"
          className="tw-absolute tw-right-0 -tw-mr-5 tw-top-1/2 -tw-translate-y-1/2 tw-inline-flex tw-items-center
          tw-p-2 tw-border tw-border-transparent tw-rounded-full tw-shadow-sm tw-text-indigo-400 tw-bg-indigo-100
          hover:tw-bg-indigo-200 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-500"
          onClick={() => scrollButtonClick(ref.current?.clientWidth / 2 + ref.current?.scrollLeft)}
        >
          <ArrowRightIcon className="tw-h-5 tw-w-5" aria-hidden="true"/>
        </button>
      }
    </div>
  );
}
