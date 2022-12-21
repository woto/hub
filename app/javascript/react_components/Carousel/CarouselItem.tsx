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

const imageTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif',
  'image/webp', 'image/vnd.microsoft.icon', 'image/svg+xml'];
const videoTypes = ['video/mp4', 'video/webm', 'application/mp4', 'video/mp4',
  'video/quicktime', 'video/avi', 'video/mpeg', 'video/x-mpeg', 'video/x-msvideo',
  'video/m4v', 'video/x-m4v', 'video/vnd.objectvideo'];

function colorAccordingRelevance(item: any) {
  switch (item.relevance) {
    case 0:
      return 'tw-bg-rose-500 tw-text-white group-hover:tw-text-white';
    case 1:
      return 'tw-bg-yellow-500 tw-text-white group-hover:tw-text-white';
    case 2:
      return 'tw-bg-green-500 tw-text-white group-hover:tw-text-white';
    case 3:
      return 'tw-bg-slate-500 tw-text-white group-hover:tw-text-white';
    default:
      return 'tw-bg-white tw-text-gray-600 group-hover:tw-text-black';
  }
}

function objectSize(item: any, type: 'single' | 'multiple') {
  try {
    const ratio = item.width / item.height || 1;
    const height = type === 'single' ? 250 : 120;
    const maxWidth = type === 'single' ? 400 : 200;
    const minWidth = type === 'single' ? 250 : 120;
    let width = 0;

    if (height * ratio >= maxWidth) {
      width = maxWidth;
    } else if (height * ratio <= minWidth) {
      width = minWidth;
    } else {
      width = height * ratio;
    }

    return { width, height };
  } catch {
    return {};
  }
}

function Image({ item, type }: {item: any, type: CarouselType}) {
  return (
    <img
      style={objectSize(item, type)}
      data-width={item.width}
      data-height={item.height}
      alt=""
      // layoutId={`image-${item?.id}`}
      // key={`image-${item?.id}`}
      // layout
      className={`
          tw-border tw-p-2 tw-h-full tw-w-full
          ${item.dark ? 'tw-bg-slate-800' : 'tw-bg-white'}
          tw-select-none tw-object-scale-down
          ${type === 'single' ? 'tw-rounded-md' : 'tw-rounded-t-md'}
      `}
      draggable={false}
      src={type === 'single' ? item.images['300'] : item.images['200']}
      loading="lazy"
    />
  );
}

function Video({ item, type }: {item: any, type: CarouselType}) {
  return (
    <video
      style={objectSize(item, type)}
      data-width={item.width}
      data-height={item.height}
      className={`
        tw-border tw-p-2 tw-h-full tw-w-full
        ${item.dark ? 'tw-bg-slate-800' : 'tw-bg-white'}
        tw-select-none tw-object-scale-down
        ${type === 'single' ? 'tw-rounded-md' : 'tw-rounded-t-md'}
      `}
      draggable={false}
      loop
      autoPlay
      controls={false}
      muted
      src={type === 'single' ? item.videos['300'] : item.videos['200']}
    />
  );
}

function Multiple({ item, type }: {item: any, type: CarouselType}) {
  return (
    <div className="tw-transition hover:tw-shadow-sm? tw-rounded-md hover:tw-brightness-95">
      <div className="tw-place-content-center? tw-flex-grow? tw-flex-shrink?">
        {tmpFunction((item && item.images && item.images.length > 0 && item.images[0])
            || {
              mime_type: 'image/png',
              images: {
                200: 'https://dummyimage.com/100x100/fff/aaa',
              },
            }, 'multiple')}
      </div>

      <div className={`
              ${colorAccordingRelevance(item)}
              tw-border tw-transition tw-rounded-b-md -tw-mt-px tw-pt-1
              tw-px-1 tw-leading-7 tw-text-xs tw-text-center
              tw-flex tw-place-self-center tw-line-clamp-1 tw-space-x-2
              tw-w-full
          `}
      >
        { item.sentiment === 0 && <HandThumbUpIcon className="tw-w-3 tw-h-3 tw-inline-block tw-align-text-bottom" /> }
        { item.sentiment === 1 && <HandThumbDownIcon className="tw-w-3 tw-h-3 tw-inline-block tw-align-text-bottom" /> }
        <span>{item && item.title}</span>
      </div>

    </div>
  );
}

const tmpFunction = (item: any, type: CarouselType) => {
  if (imageTypes.includes(item?.mime_type)) {
    return <Image item={item} type={type} />;
  } if (videoTypes.includes(item?.mime_type)) {
    return <Video item={item} type={type} />;
  }
  return <Multiple item={item} type={type} />;
};

function CarouselItem({
  item, type, selectedItem, handleMouseClick,
}: {
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

  // console.log('Item render');

  // ${type === 'single' ? 'tw-max-w-xs sm:tw-max-w-sm md:tw-max-w-md lg:tw-max-w-lg xl:tw-max-w-xl' : 'tw-max-w-[200px]'}
  // ${type === 'single' ? 'tw-min-w-[250px]' : 'tw-min-w-[100px]'}

  return (
    <>
      <motion.div
        draggable={false}
        style={{ content: 'strict' }}
        className={`
        tw-isolate tw-relative
        tw-select-none tw-flex tw-group
        ${type === 'multiple' && 'tw-mb-8'}
        ${open ? 'tw-brightness-95' : ''}
      `}
      >

        <a
          href={`/entities/${item.entity_id}`}
          ref={reference}
          id={buttonId}
          draggable={false}
          // eslint-disable-next-line react/jsx-props-no-spreading
          {...getReferenceProps({
            onClick(e) {
              e.preventDefault();

              if (handleMouseClick(e, item)) {
                setOpen(true);
              }
            },
          })}
        >
          <div style={objectSize(type === 'single' ? item : item && item.images && item.images.length > 0 && item.images[0], type)}>
            {tmpFunction(item, type)}
          </div>
        </a>

        <AnimatePresence>
          {open && (
            <FloatingPortal>
              <FloatingFocusManager context={context} initialFocus={1}>

                <motion.div
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  exit={{ opacity: 0 }}
                  transition={{ duration: 0.2 }}
                >
                  <FloatingOverlay
                    className="tw-relative tw-z-10 tw-bg-slate-500/50"
                    onClick={() => setOpen(false)}
                    lockScroll
                  />
                  <div
                    className="tw-z-10"
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
            </FloatingPortal>
          )}
        </AnimatePresence>

        {item.is_favorite
        && (
        <StarIcon
          className="tw-drop-shadow-sm? tw-absolute tw-stroke-white tw-fill-yellow-300 tw-w-3 tw-h-3 tw-top-3 tw-right-3"
        />
        )}
      </motion.div>

      { isComplainOpen
        && (
        <Complain
          entityId={item.entity_id}
          mentionId={item.mention_id}
          entitiesMentionId={item.id}
          opened={isComplainOpen}
          close={() => {
            setIsComplainOpen(false);
          }}
        />
        )}
    </>
  );
}

export default React.memo(CarouselItem);
