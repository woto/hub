import * as React from 'react';
import { Fragment, ReactNode, useState } from 'react';
import {
  StarIcon,
  CalendarIcon,
  FlagIcon,
  PencilSquareIcon,
  ListBulletIcon,
  QueueListIcon,
} from '@heroicons/react/24/outline';
import { motion } from 'framer-motion';
import { ClockIcon } from '@heroicons/react/24/solid';
import { Popover } from '@headlessui/react';
import { ReferenceType } from '@floating-ui/react-dom';
import TimeAgo from '../TimeAgo';
import Timeline from './Timeline';
import openEditEntity from '../system/Utility';
import Complain from '../Complain';
import OldBookmark from '../OldBookmark/OldBookmark';
import DynamicStarIcon from '../DynamicStarIcon';
import ListingsIndex from '../Listings/ListingsIndex';
import { useToasts } from '../Toast/ToastManager';

// tw-bg-indigo-500' : 'tw-bg-transparent'

// const underline = {
//   initial: {
//     backgroundColor: ['hsl(0, 100, 50) 0%', 'hsl(240, 100, 50) 0%'],
//     transition: {
//       duration: 2,
//       type: "tween",
//       ease: "easeIn"
//     }
//   },
//   hover: {
//     backgroundColor: ['hsl(0, 100, 50)', 'hsl(-120, 100, 50)'],
//     transition: {
//       duration: 2,
//       type: "tween",
//       ease: "easeOut"
//     }
// }}
//
// const button = {
//   initial: {
//     color: ['hsl(0, 100, 50) 0%', 'hsl(240, 100, 50) 0%']
//   },
//   hover: {
//     color: ['hsl(0, 100, 50)', 'hsl(-120, 100, 50)']
//   }
// }

// <button
//   type="button"
//   className="tw-flex tw-rounded-md tw-bg-white tw-text-indigo-400 hover:tw-text-indigo-500 focus:tw-ring-2 focus:tw-ring-indigo-500"
//   onClick={(e) => { e.preventDefault(); setOpen(true); }}
// >
//   <ClockIcon className="tw-h-6 tw-w-6 tw-mr-2" aria-hidden="true"/>
//   0
// </button>

export default function Buttons(props: { entityId: number }) {
  const { add } = useToasts();
  const [hoveredTabIdx, setHoveredTabIdx] = useState<number>();
  const [selectedTabIdx, setSelectedTabIdx] = useState<number>();

  const tabs = [
    {
      name: 'Коллекции',
      icon: <QueueListIcon className="tw-w-6 tw-h-6 sm:tw-mr-2 tw-flex-none" />,
      clickHandler: () => { },
      component: (foo: any) => (
        <>
          <ListingsIndex
            entityId={props.entityId}
            opened={selectedTabIdx === 0}
            close={() => setSelectedTabIdx(undefined)}
          />
          {foo}
        </>
      ),
    },
    // {
    //   name: 'Следить',
    //   icon: <StarIcon className="tw-w-6 tw-h-6 sm:tw-mr-2 tw-flex-none" />,
    //   clickHandler: () => {
    //   },
    //   component: (foo: any) =>
    //     // <button
    //     //             className={'tw-flex tw-py-2.5 tw-items-center tw-justify-center tw-w-full tw-border tw-h-full'}
    //     //             onClick={() => {
    //     //               setSelectedTabIdx(tabIdx)
    //     //               tab.clickHandler()
    //     //             }}
    //     //           >
    //     //             {tab.icon}
    //     //             <span className={"tw-hidden sm:tw-inline"}>{tab.name}</span>
    //     //           </button>
    //     (
    //       <Bookmark
    //         foo={(reference: (node: ReferenceType) => void) => (
    //           <Popover.Button
    //             ref={reference}
    //             className={`
    //           tw-rounded-bl-lg tw-group focus:tw-outline-none focus:tw-ring-2
    //           tw-flex tw-py-2.5 tw-items-center tw-justify-center tw-w-full tw-h-full`}
    //           >
    //             <DynamicStarIcon
    //               className="tw-h-6 tw-w-6 group-hover:tw-text-gray-600 tw-mr-1"
    //               isChecked
    //             />
    //             <span className="tw-hidden sm:tw-inline">Подписаться</span>
    //           </Popover.Button>
    //         )}
    //         ext_id={props.entityId}
    //         favorites_items_kind="entities"
    //         is_checked={false}
    //       />
    //     ),

    // },
    {
      name: 'История',
      icon: <CalendarIcon className="tw-w-6 tw-h-6 sm:tw-mr-2 tw-flex-none" />,
      clickHandler: () => {
      },
      component: (foo: any) => (
        <>
          <Timeline
            entityId={props.entityId}
            opened={selectedTabIdx === 1}
            close={() => setSelectedTabIdx(undefined)}
          />
          {foo}
        </>
      ),
    },
    {
      name: 'Редактировать',
      icon: <PencilSquareIcon className="tw-w-6 tw-h-6 sm:tw-mr-2 tw-flex-none" />,
      clickHandler: () => {
        try {
          openEditEntity(props.entityId);
        } catch (error) {
          add('Расширение Chrome не ответило вовремя. Проверьте, что оно установлено.');
        }
      },
      component: (foo: any) => foo,
    },
    {
      name: 'Репорт',
      icon: <FlagIcon className="tw-w-6 tw-h-6 sm:tw-mr-2 tw-flex-none" />,
      clickHandler: () => { },
      component: (foo: any) => (
        <>
          <Complain
            entityId={props.entityId}
            opened={selectedTabIdx === 3}
            close={() => setSelectedTabIdx(undefined)}
          />
          {foo}
        </>
      ),
    },
  ];

  const handleMouseEnter = (tabIdx) => {
    setHoveredTabIdx(tabIdx);
  };

  const handleMouseLeave = (tabIdx) => {
    setHoveredTabIdx(null);
  };

  return (
    <div className="tw-px-4 sm:tw-px-0">
      <div className="tw-block">
        <nav className={`tw-border tw-relative tw-z-0 tw-rounded-x-lg tw-rounded-b-lg tw-shadow?
         tw-flex tw-divide-x tw-divide-gray-200 tw-overflow-hidden? tw-bg-gradient-to-b
         tw-from-gray-50 tw-to-slate-100`}
        >

          {tabs.map((tab, tabIdx) => (

            <Fragment key={tab.name}>

              <motion.div
                layout
                onMouseEnter={() => {
                  handleMouseEnter(tabIdx);
                }}
                onMouseLeave={() => {
                  handleMouseLeave(tabIdx);
                }}
                // variants={button}
                // initial={'initial'}
                // animate={'hover'}
                animate={tabIdx === hoveredTabIdx ? 'hover' : 'initial'}
                className={`
                  ${tabIdx === 0 ? 'tw-rounded-bl-lg' : ''}
                  ${tabIdx === tabs.length - 1 ? 'tw-rounded-br-lg' : ''}
                  tw-select-none tw-cursor-pointer tw-text-gray-500 hover:tw-text-gray-700
                  tw-group tw-relative tw-min-w-0 tw-flex-auto tw-text-sm
                  tw-font-medium focus:tw-z-10 -tw-ml-px`}
              >

                {tab.component(
                  <button
                    type="button"
                    className={`
                    ${tabIdx === 0 ? 'tw-rounded-bl-lg' : ''}
                    ${tabIdx === tabs.length - 1 ? 'tw-rounded-br-lg' : ''}
                    focus:tw-outline-none focus:tw-ring-2 tw-flex
                    tw-py-2.5 tw-items-center tw-justify-center
                    tw-w-full tw-border? tw-h-full`}
                    onClick={() => {
                      setSelectedTabIdx(tabIdx);
                      tab.clickHandler();
                    }}
                  >
                    {tab.icon}
                    <span className="tw-hidden sm:tw-inline">{tab.name}</span>
                  </button>,
                )}

                {tabIdx === hoveredTabIdx
                  ? (
                    <motion.span
                    // animate={tabIdx === selectedTabIdx ? 'hover' : 'initial'}
                      layoutId="underline"
                    // variants={underline}
                      className={`
                    ${tabIdx === 0 ? 'tw-rounded-bl-lg' : ''}
                    ${tabIdx === tabs.length - 1 ? 'tw-rounded-br-lg' : ''}
                    tw-bg-slate-500/10 tw-absolute tw-inset-0 tw-z-10 tw-pointer-events-none`}
                    />
                  ) : null}
              </motion.div>
            </Fragment>
          ))}
        </nav>
      </div>
    </div>
  );
}
