import * as React from 'react';
import {
  Dispatch, SetStateAction, useEffect, useState,
  useRef, forwardRef, Fragment,
} from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import {
  ArrowDownIcon,
  ArrowUpIcon,
  FireIcon,
  HandThumbDownIcon,
  HandThumbUpIcon,
  StarIcon,
  BookmarkIcon,
} from '@heroicons/react/24/solid';

import {
  useFloating,
  useInteractions,
  useListNavigation,
  useClick,
  useDismiss,
  FloatingFocusManager,
  FloatingPortal,
  useRole,
  offset,
  flip,
  autoUpdate,
  useId,
  shift,
  FloatingOverlay,
  arrow,
} from '@floating-ui/react-dom-interactions';
import type { Placement } from '@floating-ui/react-dom-interactions';
import { Transition } from '@headlessui/react';
import { autoPlacement } from '@floating-ui/core';
import { CarouselType, DOMRectJSON } from '../system/TypeScript';
import Popup from './Popup';
import Complain from '../Complain';

type OptionProps = React.HTMLAttributes<HTMLDivElement> & {
  name: string;
  active: boolean;
  selected: boolean;
  children: React.ReactNode;
};

const Option = forwardRef<HTMLDivElement, OptionProps>((
  {
    name, active, selected, children, ...props
  },
  ref,
) => {
  const id = useId();
  return (
    <div
      {...props}
      ref={ref}
      id={id}
      role="option"
      aria-selected={selected}
      style={{
        background: active
          ? 'rgba(0, 255, 255, 0.5)'
          : selected
            ? 'rgba(0, 10, 20, 0.1)'
            : 'none',
        border: active
          ? '1px solid rgba(0, 225, 255, 1)'
          : '1px solid transparent',
        borderRadius: 4,
        fontSize: 30,
        textAlign: 'center',
        cursor: 'default',
        userSelect: 'none',
        padding: 0,
      }}
    >
      {children}
    </div>
  );
});

function CarouselItem({
  root, item, type, selectedItem, handleMouseClick,
}: {
  root: any,
  item: any,
  type: CarouselType,
  selectedItem: any
  handleMouseClick: (e: React.MouseEvent, item: any) => void
}) {
  const [open, setOpen] = useState(false);
  const [isComplainOpen, setIsComplainOpen] = useState(false);

  // const [placement, setPlacement] = useState<Placement | null>(null);
  const arrowRef = useRef(null);
  const buttonId = useId();

  const {
    x,
    y,
    reference,
    floating,
    strategy,
    context,
    placement,
  } = useFloating({
    strategy: 'absolute',
    // placement: placement ?? 'bottom',
    open,
    onOpenChange: () => { },
    // onOpenChange(open) {
    //   handleMouseClick()
    // },
    // We don't want flipping to occur while searching, as the floating element
    // will resize and cause disorientation.
    middleware: [
      autoPlacement(),
      offset(10),
      // offset(({ rects }) => -rects.reference.height / 2 - rects.floating.height / 2),
      // flip({ padding: 10 }),
      // ...(placement ? [] : [flip()]),
      shift({ padding: 15 }),
      // arrow({ element: arrowRef }),
      // autoPlacement({allowedPlacements: ['top', 'bottom', 'left', 'right'], alignment: 'start'}),
    ],
    whileElementsMounted: autoUpdate,
    // whileElementsMounted: (reference, floating, update) => autoUpdate(reference, floating, update, {
    //   ancestorScroll: true,
    //   animationFrame: false,
    //   ancestorResize: false,
    //   // elementResize: false
    //   // animationFrame: true,
    // }),
  });

  // Handles opening the floating element via the Choose Emoji button.
  const { getReferenceProps, getFloatingProps } = useInteractions([
    useClick(context),
    useDismiss(context),
    useRole(context),
  ]);

  // // Handles the list navigation where the reference is the inner input, not
  // // the button that opens the floating element.
  // const {
  //   getReferenceProps: getInputProps,
  //   getFloatingProps: getListFloatingProps,
  //   getItemProps,
  // } = useInteractions([

  // ]);

  // // Prevent input losing focus on Firefox VoiceOver
  // const {
  //   'aria-activedescendant': ignoreAria,
  //   ...floatingProps
  // } = getFloatingProps(getListFloatingProps());

  const tmpFunction = (item: any) => {
    const image_types = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp', 'image/vnd.microsoft.icon', 'image/svg+xml'];
    const video_types = ['video/mp4', 'video/webm', 'application/mp4', 'video/mp4', 'video/quicktime', 'video/avi', 'video/mpeg', 'video/x-mpeg', 'video/x-msvideo', 'video/m4v', 'video/x-m4v', 'video/vnd.objectvideo'];

    if (image_types.includes(item?.mime_type)) {
      return (
        <img
          alt=""
          // layoutId={`image-${item?.id}`}
          // key={`image-${item?.id}`}
          // layout
          className={`
              tw-bg-white tw-rounded-md tw-shadow-sm? tw-border tw-p-2
              ${item.dark ? 'tw-bg-slate-800' : 'tw-bg-white'}
              tw-cursor-pointer? tw-select-none tw-max-h-full tw-object-scale-down tw-w-full
              ${type === ('single' as CarouselType) ? 'tw-h-[270px]' : 'tw-h-[120px]'}
              `}
          draggable={false}
          src={item.images['500']}
          // loading="lazy"
        />
      );
    } if (video_types.includes(item?.mime_type)) {
      return (
        <video
          className={`
            tw-bg-white tw-rounded-t-md tw-shadow-sm? tw-border tw-p-2
            tw-cursor-pointer tw-select-none tw-max-h-full tw-w-full
            ${type === ('single' as CarouselType) ? 'tw-h-[270px]' : 'tw-h-[120px]'}
          `}
          draggable={false}
          loop
          autoPlay
          controls={false}
          muted
          src={item.videos['500']}
        />
      );
    } if (item?.mime_type === 'text') {
      return (
        <div
          className={`
            tw-rounded-md tw-bg-white tw-shadow-sm? tw-border tw-p-4
            tw-text-lg tw-align-middle tw-select-none tw-text-gray-700 tw-max-h-full tw-h-full
            tw-justify-self-start tw-self-start tw-line-clamp-[8] tw-w-full

          `}
          draggable={false}
        >
          {item.text}
        </div>
      );
    } if (type === ('single' as CarouselType)) {
      return tmpFunction({ mime_type: 'image/png', images: { 500: 'https://dummyimage.com/500x500/fff/aaa' } });
    }
    // if (item.images && item.images.length > 0) {
    return (
      <div className="tw-h-auto tw-transition hover:tw-shadow-sm? tw-rounded-md">
        <div className={`
                tw-place-content-center tw-flex
              `}
        >
          {tmpFunction((item && item.images && item.images.length > 0 && item.images[0]) || {
            mime_type: 'image/png',
            images: { 500: 'https://dummyimage.com/100x100/fff/aaa' },
          })}
        </div>
        <div className={`
                ${item.relevance === 0
          ? 'tw-bg-sky-800 group-hover:tw-bg-sky-900 tw-text-gray-50 group-hover:tw-text-white'
          : 'tw-bg-white group-hover:tw-bg-slate-100 tw-text-gray-600 group-hover:tw-text-black'}
                tw-border tw-transition tw-rounded-b-md -tw-mt-1 tw-pt-1
                tw-px-1 tw-leading-7 tw-text-xs tw-text-center
                tw-flex tw-place-self-center tw-line-clamp-1 tw-space-x-2
            `}
        >
          { item.sentiment === 0 && <HandThumbUpIcon className="tw-w-3 tw-h-3 tw-inline-block tw-align-text-bottom" /> }
          { item.sentiment === 1 && <HandThumbDownIcon className="tw-w-3 tw-h-3 tw-inline-block tw-align-text-bottom" /> }
          <span>{item && item.title}</span>
        </div>
      </div>
    );
    // } else {
    //   return JSON.stringify(item);
    // }
  };

  // console.log('Item render');

  return (
    <>
      <motion.div
        draggable={false}
        style={{ content: 'strict' }}
        className={`
        tw-isolate tw-relative tw-flow-root
        ${type === ('single' as CarouselType) ? 'tw-max-w-xs sm:tw-max-w-sm md:tw-max-w-md lg:tw-max-w-lg xl:tw-max-w-xl' : 'tw-max-w-[200px]'}
        ${(type === ('single' as CarouselType)) ? 'tw-min-w-[250px]' : 'tw-min-w-[100px]'}
        tw-select-none tw-grid tw-grid-cols-1 tw-grow-0 tw-basis-auto tw-shrink-0 tw-group
        tw-justify-items-stretch tw-justify-center tw-items-stretch
      `}
      >

        <button
          type="button"
          ref={reference}
          id={buttonId}
          // style={{
          //   outline: open ? '2px solid blue' : '',
          // }}
          {...getReferenceProps({
            onClick(e) {
              if (handleMouseClick(e, item)) {
                setOpen(true);
              }
            },
          })}
        >
          {tmpFunction(item)}
        </button>

        <FloatingPortal>
          <AnimatePresence>
            {open && (
            <FloatingFocusManager context={context} initialFocus={1}>

              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                transition={{ duration: 0.2 }}
              >
                <FloatingOverlay className="tw-bg-slate-500/50" onClick={() => setOpen(false)} lockScroll />
                <div
                  ref={floating}
                  style={{
                    position: strategy,
                    left: x ?? 0,
                    top: y ?? 0,
                  }}
                  aria-labelledby={buttonId}
                  {...getFloatingProps()}
                >

                  <div ref={arrowRef} className="tw-absolute tw-bg-slate-50 tw-w-2 tw-h-2 tw-rotate-45" />

                  <div className="tw-bg-white/90 tw-backdrop-blur-lg tw-overflow-hidden? tw-shadow-lg tw-ring tw-ring-slate-100/80 tw-border
                    tw-border-slate-300 tw-rounded-2xl tw-w-[320px] md:tw-w-[350px] tw-min-h-[300px] tw-max-h-[350px]"
                  >
                    <Popup
                      selectedItem={item}
                      setIsPopupOpen={setOpen}
                      setIsComplainOpen={setIsComplainOpen}
                    />
                  </div>
                </div>
              </motion.div>

            </FloatingFocusManager>
            )}
          </AnimatePresence>
        </FloatingPortal>

        {item.is_favorite
        && (
        <StarIcon
          className="tw-drop-shadow-sm? tw-absolute tw-stroke-white tw-fill-yellow-300 tw-w-3 tw-h-3 tw-top-3 tw-right-3"
        />
        )}
      </motion.div>

      <Complain
        entityId={item.entity_id}
        mentionId={item.mention_id}
        entitiesMentionId={item.id}
        opened={isComplainOpen}
        close={() => {
          setIsComplainOpen(false);
        }}
      />
    </>
  );
}

export default React.memo(CarouselItem);
